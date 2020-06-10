// define time scale
    `timescale 1ns / 1ps
// --------------------------------------------------------------------
// EFFECT: module WB 
// DESCRIPTION: 
//      - 完整的 WB stage，不包含任何 data/control hazard
//      - 与 clock signal 无关
module WB_Jin(
    input   wire    [31:0]  ALU_Result,
    input   wire    [31:0]  ReadData,
    input   wire            MemToReg,
    output  wire    [31:0]  WriteData,

    input   wire            RegWrite_in,
    output  wire            RegWrite_out,

    input   wire    [4:0]   RegisterRd_in,
    output  wire    [4:0]   RegisterRd_out    
);

    // RegisterRd 
        assign  RegisterRd_out = RegisterRd_in;

    // RegWrite
        assign  RegWrite_out = RegWrite_in;
    
    // MUX
        MUX_2_to_1_32_Jin Test1 (
            .Q_in_0(ReadData),  .Q_in_1(ALU_Result),
            .PCSrc(MemToReg),   .Q_out(WriteData)
        );
endmodule
