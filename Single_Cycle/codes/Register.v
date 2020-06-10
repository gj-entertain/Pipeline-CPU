`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 21:21:16
// Design Name: 
// Module Name: Register
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


module Register(
   input   wire            clk,RegWrite,
   input   wire    [4:0]   WriteRegister,ReadRegister_1,ReadRegister_2,
   input   wire    [31:0]  WriteData,
   output  wire    [31:0]  ReadData_1, ReadData_2
);
   parameter size = 64;
   reg [31:0] Data_register [0:(size-1)];

   // ?? regsiter ∏≥”Ë≥ı???
       integer i;
       initial begin
           for ( i = 0; i < size; i = i + 1)
               Data_register[i] = 32'd0;
       end    

   // ∂¡»° register
       assign ReadData_1 = Data_register[ReadRegister_1];
       assign ReadData_2 = Data_register[ReadRegister_2];

   // –¥»Î register
       always @ (negedge clk) begin
           if (RegWrite == 1'b1)
               Data_register[WriteRegister] = WriteData;
       end


endmodule
