// define time scale
    `timescale 1ns / 1ps
// --------------------------------------------------------------------
// EFFECT: module Instruction_Mem 用来从 txt 文件中读取一段指令
// DESCRIPTION: 
//      - 无论clock signal, 只要 address 变了 instruction 就会相应变化
//      - 默认情况下只有 30 行 instruction
//      - address 位于 0,4,8,...,116 之间，函数内通过 address 除以4来指代 0:29 的 index      
// FUTURE:
//      - instruction 的总行数是否会变化？
module Instruction_Mem_Jin(
    input wire[31:0] address,
    output wire[31:0] instruction
);
    // define the instruction memory:
    // size 代表有多少行
    // 每一行有 32 bits，这个数字是固定的，即 [31:0]
        localparam size = 30;
        reg [31:0] memory [0:(size-1)];

    // initialize the memory:
        integer i;
        initial begin
            // initialize with 0 to all instructions
            for (i = 0; i < size ; i = i + 1 )
                memory[i] = 32'd0;
            
            // read built-in instructions
            `include "memory.txt"
        end

    // output current instruction
        assign instruction = memory[address >> 2];

endmodule
// --------------------------------------------------------------------
// EFFECT: module Adder_plus_four 用来将 PC 稳定的加4
// DESCRIPTION: 
//      - 无论clock signal, 只要 PC 变了 PC_plus_four 就会相应变化
module Adder_plus_four_Jin(
    input wire[31:0] PC,
    output wire[31:0] PC_plus_four
);
    wire out;
    assign {out, PC_plus_four} = PC + 4 ;
endmodule
// --------------------------------------------------------------------
// EFFECT: module MUX_2_to_1_32 
// DESCRIPTION: 
//      - 无论clock signal, 输入为两个 32 bits, 输出为一个 32 bits
module MUX_2_to_1_32_Jin(
    input wire[31:0] Q_in_0,
    input wire[31:0] Q_in_1,
    input wire PCSrc,
    output reg[31:0] Q_out
);

    always @ (*) begin
        if ( PCSrc == 1'b0 )        Q_out = Q_in_0;
        else if ( PCSrc == 1'b1 )   Q_out = Q_in_1;
    end

endmodule
// --------------------------------------------------------------------
// EFFECT: module PC_Register 在 clock 的 positive edge 时候，会输出 
// DESCRIPTION: 
//      - 与 clock signal 有关，输入为一个 32 bits, 输出为一个 32 bits
//      - 给 PC_out 赋予了初值 32'd0
module  PC_Register_Jin(
    input wire[31:0] PC_in,
    input wire clock,
    output reg[31:0] PC_out
);
    // 给 PC 赋予初值
    initial begin
        PC_out = 32'd0;
    end

    // 之后每一个clock的上升阶段都读入一次PC
    always @ (posedge clock)    begin
        PC_out = PC_in;
    end

endmodule
// --------------------------------------------------------------------
// EFFECT: module IF_ID_Register 在 IF 和 ID 之间的 register 
// DESCRIPTION: 
//      - 与 clock signal 有关，初始化时会赋予初值 0
module IF_ID_Register_Jin(
    input wire[31:0] PC_plus_four_in,
    input wire[31:0] instruction_in,
    input wire clock,
    output reg[31:0] PC_plus_four_out,
    output reg[31:0] instruction_out
);
    initial begin
        PC_plus_four_out    = 32'd0;
        instruction_out     = 32'd0;
    end

    always @ (posedge clock) begin
        PC_plus_four_out = PC_plus_four_in;
        instruction_out = instruction_in;
    end

endmodule
// --------------------------------------------------------------------
// EFFECT: module IF 
// DESCRIPTION: 
//      - 完整的 IF stage，不包含任何 data/control hazard
// FUTURE:
//      - 如何给 PC_plus_four 和 instruction 赋初值？
module IF_Jin(
    input wire PCSrc,
    input wire[31:0] PC_branch,
    input wire Jump,
    input wire[31:0] PC_Jump,
    input wire clock,
    output wire[31:0] PC_plus_four,
    output wire[31:0] instruction
);
    wire[31:0] Wire_1;
    MUX_2_to_1_32_Jin Test1 (
        .Q_in_0(PC_plus_four), .Q_in_1(PC_branch), .PCSrc(PCSrc), 
        .Q_out(Wire_1)
    );

    wire[31:0] Wire_3;
    assign Wire_3 = (Jump) ? PC_Jump : Wire_1;

    wire[31:0] Wire_2;
    PC_Register_Jin Test2 (
        .PC_in(Wire_3), .clock(clock), .PC_out(Wire_2)
    );

    Adder_plus_four_Jin Test3 (
        .PC(Wire_2), .PC_plus_four(PC_plus_four)
    );

    Instruction_Mem_Jin Test4 (
        .address(Wire_2), .instruction(instruction)
    );

endmodule
