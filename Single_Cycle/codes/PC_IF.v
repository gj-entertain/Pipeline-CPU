`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 21:40:51
// Design Name: 
// Module Name: PC_IF
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


module PC_IF(
    input [31:0] PC,
    output reg [31:0] PC_NEW
    );
    always @(*)
    begin 
        PC_NEW <= PC + 4;
    end
endmodule
