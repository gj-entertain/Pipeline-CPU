`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/21 22:51:09
// Design Name: 
// Module Name: DataMem
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


module DataMem(

    input   wire            clk,MemWrite,
    input   wire            MemRead,
    input   wire    [31:0]  Address,
    input   wire    [31:0]  WriteData,
    output  wire    [31:0]  ReadData
);
    // define the DataMemory:
    // size 代表有多少行
    // 每一行有 32 bits，这个数字是固定的，即 [31:0]
        localparam size = 8;
        reg [31:0] memory [0:(size-1)];

    // initialize the memory:
        integer i;
        initial begin
            // initialize with 0 to all memory
            for (i = 0; i < size ; i = i + 1 )
                memory[i] = 32'd0;
        end

    // write data memory
        always @ (negedge clk)    begin
            if (MemWrite == 1'b1) memory[Address >> 2] = WriteData;
        end

    // read data memory 
        assign ReadData = (MemRead == 1'b1) ? memory[Address >> 2]: 32'd0;

endmodule
