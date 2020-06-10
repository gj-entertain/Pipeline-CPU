`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/18 22:57:16
// Design Name: 
// Module Name: sim_9_EX
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


module sim_9_EX;
    wire clock;
    reg [31:0] Read_data1;
    reg [31:0] Read_data2;
    reg [31:0] Immediate;
    //input [9:0] ID_EX_Control,
    reg ALUSrc;
    reg RegDst;
    reg [1:0] ALUOp;
    reg MemWrite_in;
    reg MemRead_in;
    reg Branch_in;
    reg MemToReg_in;
    reg RegWrite_in;
    reg [4:0] rt;
    reg [4:0] rd;
    reg [31:0] ID_EX_Next_PC;

endmodule
