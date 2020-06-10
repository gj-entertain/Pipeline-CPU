`timescale 1ns / 1ps

module ID (
    input   wire    [31:0]  PC_plus_four_in,
    //output  wire    [31:0]  PC_plus_four_out,
    input   wire    [4:0]   Index,
    input   wire    [31:0]  instruction,
    
    input   wire    [4:0]   WriteRegister,
    input   wire    [31:0]  WriteData,

    input   wire            RegWrite_in,

    input   wire            clock,
    input   wire            Control_0,
    input   wire    [31:0]  MEM_data,
                            WB_data,
    input   wire    [1:0]  Forward_ID1,
                            Forward_ID2,
    output  wire            ALUSrc,
    output  wire            RegDst,
    output  wire    [1:0]   ALUOp,
    output  wire            MemWrite,
    output  wire            MemRead,
    //output  wire            Branch,
    output  wire            MemToReg,
    output  wire            RegWrite_out,
    //output  wire            Flush,
    output  wire    [31:0]  ReadData_1, ReadData_2,
    output  wire    [31:0]  Immediate, 
    output  wire    [31:0]  PC_Next,
    output  wire    [4:0]   RegisterRs, RegisterRt, RegisterRd,
    output  wire            MayBranch, BranchEq, BranchNeq, Jump, Zero,
    output  wire    [15:0]  number
    
);
 
    Control Test1 (
        .opCode(instruction[31:26]), .Control_0(Control_0),
        .BranchEq(BranchEq), .BranchNeq(BranchNeq), .Jump(Jump),
        .ALUSrc(ALUSrc), .RegDst(RegDst), .ALUOp(ALUOp), 
        .MemWrite(MemWrite), .MemRead(MemRead),
        .MemToReg(MemToReg), .RegWrite(RegWrite_out)
    );

    RegFile Test2 (
        .clock(clock), .RegWrite(RegWrite_in),
        .WriteRegister(WriteRegister), 
        .ReadRegister_1(instruction[25:21]), .ReadRegister_2(instruction[20:16]),
        .WriteData(WriteData),   .number(number),   .Index(Index),
        .ReadData_1(ReadData_1), .ReadData_2(ReadData_2)
    );

    SignExtend Test3 (
        .in(instruction[15:0]), .out(Immediate)
    );
    
    wire [31:0] BranchData_1,BranchData_2;
    MUX_3_to_1_32 M3_1_32_1(
        .Input_0(ReadData_1), .Input_1(WB_data), .Input_2(MEM_data), 
        .Control(Forward_ID1), .Output(BranchData_1)
    );
    
    MUX_3_to_1_32 M3_1_32_2(
        .Input_0(ReadData_2), .Input_1(WB_data), .Input_2(MEM_data), 
        .Control(Forward_ID2), .Output(BranchData_2)    
    );
    
    wire [31:0]  PC_Branch;
    PC_branch PCbranch (
        .PC_plus_four_in(PC_plus_four_in), .Immediate(Immediate),
        .PC_Branch(PC_Branch)
    );
    
    wire [31:0] PC_Jump;
    assign PC_Jump = {PC_plus_four_in[31:28], instruction[25:0], 2'b0};
    
    Is_Zero iz (
        .Input_1(BranchData_1), .Input_2(BranchData_2), .Zero(Zero)
    );
    
     //Flush Detection
//     FlushDetection fd (
//         .BranchEq(BranchEq),         .BranchNeq(BranchNeq),
//         .Zero(Zero),                 .Jump(Jump),
//         .Flush(Flush)
//     );

    assign MayBranch = (instruction[31:26] == 6'h05) || (instruction[31:26] == 6'h04);
    
    PC_next PCnext(
        .BranchEq (BranchEq),   .BranchNeq(BranchNeq),
        .Jump(Jump),            .Zero(Zero),
        .PC_plus_four_in(PC_plus_four_in),
        .PC_Branch(PC_Branch),  .PC_Jump(PC_Jump),
        .PC_Next(PC_Next)
     );

    assign RegisterRs = instruction[25:21];
    assign RegisterRt = instruction[20:16];
    assign RegisterRd = instruction[15:11];

    //assign PC_plus_four_out = PC_plus_four_in;

endmodule // ID

module Control (
    input   wire            Control_0,
    input   wire    [5:0]   opCode,
    output  reg             BranchEq,    
    output  reg             BranchNeq,
    output  reg             Jump,  //ID
    output  reg             ALUSrc,
    output  reg             RegDst,
    output  reg     [1:0]   ALUOp,      //EX
    output  reg             MemWrite,
    output  reg             MemRead,    //MEM 
    output  reg             MemToReg,
    output  reg             RegWrite    //WB
);
    // ∏≥”Ë≥ı÷µ 0
        initial begin
            BranchEq = 1'b0;    BranchNeq = 1'b0;   Jump = 1'b0;
            ALUSrc = 1'b0;      RegDst = 1'b0;      ALUOp = 2'b00;
            MemWrite = 1'b0;    MemRead = 1'b0;
            MemToReg = 1'b0;    RegWrite = 1'b0;
        end

    // ∏≥”Ëøÿ÷∆–≈∫≈
        always @ ( opCode or Control_0) begin
            if ( Control_0 == 1) begin
                BranchEq = 1'b0;    BranchNeq = 1'b0;   Jump = 1'b0;
                ALUSrc = 1'b0;      RegDst = 1'b0;      ALUOp = 2'b00;
                MemWrite = 1'b0;    MemRead = 1'b0; 
                MemToReg = 1'b0;    RegWrite = 1'b0;
            end
            else begin
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
        end
endmodule   // Control

module RegFile (
    input   wire    [4:0]   Index,
    input   wire            clock, RegWrite,
    input   wire    [4:0]   WriteRegister,ReadRegister_1,ReadRegister_2,
    input   wire    [31:0]  WriteData,
    output  wire    [31:0]  ReadData_1, ReadData_2,
    output  wire    [15:0]  number
);
    localparam size = 32;
    reg [31:0] Data_register [0:(size-1)];

    // register ∏≥”Ë≥ı÷µ0
        integer i;
        initial begin
            for ( i = 0; i < size; i = i + 1)
                Data_register[i] = 32'd0;
        end    

    // ∂¡»° register
        assign ReadData_1 = Data_register[ReadRegister_1];
        assign ReadData_2 = Data_register[ReadRegister_2];
        
        wire [31:0] number_32;
        assign number_32 = Data_register[Index];
        
        assign number = number_32[15:0];

    // –¥»Î register
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
    //input   wire    [31:0]  PC_plus_four_in,
    //output  reg     [31:0]  PC_plus_four_out,

    input   wire            clock,

    input   wire            ALUSrc_in,
    input   wire            RegDst_in,
    input   wire    [1:0]   ALUOp_in,
    input   wire            MemWrite_in,
    input   wire            MemRead_in,
    //input   wire            Branch_in,
    input   wire            MemToReg_in,
    input   wire            RegWrite_in,

    output  reg             ALUSrc_out,
    output  reg             RegDst_out,
    output  reg     [1:0]   ALUOp_out,
    output  reg             MemWrite_out,
    output  reg             MemRead_out,
    //output  reg             Branch_out,
    output  reg             MemToReg_out,
    output  reg             RegWrite_out,

    input   wire    [31:0]  ReadData_1_in, ReadData_2_in,
    input   wire    [31:0]  Immediate_in, 
    input   wire    [4:0]   RegisterRs_in, RegisterRt_in, RegisterRd_in,

    output  reg     [31:0]  ReadData_1_out, ReadData_2_out,
    output  reg     [31:0]  Immediate_out, 
    output  reg     [4:0]   RegisterRs_out, RegisterRt_out, RegisterRd_out
);

    initial begin   
        //PC_plus_four_out = 32'd0;
        ALUSrc_out      = 1'b0;
        RegDst_out      = 1'b0;
        ALUOp_out       = 1'b0;
        MemWrite_out    = 1'b0;
        MemRead_out     = 1'b0;
        //Branch_out      = 1'b0;
        MemToReg_out    = 1'b0;
        RegWrite_out    = 1'b0;
        ReadData_1_out  = 32'd0;
        ReadData_2_out  = 32'd0;
        Immediate_out   = 32'd0;
        RegisterRs_out  = 5'b0;
        RegisterRt_out  = 5'd0;
        RegisterRd_out  = 5'd0;
    end

    always @ (posedge clock)    begin
        //PC_plus_four_out = PC_plus_four_in;
        ALUSrc_out      = ALUSrc_in;
        RegDst_out      = RegDst_in;
        ALUOp_out       = ALUOp_in;
        MemWrite_out    = MemWrite_in;
        MemRead_out     = MemRead_in;
        //Branch_out      = Branch_in;
        MemToReg_out    = MemToReg_in;
        RegWrite_out    = RegWrite_in;
        ReadData_1_out  = ReadData_1_in;
        ReadData_2_out  = ReadData_2_in;
        Immediate_out   = Immediate_in;
        RegisterRs_out  = RegisterRs_in;
        RegisterRt_out  = RegisterRt_in;
        RegisterRd_out  = RegisterRd_in;
    end
endmodule

module PC_branch (
    input   [31:0] PC_plus_four_in,
    input   [31:0] Immediate,
    output reg [31:0] PC_Branch
    );
    
    always @(*)
        PC_Branch = PC_plus_four_in + 4*Immediate[15:0];
endmodule

module Is_Zero (
    input [31:0] Input_1,
    input [31:0] Input_2,
    output reg Zero
);
    initial
        Zero = 1'b0;
        
    always @(*)
        Zero = (Input_1 == Input_2);
endmodule

module PC_next (
    input BranchEq,
    input BranchNeq,
    input Zero,
    input Jump,
    input [31:0] PC_plus_four_in,
    input [31:0] PC_Branch,
    input [31:0] PC_Jump,
    output reg [31:0] PC_Next
);
    initial
        PC_Next = 32'b0;
        
    always @(*) begin
        if ((BranchEq & Zero) | (BranchNeq & ~Zero))
            PC_Next = PC_Branch;
        else if (Jump)
            PC_Next = PC_Jump;
        else 
            PC_Next = PC_plus_four_in;
     end
endmodule