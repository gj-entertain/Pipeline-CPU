`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 23:51:53
// Design Name: 
// Module Name: program_counter
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


module program_counter(
   input clk, 
   input [31:0] PC_in,
   output reg [31:0] PC_out
   
   );
   integer i;
   initial begin
    i <= 0;
   end
   
   always @(posedge clk)
   begin
    i=i+1;
    if(i == 1) 
        PC_out = 32'b0;
    else 
        PC_out = PC_in;
   end
    
endmodule
