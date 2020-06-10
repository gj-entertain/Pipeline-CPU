// define time scale
    `timescale 1ns / 1ps

module sim_3_PC_Register;

    reg clock;
    reg[31:0] PC_in;
    wire[31:0] PC_out;

    PC_Register_Jin Test1 (PC_in, clock, PC_out);

    initial begin
        #0 begin 
            clock = 1'b1; PC_in = 32'd0;
        end
    end

    always #13 PC_in = PC_in + 1;

    always #10 clock = ~clock;

    initial #500 $stop;
endmodule
