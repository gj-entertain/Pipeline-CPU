`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 21:43:49
// Design Name: 
// Module Name: PC_EX
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


module PC_EX(
    input [31: 0] PC,
    input [31: 0] offset, 
    input [25: 0] address,
    output reg [31:0] PC_J,
    output reg [31:0] PC_B
    );
    always@(*)
    begin
        PC_J <= {PC[31:28],address[25:0],2'b0 };
        PC_B <= PC+{offset[29:0],2'b0};
    end
endmodule
