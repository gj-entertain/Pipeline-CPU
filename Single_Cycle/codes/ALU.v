`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 22:19:19
// Design Name: 
// Module Name: ALU
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

module Alu (
    input [31:0] Read_data1,
    input [31:0] Read_data2,
    input [31:0] Immediate,
    input ALUSrc,
    input [1:0] ALUOp,
    output reg [31:0] ALUResult, 
    output reg Zero
);
    wire [3:0] ALUControl;
    
    wire [31:0] ALUInput1 = Read_data1;
    wire [31:0] ALUInput2 = ALUSrc ? Immediate : Read_data2;
    
    AluControl AC(.FuncCode(Immediate[5:0]), .ALUOp(ALUOp), .ALUControl(ALUControl));
    
    initial begin
        ALUResult = 32'b0;
        Zero = 0;
    end
    
    always @ (*) begin
        case (ALUControl) 
            4'b0000: ALUResult = ALUInput1 & ALUInput2;
            4'b0001: ALUResult = ALUInput1 | ALUInput2;
            4'b0010: ALUResult = ALUInput1 + ALUInput2;
            4'b0110: ALUResult = ALUInput1 - ALUInput2;
            4'b0111: ALUResult = (ALUInput1 < ALUInput2);
        endcase
        
        if (ALUResult == 31'b0 && ALUOp == 2'b01)
            Zero = 1'b1;
        else
            Zero = 1'b0;
    end
endmodule
