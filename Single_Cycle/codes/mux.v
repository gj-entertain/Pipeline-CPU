`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 21:16:25
// Design Name: 
// Module Name: mux
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


module mux(
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