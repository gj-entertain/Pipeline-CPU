// define time scale
    `timescale 1ns / 1ps
// --------------------------------------------------------------------
// EFFECT: module DataMemory 
// DESCRIPTION: 
//      - ������һ�� 8 �е����飬ÿһ���� 32 bits��
//      - address λ�� 0,4,8,...,28 ֮�䣬������ͨ�� address ���� 4 ��ָ�� 0:7 �� index      
//      - ���� lw $t0, 8($t1) ����������ȡ $t1 ��ŵ�����[$t1]���� [$t1] ���� 8 �õ� address
//      - �� clock signal �޹�
// REQUIRES: 
//      - ���� lw $t0, 8($t1) �������Ҫ�� [$t1] �����λ����Ϊ 0
// FUTURE:
//      - �Ƿ� 8 �е� DataMemory �᲻����
//      - ���� [$t1] �������λ���� 0 ��ô�죿
module DataMemory_Jin(
    input   wire            clock,
    input   wire            MemWrite,
    input   wire            MemRead,
    input   wire    [31:0]  Address,
    input   wire    [31:0]  WriteData,
    output  wire    [31:0]  ReadData
);
    // define the DataMemory:
    // size �����ж�����
    // ÿһ���� 32 bits����������ǹ̶��ģ��� [31:0]
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
//      - �ж��Ƿ���Ҫ branch
//      - �� clock signal �޹�
// FUTURE:
//      - ��Ҫ�ƶ��� ID �׶�?
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
//      - ������ MEM stage���������κ� data/control hazard
//      - �� clock signal �޹�
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
//      - �� clock signal �й�
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
    // �����ֵ
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