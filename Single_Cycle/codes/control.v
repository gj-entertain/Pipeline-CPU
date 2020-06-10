`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 20:09:37
// Design Name: 
// Module Name: control
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


module control(
    input   wire    [5:0]   opCode,

    output  reg             ALUSrc,
    output  reg             RegDst,
    output  reg     [1:0]   ALUOp,

    output  reg             MemWrite,
    output  reg             MemRead,

    output  reg             BranchEq,
    output  reg             BranchNeq,

    output  reg             Jump,

    output  reg             MemToReg,
    output  reg             RegWrite
    );
           initial begin
               ALUSrc = 1'b0; RegDst = 1'b0; ALUOp = 2'b00;
               MemWrite = 1'b0; MemRead = 1'b0; 
               BranchEq = 1'b0; BranchNeq = 1'b0;
               Jump = 1'b0;
               MemToReg = 1'b0; RegWrite = 1'b0;
           end
           always @ ( opCode ) begin
                      case ( opCode )
                          6'b000000: begin // R-type
                              ALUSrc = 1'b0;      RegDst = 1'b1;  ALUOp = 2'b10;
                              MemWrite = 1'b0;    MemRead = 1'b0; 
                              BranchEq = 1'b0;    BranchNeq = 1'b0;
                              Jump = 1'b0;
                              MemToReg = 1'b1;    RegWrite = 1'b1;
                          end
                          6'b000010: begin // j
                              ALUSrc = 1'b0;      RegDst = 1'b1;  ALUOp = 2'b10;
                              MemWrite = 1'b0;    MemRead = 1'b0; 
                              BranchEq = 1'b0;    BranchNeq = 1'b0;
                              Jump = 1'b1;
                              MemToReg = 1'b0;    RegWrite = 1'b0;
                          end
                          6'b000100: begin // beq
                              ALUSrc = 1'b0;      RegDst = 1'b0;  ALUOp = 2'b01;
                              MemWrite = 1'b0;    MemRead = 1'b0; 
                              BranchEq = 1'b1;    BranchNeq = 1'b0;
                              Jump = 1'b0;
                              MemToReg = 1'b0;    RegWrite = 1'b0;
                          end
                          6'b000101: begin // bne
                              ALUSrc = 1'b0;      RegDst = 1'b0;  ALUOp = 2'b01;
                              MemWrite = 1'b0;    MemRead = 1'b0; 
                              BranchEq = 1'b0;    BranchNeq = 1'b1;
                              Jump = 1'b0;
                              MemToReg = 1'b0;    RegWrite = 1'b0;
                          end
                          6'b001000: begin // addi
                              ALUSrc = 1'b1;      RegDst = 1'b0;  ALUOp = 2'b00;
                              MemWrite = 1'b0;    MemRead = 1'b0; 
                              BranchEq = 1'b0;    BranchNeq = 1'b0;
                              Jump = 1'b0;
                              MemToReg = 1'b1;    RegWrite = 1'b1;
                          end
                          6'b001100: begin // andi
                              ALUSrc = 1'b1;      RegDst = 1'b0;  ALUOp = 2'b11;
                              MemWrite = 1'b0;    MemRead = 1'b0; 
                              BranchEq = 1'b0;    BranchNeq = 1'b0;
                              Jump = 1'b0;
                              MemToReg = 1'b1;    RegWrite = 1'b1;
                          end
                          6'b100011: begin // lw
                              ALUSrc = 1'b1;      RegDst = 1'b0;  ALUOp = 2'b00;
                              MemWrite = 1'b0;    MemRead = 1'b1; 
                              BranchEq = 1'b0;    BranchNeq = 1'b0;
                              Jump = 1'b0;
                              MemToReg = 1'b0;    RegWrite = 1'b1;
                          end
                          6'b101011: begin // sw
                              ALUSrc = 1'b1;      RegDst = 1'b0;  ALUOp = 2'b00;
                              MemWrite = 1'b1;    MemRead = 1'b0; 
                              BranchEq = 1'b0;    BranchNeq = 1'b0;
                              Jump = 1'b0;
                              MemToReg = 1'b0;    RegWrite = 1'b0;
                          end
                      endcase
                  end
endmodule
