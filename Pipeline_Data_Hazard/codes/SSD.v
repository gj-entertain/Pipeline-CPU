`timescale 1ns / 1ps

// module SSD_Driver
// EFFECT: 输入�?�? hex 的数字，将其转换�? SSD 模式
module SSD_Driver(
    input   wire    [3:0]   Q_in,
    output  reg     [6:0]   Q_out
);
    initial begin
        Q_out = 7'b1111111;
    end

    always @ (*)    begin
        case( Q_in )
            4'h0:   Q_out = 7'b0000001;
            4'h1:   Q_out = 7'b1001111;
            4'h2:   Q_out = 7'b0010010;
            4'h3:   Q_out = 7'b0000110;
            4'h4:   Q_out = 7'b1001100;
            4'h5:   Q_out = 7'b0100100;
            4'h6:   Q_out = 7'b0100000;
            4'h7:   Q_out = 7'b0001111;
            4'h8:   Q_out = 7'b0000000;
            4'h9:   Q_out = 7'b0000100;
            4'ha:   Q_out = 7'b0001000;
            4'hb:   Q_out = 7'b1100000;
            4'hc:   Q_out = 7'b0110001;
            4'hd:   Q_out = 7'b1000010;
            4'he:   Q_out = 7'b0110000;
            4'hf:   Q_out = 7'b0111000;
            default: 
                    Q_out = 7'b1111111;
        endcase
    end
endmodule

// module Clock_Divider
// EFFECT: 将快速的信号转换成慢速的信号
module Divider_100M_to_500(clock, Output_clock);
    input clock;
    output Output_clock;
    reg Output_clock;
    reg [17:0] Counter;
    
    initial begin #0 Counter = 0; Output_clock = 0; end
        
    always @ (posedge clock)   begin
        if (Counter == 199999) begin Output_clock <= 1; Counter <= 0;  end
        else if (Counter == 1) begin  Output_clock <= 0; Counter <= Counter + 1;  end
        else Counter <= Counter + 1;   
    end
endmodule
module Divide_500_to_1 (clock, Output_clock);
    input clock;
    output Output_clock;
    reg Output_clock;
    reg [8:0] Counter;
    
    initial begin #0 Counter = 0; Output_clock = 0;  end
    
    always @ (posedge clock)   begin
        if (Counter == 499)    begin Output_clock <= 1; Counter <= 0;  end
        else if (Counter == 1)  begin  Output_clock <= 0; Counter <= Counter + 1; end
        else Counter <= Counter + 1;
    end

endmodule

// module Ring_Counter
// EFFECT: 用于计数, counter 满了之后会自动回�? 0
module Ring_Counter(
    input   wire            clock,
    output  reg     [1:0]   counter
);
    initial begin
        counter = 2'd0;
    end

    always @ (posedge clock)    begin
        counter = counter + 1;
    end
endmodule

// module SSD_Display
// EFFECT: 
//      - 输入�?�? 16 bits 的数字，�? SSD 上展�?
//      - 实质上这里输入的clock必须是FPGA自带的clock
module SSD_Display(
    input   wire            Disp_PC,
    input   wire            clock,
    input   wire    [15:0]  Register, PC_out,
    output  wire    [6:0]   Cathodes,
    output  reg     [3:0]   Anodes
);
    wire clock_500Hz, clock_1Hz;
    wire [1:0]  counter;
    reg [3:0]  Q;

    initial begin
        Q = 4'b0000;
        Anodes = 4'b1111;
    end

    Divider_100M_to_500 Test1 (
        .clock(clock), .Output_clock(clock_500Hz)
    );
    Divide_500_to_1 Test2 (
        .clock(clock_500Hz), .Output_clock(clock_1Hz)
    );

    Ring_Counter Test3 (
        .clock(clock_500Hz), .counter(counter)
    );
    
    wire [15:0] number;
    assign number = Disp_PC? PC_out: Register;
    
    always @ ( * ) begin
        case (counter)
            2'b00: begin
                Q = number[15:12];
                Anodes = 4'b0111;
            end
            2'b01: begin
                Q = number[11:8];
                Anodes = 4'b1011;
            end
            2'b10: begin
                Q = number[7:4];
                Anodes = 4'b1101;
            end
            2'b11: begin
                Q = number[3:0];
                Anodes = 4'b1110;
            end
            default: begin
                Q = 4'b0000;
                Anodes = 4'b1111;
            end
        endcase
    end

    SSD_Driver ssd_driver (
        .Q_in(Q), .Q_out(Cathodes)
    );

endmodule

// module Test SSD
module SSD(
    input   wire            clock, 
    input   wire    [4:0]   RegisterIndex,        
    output  wire    [3:0]   Anodes,
    output  wire    [6:0]   Cathodes
);
    reg [31:0] memory [0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            memory[i] = i;
    end

    wire [31:0] number_32;
    assign number_32 = memory[RegisterIndex];
    wire [15:0] number_16;
    assign number_16 = memory[RegisterIndex];

    SSD_Display Test1 (
        .clock(clock), .number(number_16), .Cathodes(Cathodes), .Anodes(Anodes)
    );
endmodule