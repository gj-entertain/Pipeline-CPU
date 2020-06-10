`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Execute (
    input [31:0] Read_data1,
    input [31:0] Read_data2,
    input [31:0] Immediate,
    input ALUSrc,
    input RegDst,
    input [1:0] ALUOp,
    input MemWrite_in,
    input MemRead_in,
    input BranchEq_in,
    input BranchNeq_in,
    input MemToReg_in,
    input RegWrite_in,
    input [4:0] rt,
    input [4:0] rd,
    input [31:0] ID_EX_Next_PC,
    input [31:0] PC_Jump_in,
    input Jump_in,
    output wire [31:0] ALUResult,
    output wire Zero,
    output reg [4:0] WriteReg,
    output wire [31:0] Write_data,
    output reg [31:0] EX_MEM_NEXT_PC,
    output wire MemWrite_out,
    output wire MemRead_out,
    output wire BranchEq_out,
    output wire BranchNeq_out,
    output wire MemToReg_out,
    output wire RegWrite_out,
    output wire [31:0] PC_Jump_out,
    output wire Jump_out
);
    
    assign MemWrite_out = MemWrite_in;
    assign MemRead_out = MemRead_in;
    assign MemRead_out = MemRead_in;
    assign BranchEq_out = BranchEq_in;
    assign BranchNeq_out = BranchNeq_in;
    assign MemToReg_out = MemToReg_in;
    assign RegWrite_out = RegWrite_in;
    assign PC_Jump_out = PC_Jump_in;
    assign Jump_out = Jump_in;
    
    assign Write_data = Read_data2;
    Alu ALU(
        .Read_data1(Read_data1), .Read_data2(Read_data2), .Immediate(Immediate), 
        .ALUSrc(ALUSrc), .ALUOp(ALUOp), .ALUResult(ALUResult), .Zero(Zero));
    
    always @ (*) begin
        WriteReg =  RegDst ? rd : rt;
        EX_MEM_NEXT_PC = ID_EX_Next_PC + 4 + 4*Immediate[15:0];
    end
endmodule

module Alu (
    input [31:0] Read_data1,
    input [31:0] Read_data2,
    input [31:0] Immediate,
    input ALUSrc,
    input [1:0] ALUOp,
    output reg [31:0] ALUResult, 
    output reg Zero
);
    wire [3:0] ALUControl;
    
    wire [31:0] ALUInput1 = Read_data1;
    wire [31:0] ALUInput2 = ALUSrc ? Immediate : Read_data2;
    
    AluControl AC(.FuncCode(Immediate[5:0]), .ALUOp(ALUOp), .ALUControl(ALUControl));
    
    initial begin
        ALUResult = 32'b0;
        Zero = 0;
    end
    
    always @ (*) begin
        case (ALUControl) 
            4'b0000: ALUResult = ALUInput1 & ALUInput2;
            4'b0001: ALUResult = ALUInput1 | ALUInput2;
            4'b0010: ALUResult = ALUInput1 + ALUInput2;
            4'b0110: ALUResult = ALUInput1 - ALUInput2;
            4'b0111: ALUResult = (ALUInput1 < ALUInput2);
        endcase
        
        if (ALUResult == 31'b0 && ALUOp == 2'b01)
            Zero = 1'b1;
        else
            Zero = 1'b0;
    end
endmodule

module AluControl (
    input [5:0] FuncCode,
    input [1:0] ALUOp,
    output reg [3:0] ALUControl
);
    
    initial begin
        ALUControl = 4'b0;
    end
    
    always @ (*) begin
        if (ALUOp == 2'b00) ALUControl = 4'b0010;
        else if (ALUOp == 2'b01) ALUControl = 4'b0110;
        else if (ALUOp == 2'b10)
            case (FuncCode) 
                6'h20: ALUControl = 4'b0010;
                6'h22: ALUControl = 4'b0110;
                6'h24: ALUControl = 4'b0000;
                6'h25: ALUControl = 4'b0001;
                6'h2a: ALUControl = 4'b0111;
            endcase
		else if (ALUOp == 2'b11) ALUControl = 4'b0000;
    end
endmodule

module EX_MEM_Register (
    input clock,
    input [31:0] ALUResult_in,
    input Zero_in,
    input [4:0] WriteReg_in,
    input [31:0] Write_data_in,
    input [31:0] EX_MEM_NEXT_PC_in,
    input MemWrite_in,
    input MemRead_in,
    input BranchEq_in,
    input BranchNeq_in,
    input MemToReg_in,
    input RegWrite_in,
    input [31:0] PC_Jump_in,
    input Jump_in,
    output reg [31:0] ALUResult_out,
    output reg Zero_out,
    output reg [4:0] WriteReg_out,
    output reg [31:0] Write_data_out,
    output reg [31:0] EX_MEM_NEXT_PC_out,
    output reg MemWrite_out,
    output reg MemRead_out,
    output reg BranchEq_out,
    output reg BranchNeq_out,
    output reg MemToReg_out,
    output reg RegWrite_out,
    output reg [31:0] PC_Jump_out,
    output reg Jump_out
);
    
    initial begin
        ALUResult_out = 32'b0;
        Zero_out = 0;
        WriteReg_out = 5'b0;
        Write_data_out = 32'b0;
        EX_MEM_NEXT_PC_out = 32'b0;
        MemWrite_out = 0;
        MemRead_out = 0;
        BranchEq_out = 0;
        BranchNeq_out = 0;
        MemToReg_out = 0;
        RegWrite_out = 0;
        PC_Jump_out = 32'b0;
        Jump_out = 0;
    end
    
    always @(posedge clock) begin
        ALUResult_out = ALUResult_in;
        Zero_out = Zero_in;
        WriteReg_out = WriteReg_in;
        Write_data_out = Write_data_in;
        EX_MEM_NEXT_PC_out = EX_MEM_NEXT_PC_in;
        MemWrite_out = MemWrite_in;
        MemRead_out = MemRead_in;
        BranchEq_out = BranchEq_in;
        BranchNeq_out = BranchNeq_in;
        MemToReg_out = MemToReg_in;
        RegWrite_out = RegWrite_in;    
        PC_Jump_out = PC_Jump_in;
        Jump_out = Jump_in;   
    end
endmodule
