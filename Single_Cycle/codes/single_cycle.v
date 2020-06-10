`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 23:44:41
// Design Name: 
// Module Name: single_cycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module single_cycle( 
    input clk,
    input reset,
    output [31:0] out
   );
   wire [31:0] PC_origin,PC, instruction,PCadd4,PC_J,PC_B,PC_1,offset,WriteData,ReadData1,ReadData2,ALUResult,ReadData;
   wire ALUSrc,RegDst,MemWrite,MemRead,BranchEq,BranchNeq,Jump,MemToReg, RegWrite,zero,branch ;
   wire [1:0] ALUOp;
   wire [4:0] WriteRegister;
   
   
   program_counter procedure1(clk, PC_origin, PC);
   Instruction pro1(reset, PC, instruction);
   control pro2(instruction[31:26],ALUSrc,RegDst,ALUOp,MemWrite,MemRead,BranchEq,BranchNeq,Jump,MemToReg, RegWrite);
   mux2 RegDST(instruction[20:16],instruction[15:11],RegDst,WriteRegister);
   Register pro3(clk,RegWrite,WriteRegister,instruction[25:21],instruction[20:16],WriteData,ReadData1,ReadData2);
   Alu pro4(ReadData1,ReadData2,offset,ALUSrc,ALUOp,ALUResult,zero); 
   DataMem pro5(clk,MemWrite, MemRead,ALUResult,ReadData2,ReadData);
   mux MemtoReg(ReadData,ALUResult,MemToReg,WriteData);
   
   PC_IF case1(PC,PCadd4);
   SignExtend extend(instruction[15:0],offset);
   PC_EX case2(PCadd4, offset, instruction[25:0],PC_J,PC_B);
   assign branch =  (zero & BranchEq)|(~zero&BranchNeq);
   mux choose1(PCadd4, PC_B,branch ,PC_1);
   mux choose2(PC_1,PC_J,Jump,PC_origin);
   
   assign out = PC;
   
endmodule
