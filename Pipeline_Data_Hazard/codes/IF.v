// define time scale
    `timescale 1ns / 1ps
    
// --------------------------------------------------------------------
    // EFFECT: module IF 
    // DESCRIPTION: 
    //      - ������ IF stage���������κ� data/control hazard
    // FUTURE:
    //      - ��θ� PC_plus_four �� instruction ����ֵ��
    module IF_Jin(
        input wire PCSrc,
        input wire PC_Write,
        input wire[31:0] PC_Next,
        input wire clock,
        output wire[31:0] PC_plus_four,
        output wire[31:0] instruction,
        output wire[15:0] PC_out
    );
        wire[31:0] Wire_1;
        MUX_2_to_1_32_Jin Test1 (
            .Q_in_0(PC_plus_four), .Q_in_1(PC_Next), .PCSrc(PCSrc), 
            .Q_out(Wire_1)
        );
    
        wire[31:0] Wire_2;
        assign PC_out = Wire_2[15:0];
        PC_Register_Jin Test2 (
            .PC_Write(PC_Write),
            .PC_in(Wire_1), .clock(clock), .PC_out(Wire_2)
        );
    
        Adder_plus_four_Jin Test3 (
            .PC(Wire_2), .PC_plus_four(PC_plus_four)
        );
    
        Instruction_Mem_Jin Test4 (
            .address(Wire_2), .instruction(instruction)
        );
    
    endmodule
    
// --------------------------------------------------------------------
// EFFECT: module Instruction_Mem ������ txt �ļ��ж�ȡһ��ָ��
// DESCRIPTION: 
//      - ����clock signal, ֻҪ address ���� instruction �ͻ���Ӧ�仯
//      - Ĭ�������ֻ�� 30 �� instruction
//      - address λ�� 0,4,8,...,116 ֮�䣬������ͨ�� address ����4��ָ�� 0:29 �� index      
// FUTURE:
//      - instruction ���������Ƿ��仯��
module Instruction_Mem_Jin( 
    input wire[31:0] address,
    output wire[31:0] instruction
);
    // define the instruction memory:
    // size �����ж�����
    // ÿһ���� 32 bits����������ǹ̶��ģ��� [31:0]
        localparam size = 64;
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
// EFFECT: module Adder_plus_four ������ PC �ȶ��ļ�4
// DESCRIPTION: 
//      - ����clock signal, ֻҪ PC ���� PC_plus_four �ͻ���Ӧ�仯
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
//      - ����clock signal, ����Ϊ���� 32 bits, ���Ϊһ�� 32 bits
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
// EFFECT: module PC_Register �� clock �� positive edge ʱ�򣬻���� 
// DESCRIPTION: 
//      - �� clock signal �йأ�����Ϊһ�� 32 bits, ���Ϊһ�� 32 bits
//      - �� PC_out �����˳�ֵ 32'd0
module  PC_Register_Jin(
    input wire PC_Write,
    input wire clock,
    input wire[31:0] PC_in,
    output reg[31:0] PC_out
);
    // �� PC �����ֵ
    initial begin
        //PC_out = 32'hfffffffc;
        PC_out = 32'b0;
    end

    // ֮��ÿһ��clock�������׶ζ�����һ��PC
    always @ (posedge clock)    begin
        if (PC_Write)   
            PC_out <= PC_in;
    end

endmodule
// --------------------------------------------------------------------
// EFFECT: module IF_ID_Register �� IF �� ID ֮��� register 
// DESCRIPTION: 
//      - �� clock signal �йأ���ʼ��ʱ�ḳ���ֵ 0
module IF_ID_Register_Jin(
    input wire[31:0] PC_plus_four_in,
    input wire[31:0] instruction_in,
    input wire clock,
    input wire IF_ID_Write,
    input wire Flush,
    output reg[31:0] PC_plus_four_out,
    output reg[31:0] instruction_out
);
    initial begin
        PC_plus_four_out    = 32'd0;
        instruction_out     = 32'd0;
    end

    always @ (posedge clock) begin
        if (IF_ID_Write) begin
            PC_plus_four_out = PC_plus_four_in;
            instruction_out = instruction_in;
            if (Flush) begin
                instruction_out = 32'b00000000000000000000000000100000;
                PC_plus_four_out = 32'b0;
            end
        end
    end
endmodule

