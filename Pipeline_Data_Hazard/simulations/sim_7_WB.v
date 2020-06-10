`timescale 1ns / 1ps

module sim_7_WB;
    reg [31:0] ALU_Result, ReadData;
    reg MemToReg, RegWrite_in;
    reg [4:0] RegisterRd_in;

    wire [31:0] WriteData;
    wire RegWrite_out;
    wire [4:0] RegisterRd_out;

    initial begin
        #0 begin
            ALU_Result = 32'hffff; ReadData = 32'h1111; MemToReg = 1'b0; RegWrite_in = 1'b0;
            RegisterRd_in = 5'hccccc;
        end
    end

    WB_Jin Test1 (
        .ALU_Result(ALU_Result),    .ReadData(ReadData),    .MemToReg(MemToReg),
        .WriteData(WriteData),      .RegWrite_in(RegWrite_in),  .RegWrite_out(RegWrite_out),
        .RegisterRd_in(RegisterRd_in),  .RegisterRd_out(RegisterRd_out)
    );

    always #17 MemToReg = ~MemToReg;
    always #20 RegWrite_in = ~RegWrite_in;

    initial #200 $stop;
endmodule
