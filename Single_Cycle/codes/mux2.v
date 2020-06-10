`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 00:09:59
// Design Name: 
// Module Name: mux2
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


module mux2(
   input wire[4:0] Q_in_0,
   input wire[4:0] Q_in_1,
   input wire PCSrc,
   output reg[4:0] Q_out
);

   always @ (*) begin
       if ( PCSrc == 1'b0 )        Q_out = Q_in_0;
       else if ( PCSrc == 1'b1 )   Q_out = Q_in_1;
   end

endmodule


