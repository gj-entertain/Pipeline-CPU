`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Execute (//Read_data1, Read_data2, Immediate, ID_EX_Control, rt, rd, ID_EX_Next_PC, AluResult, Zero, EX_MEM_Control, WriteReg, Write_data, EX_MEM_NEXT_PC);
    
    input [31:0] Read_data1,
    input [31:0] Read_data2,
    input [31:0] Immediate,
    input ALUSrc,
    input RegDst,
    input [1:0] ALUOp,
    input MemWrite_in,
    input MemRead_in,
    //input Branch_in,
    input MemToReg_in,
    input RegWrite_in,
    input [4:0] rt,
    input [4:0] rd,
    //input [31:0] ID_EX_Next_PC,
    ///////////////////////////////////////////////////
    input [31:0] MEM_data,
    input [31:0] WB_data,
    input [1:0] Forward_ALU1, 
    input [1:0] Forward_ALU2,
    ///////////////////////////////////////////////////
    output wire [31:0] ALUResult,
    //output wire Zero,
    output reg [4:0] WriteReg,
    output wire [31:0] Write_data,
    //output reg [31:0] EX_MEM_NEXT_PC,
    output wire MemWrite_out,
    output wire MemRead_out,
    //output wire Branch_out,
    output wire MemToReg_out,
    output wire RegWrite_out);
    
    assign MemWrite_out = MemWrite_in;
    assign MemRead_out = MemRead_in;
    //assign Branch_out = Branch_in;
    assign MemToReg_out = MemToReg_in;
    assign RegWrite_out = RegWrite_in;
    
    wire [31:0] ALU_data1, ALU_data2;
    wire [31:0] Mem_ALU_input2;
    wire [3:0] ALUControl;
    
    assign Write_data = Mem_ALU_input2;
    
    MUX_2_to_1_32 M2_1_32_1(
        .Input_0(Write_data), .Input_1(Immediate),
        .Control(ALUSrc), .Output(ALU_data2)
    );
    
    MUX_3_to_1_32 M3_1_32_1(
        .Input_0(Read_data1), .Input_1(WB_data), .Input_2(MEM_data), 
        .Control(Forward_ALU1), .Output(ALU_data1)
    );
    
    MUX_3_to_1_32 M3_1_32_2(
        .Input_0(Read_data2), .Input_1(WB_data), .Input_2(MEM_data), 
        .Control(Forward_ALU2), .Output(Write_data)    
    );
    
    AluControl AC(
        .FuncCode(Immediate[5:0]), .ALUOp(ALUOp), .ALUControl(ALUControl)
    );
    
    Alu ALU(
        .ALU_data1(ALU_data1), .ALU_data2(ALU_data2), .ALUControl(ALUControl), 
        .ALUResult(ALUResult));// .Zero(Zero));
    
    always @ (*) begin
        WriteReg =  RegDst ? rd : rt;
        //EX_MEM_NEXT_PC = ID_EX_Next_PC + 4 + 4*Immediate[15:0];
    end
endmodule

module MUX_2_to_1_32 (
    input [31:0] Input_0, Input_1,
    input Control,
    output reg [31:0] Output);
    
    always @(*) begin
        case (Control)
            1'b0: Output = Input_0;
            1'b1: Output = Input_1;
        endcase
    end 
endmodule

module MUX_3_to_1_32 (
    input [31:0] Input_0, Input_1, Input_2,
    input [1:0] Control,
    output reg [31:0] Output);
    
    always @(*) begin
        case (Control)
            2'b00: Output = Input_0;
            2'b01: Output = Input_1;
            2'b10: Output = Input_2;
        endcase
    end 
endmodule
    
module Alu (
    input [31:0] ALU_data1,
    input [31:0] ALU_data2,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult
    //output reg Zero
    );
    
    initial begin
        ALUResult = 32'b0;
        //Zero = 0;
    end
    
    always @ (*) begin
        case (ALUControl) 
            4'b0000: ALUResult = ALU_data1 & ALU_data2;
            4'b0001: ALUResult = ALU_data1 | ALU_data2;
            4'b0010: ALUResult = ALU_data1 + ALU_data2;
            4'b0110: ALUResult = ALU_data1 - ALU_data2;
            4'b0111: ALUResult = (ALU_data1 < ALU_data2);
        endcase
        
//        if (ALUResult == 31'b0 && ALUControl == 4'b0110)
//            Zero = 1'b1;
//        else Zero = 1'b0;
    end
endmodule

module AluControl (//FuncCode, ALUOp, ALUControl);
    input [5:0] FuncCode,
    input [1:0] ALUOp,
    output reg [3:0] ALUControl);
    
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
    //input Zero_in,
    input [4:0] WriteReg_in,
    input [31:0] Write_data_in,
    //input [31:0] EX_MEM_NEXT_PC_in,
    input MemWrite_in,
    input MemRead_in,
    //input Branch_in,
    input MemToReg_in,
    input RegWrite_in,
    output reg [31:0] ALUResult_out,
    //output reg Zero_out,
    output reg [4:0] WriteReg_out,
    output reg [31:0] Write_data_out,
    //output reg [31:0] EX_MEM_NEXT_PC_out,
    output reg MemWrite_out,
    output reg MemRead_out,
    //output reg Branch_out,
    output reg MemToReg_out,
    output reg RegWrite_out);
    
    initial begin
        ALUResult_out = 32'b0;
        //Zero_out = 0;
        WriteReg_out = 5'b0;
        Write_data_out = 32'b0;
        //EX_MEM_NEXT_PC_out = 32'b0;
        MemWrite_out = 0;
        MemRead_out = 0;
        //Branch_out = 0;
        MemToReg_out = 0;
        RegWrite_out = 0;
    end
    
    always @(posedge clock) begin
        ALUResult_out = ALUResult_in;
        //Zero_out = Zero_in;
        WriteReg_out = WriteReg_in;
        Write_data_out = Write_data_in;
        //EX_MEM_NEXT_PC_out = EX_MEM_NEXT_PC_in;
        MemWrite_out = MemWrite_in;
        MemRead_out = MemRead_in;
        //Branch_out = Branch_in;
        MemToReg_out = MemToReg_in;
        RegWrite_out = RegWrite_in;        
    end
endmodule
