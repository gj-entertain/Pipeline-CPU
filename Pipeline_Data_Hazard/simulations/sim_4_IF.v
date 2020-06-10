`timescale 1ns / 1ps

module sim_4_IF;
    reg PCSrc, clock;
    reg[31:0] PC_branch;
    wire [31:0] PC_plus_four, instruction;

    initial     begin
        #0 begin    
            PCSrc = 1'b0; PC_branch = 32'd0; clock = 1'b0;
        end
    end

    wire[31:0] Wire_1, Wire_2;
    IF_Jin Test1 (
        .PCSrc(PCSrc), .PC_branch(PC_branch), .clock(clock),
        .PC_plus_four(Wire_1), .instruction(Wire_2)
    );
    IF_ID_Register_Jin Test2 (
        .PC_plus_four_in(Wire_1), .instruction_in(Wire_2), .clock(clock),
        .PC_plus_four_out(PC_plus_four), .instruction_out(instruction)
    );

    always #23 PCSrc = ~PCSrc;
    always #10 clock = ~clock;

    initial #500 $stop;
endmodule
