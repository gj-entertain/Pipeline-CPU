`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 22:40:03
// Design Name: 
// Module Name: Alu_control
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


module AluControl(
    input [5:0] FuncCode,
    input [1:0] ALUOp,
    output reg [3:0] ALUControl
);
    
    initial begin
        ALUControl = 4'b0;
    end
    
    always @ (*) begin
        if (ALUOp == 2'b00) ALUControl = 4'b0010;
        else if (ALUOp == 2'b01) ALUControl = 4'b0110;
        else if (ALUOp == 2'b10)
            case (FuncCode) 
                6'h20: ALUControl = 4'b0010;
                6'h22: ALUControl = 4'b0110;
                6'h24: ALUControl = 4'b0000;
                6'h25: ALUControl = 4'b0001;
                6'h2a: ALUControl = 4'b0111;
            endcase
		else if (ALUOp == 2'b11) ALUControl = 4'b0000;
    end
endmodule