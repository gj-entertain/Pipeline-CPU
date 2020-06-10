// define time scale
    `timescale 1ns / 1ps
// --------------------------------------------------------------------
// EFFECT: module DataMemory 
// DESCRIPTION: 
//      - 创建了一个 8 行的数组，每一行有 32 bits；
//      - address 位于 0,4,8,...,28 之间，函数内通过 address 除以 4 来指代 0:7 的 index      
//      - 例如 lw $t0, 8($t1) 这种命令，会读取 $t1 存放的内容[$t1]，将 [$t1] 加上 8 得到 address
//      - 与 clock signal 无关
// REQUIRES: 
//      - 例如 lw $t0, 8($t1) 这种命令，要求 [$t1] 最后两位必须为 0
// FUTURE:
//      - 是否 8 行的 DataMemory 会不够？
//      - 假如 [$t1] 的最后两位不是 0 怎么办？
module DataMemory_Jin(
    input   wire            clock,
    input   wire            MemWrite,
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
        always @ (negedge clock)    begin
            if (MemWrite == 1'b1) memory[Address >> 2] = WriteData;
        end

    // read data memory 
        assign ReadData = (MemRead == 1'b1) ? memory[Address >> 2]: 32'd0;

endmodule
// --------------------------------------------------------------------
// EFFECT: module Branch 
// DESCRIPTION: 
//      - 判断是否需要 branch
//      - 与 clock signal 无关
// FUTURE:
//      - 需要移动到 ID 阶段?
//module Judge_Branch_Jin(
//    input   wire    Branch,     
//    input   wire    Is_Zero,
//    output  wire    PCSrc
//);
//    assign PCSrc = Branch & Is_Zero;    
//endmodule
// --------------------------------------------------------------------
// EFFECT: module MEM
// DESCRIPTION: 
//      - 完整的 MEM stage，不包含任何 data/control hazard
//      - 与 clock signal 无关
module MEM_Jin(
    input   wire            MemToReg_in,
    output  wire            MemToReg_out,

    input   wire            RegWrite_in,
    output  wire            RegWrite_out,

    input   wire    [31:0]  ALU_Result_in,
    output  wire    [31:0]  ALU_Result_out,

    input   wire    [4:0]   RegisterRd_in,
    output  wire    [4:0]   RegisterRd_out,
    
    input   wire            clock,

    //input   wire            Branch,
    //input   wire            Is_Zero,
    //output  wire            PCSrc,

    input   wire            MemWrite,
    input   wire            MemRead,
    input   wire    [31:0]  WriteData,
    output  wire    [31:0]  ReadData
    
    //input   wire    [31:0]  PC_Branch_in,
    //output  wire    [31:0]  PC_Branch_out
);
    // WB signals
        assign  MemToReg_out = MemToReg_in;
        assign  RegWrite_out = RegWrite_in;
    
    // PCSrc with means branch command takes place
//        Judge_Branch_Jin Test1 (
//            .Branch(Branch),    .Is_Zero(Is_Zero),  .PCSrc(PCSrc)
//        );

    // Data Memory
        DataMemory_Jin Test2 (
            .MemWrite(MemWrite),    .MemRead(MemRead),  .Address(ALU_Result_in),
            .WriteData(WriteData),  .ReadData(ReadData),.clock(clock)
        );

    // RegisterRd
        assign  RegisterRd_out = RegisterRd_in;

    // ALU_Result
        assign  ALU_Result_out = ALU_Result_in;

    // PC_Branch
    //    assign  PC_Branch_out = PC_Branch_in;

endmodule
// --------------------------------------------------------------------
// EFFECT: module MEM_WB_Register
// DESCRIPTION: 
//      - 与 clock signal 有关
module MEM_WB_Register_Jin(
    input   wire            MemToReg_in,
    output  reg             MemToReg_out,

    input   wire            RegWrite_in,
    output  reg             RegWrite_out,

    input   wire    [31:0]  ReadData_in,
    output  reg     [31:0]  ReadData_out,

    input   wire    [31:0]  ALU_Result_in,
    output  reg     [31:0]  ALU_Result_out,

    input   wire    [4:0]   RegisterRd_in,
    output  reg     [4:0]   RegisterRd_out,

    input   wire            clock
);
    // 赋予初值
        initial     begin
            MemToReg_out    =   1'b0;
            RegWrite_out    =   1'b0;
            ReadData_out    =   32'd0;
            ALU_Result_out  =   32'd0;
            RegisterRd_out  =   5'd0;
        end

    // 
        always @ (posedge clock)    begin
            MemToReg_out    =   MemToReg_in;
            RegWrite_out    =   RegWrite_in;
            ReadData_out    =   ReadData_in;
            ALU_Result_out  =   ALU_Result_in;
            RegisterRd_out  =   RegisterRd_in;
        end
endmodule