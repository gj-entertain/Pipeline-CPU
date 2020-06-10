`timescale 1ns / 1ps

module ID (
    input   wire    [31:0]  PC_plus_four_in,
    output  wire    [31:0]  PC_plus_four_out,

    input   wire    [31:0]  instruction,
    
    input   wire    [4:0]   WriteRegister,
    input   wire    [31:0]  WriteData,

    input   wire            RegWrite_in,

    input   wire            clock,

    output  wire            ALUSrc,
    output  wire            RegDst,
    output  wire    [1:0]   ALUOp,
    output  wire            MemWrite,
    output  wire            MemRead,
    output  wire            BranchEq,
    output  wire            BranchNeq,
    output  wire            MemToReg,
    output  wire            RegWrite_out,
    output  wire            Jump,

    output  wire    [31:0]  PC_Jump,

    output  wire    [31:0]  ReadData_1, ReadData_2,
    output  wire    [31:0]  Immediate, 
    output  wire    [4:0]   RegisterRt, RegisterRd
);

    Control Test1 (
        .opCode(instruction[31:26]), 
        .ALUSrc(ALUSrc), .RegDst(RegDst), .ALUOp(ALUOp), 
        .MemWrite(MemWrite), .MemRead(MemRead), 
        .BranchEq(BranchEq), .BranchNeq(BranchNeq),
        .Jump(Jump),
        .MemToReg(MemToReg), .RegWrite(RegWrite_out)
    );

    RegFile Test2 (
        .clock(clock), .RegWrite(RegWrite_in),
        .WriteRegister(WriteRegister), 
        .ReadRegister_1(instruction[25:21]), .ReadRegister_2(instruction[20:16]),
        .WriteData(WriteData), 
        .ReadData_1(ReadData_1), .ReadData_2(ReadData_2)
    );

    SignExtend Test3 (
        .in(instruction[15:0]), .out(Immediate)
    );

    assign RegisterRt = instruction[20:16];
    assign RegisterRd = instruction[15:11];

    assign PC_plus_four_out = PC_plus_four_in;

    assign PC_Jump = {PC_plus_four_in[31:28], instruction[25:0], 2'b0};

endmodule // ID

module Control (
    input   wire    [5:0]   opCode,

    output  reg             ALUSrc,
    output  reg             RegDst,
    output  reg     [1:0]   ALUOp,

    output  reg             MemWrite,
    output  reg             MemRead,

    output  reg             BranchEq,
    output  reg             BranchNeq,

    output  reg             Jump,

    output  reg             MemToReg,
    output  reg             RegWrite
);
    // 赋予初�?? 0
        initial begin
            ALUSrc = 1'b0; RegDst = 1'b0; ALUOp = 2'b00;
            MemWrite = 1'b0; MemRead = 1'b0; 
            BranchEq = 1'b0; BranchNeq = 1'b0;
            Jump = 1'b0;
            MemToReg = 1'b0; RegWrite = 1'b0;
        end

    // 赋予控制信号
        always @ ( opCode ) begin
            case ( opCode )
                6'b000000: begin // R-type
                    ALUSrc = 1'b0;      RegDst = 1'b1;  ALUOp = 2'b10;
                    MemWrite = 1'b0;    MemRead = 1'b0; 
                    BranchEq = 1'b0;    BranchNeq = 1'b0;
                    Jump = 1'b0;
                    MemToReg = 1'b1;    RegWrite = 1'b1;
                end
                6'b000010: begin // j
                    ALUSrc = 1'b0;      RegDst = 1'b1;  ALUOp = 2'b10;
                    MemWrite = 1'b0;    MemRead = 1'b0; 
                    BranchEq = 1'b0;    BranchNeq = 1'b0;
                    Jump = 1'b1;
                    MemToReg = 1'b0;    RegWrite = 1'b0;
                end
                6'b000100: begin // beq
                    ALUSrc = 1'b0;      RegDst = 1'b0;  ALUOp = 2'b01;
                    MemWrite = 1'b0;    MemRead = 1'b0; 
                    BranchEq = 1'b1;    BranchNeq = 1'b0;
                    Jump = 1'b0;
                    MemToReg = 1'b0;    RegWrite = 1'b0;
                end
                6'b000101: begin // bne
                    ALUSrc = 1'b0;      RegDst = 1'b0;  ALUOp = 2'b01;
                    MemWrite = 1'b0;    MemRead = 1'b0; 
                    BranchEq = 1'b0;    BranchNeq = 1'b1;
                    Jump = 1'b0;
                    MemToReg = 1'b0;    RegWrite = 1'b0;
                end
                6'b001000: begin // addi
                    ALUSrc = 1'b1;      RegDst = 1'b0;  ALUOp = 2'b00;
                    MemWrite = 1'b0;    MemRead = 1'b0; 
                    BranchEq = 1'b0;    BranchNeq = 1'b0;
                    Jump = 1'b0;
                    MemToReg = 1'b1;    RegWrite = 1'b1;
                end
                6'b001100: begin // andi
                    ALUSrc = 1'b1;      RegDst = 1'b0;  ALUOp = 2'b11;
                    MemWrite = 1'b0;    MemRead = 1'b0; 
                    BranchEq = 1'b0;    BranchNeq = 1'b0;
                    Jump = 1'b0;
                    MemToReg = 1'b1;    RegWrite = 1'b1;
                end
                6'b100011: begin // lw
                    ALUSrc = 1'b1;      RegDst = 1'b0;  ALUOp = 2'b00;
                    MemWrite = 1'b0;    MemRead = 1'b1; 
                    BranchEq = 1'b0;    BranchNeq = 1'b0;
                    Jump = 1'b0;
                    MemToReg = 1'b0;    RegWrite = 1'b1;
                end
                6'b101011: begin // sw
                    ALUSrc = 1'b1;      RegDst = 1'b0;  ALUOp = 2'b00;
                    MemWrite = 1'b1;    MemRead = 1'b0; 
                    BranchEq = 1'b0;    BranchNeq = 1'b0;
                    Jump = 1'b0;
                    MemToReg = 1'b0;    RegWrite = 1'b0;
                end
            endcase
        end
endmodule   // Control

module RegFile (
    input   wire            clock, RegWrite,
    input   wire    [4:0]   WriteRegister,ReadRegister_1,ReadRegister_2,
    input   wire    [31:0]  WriteData,
    output  wire    [31:0]  ReadData_1, ReadData_2
);
    localparam size = 32;
    reg [31:0] Data_register [0:(size-1)];

    // �? regsiter 赋予初�??
        integer i;
        initial begin
            for ( i = 0; i < size; i = i + 1)
                Data_register[i] = 32'd0;
        end    

    // 读取 register
        assign ReadData_1 = Data_register[ReadRegister_1];
        assign ReadData_2 = Data_register[ReadRegister_2];

    // 写入 register
        always @ (negedge clock) begin
            if (RegWrite == 1'b1)
                Data_register[WriteRegister] = WriteData;
        end

endmodule // RegFile

module SignExtend (
    input   wire    [15:0]  in,
    output  wire    [31:0]  out
);

    assign out = {{16{in[15]}}, in[15:0]};

endmodule // SignExtend

module ID_EX_Register (
    input   wire    [31:0]  PC_plus_four_in,
    output  reg     [31:0]  PC_plus_four_out,

    input   wire    [31:0]  PC_Jump_in,
    output  reg     [31:0]  PC_Jump_out,

    input   wire            clock,

    input   wire            ALUSrc_in,
    input   wire            RegDst_in,
    input   wire    [1:0]   ALUOp_in,
    input   wire            MemWrite_in,
    input   wire            MemRead_in,
    input   wire            BranchEq_in,
    input   wire            BranchNeq_in,
    input   wire            MemToReg_in,
    input   wire            RegWrite_in,
    input   wire            Jump_in,

    output  reg             ALUSrc_out,
    output  reg             RegDst_out,
    output  reg     [1:0]   ALUOp_out,
    output  reg             MemWrite_out,
    output  reg             MemRead_out,
    output  reg             BranchEq_out,
    output  reg             BranchNeq_out,
    output  reg             MemToReg_out,
    output  reg             RegWrite_out,
    output  reg             Jump_out,

    input   wire    [31:0]  ReadData_1_in, ReadData_2_in,
    input   wire    [31:0]  Immediate_in, 
    input   wire    [4:0]   RegisterRt_in, RegisterRd_in,

    output  reg     [31:0]  ReadData_1_out, ReadData_2_out,
    output  reg     [31:0]  Immediate_out, 
    output  reg     [4:0]   RegisterRt_out, RegisterRd_out
);

    initial begin   
        PC_plus_four_out = 32'd0;
        PC_Jump_out     = 32'b0;
        ALUSrc_out      = 1'b0;
        RegDst_out      = 1'b0;
        ALUOp_out       = 1'b0;
        MemWrite_out    = 1'b0;
        MemRead_out     = 1'b0;
        BranchEq_out    = 1'b0;
        BranchNeq_out   = 1'b0;
        MemToReg_out    = 1'b0;
        RegWrite_out    = 1'b0;
        Jump_out        = 1'b0;
        ReadData_1_out  = 32'd0;
        ReadData_2_out  = 32'd0;
        Immediate_out   = 32'd0;
        RegisterRt_out  = 5'd0;
        RegisterRd_out  = 5'd0;
    end

    always @ (posedge clock)    begin
        PC_plus_four_out = PC_plus_four_in;
        PC_Jump_out     = PC_Jump_in;
        ALUSrc_out      = ALUSrc_in;
        RegDst_out      = RegDst_in;
        ALUOp_out       = ALUOp_in;
        MemWrite_out    = MemWrite_in;
        MemRead_out     = MemRead_in;
        BranchEq_out    = BranchEq_in;
        BranchNeq_out   = BranchNeq_in;
        MemToReg_out    = MemToReg_in;
        RegWrite_out    = RegWrite_in;
        Jump_out        = Jump_in;
        ReadData_1_out  = ReadData_1_in;
        ReadData_2_out  = ReadData_2_in;
        Immediate_out   = Immediate_in;
        RegisterRt_out  = RegisterRt_in;
        RegisterRd_out  = RegisterRd_in;
    end

endmodule