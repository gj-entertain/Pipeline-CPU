// define time scale
    `timescale 1ns / 1ps

// Simulation for IF
module simulation;

    reg[31:0] address_1 = 32'd0;
    reg[31:0] address_2 = 32'd116;

    wire[31:0] instruction_1;
    wire[31:0] instruction_2;

    Instruction_Mem_Jin Test1 (address_1, instruction_1);

    Instruction_Mem_Jin Test2 (address_2, instruction_2);

    initial #1000 $stop;
endmodule // simulation