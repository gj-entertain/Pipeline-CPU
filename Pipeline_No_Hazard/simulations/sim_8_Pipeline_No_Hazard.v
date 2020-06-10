`timescale 1ns / 1ps

module sim_8_Pipeline_No_Hazard;

    reg clock; 

    initial begin
        #0 clock = 1'b0;
    end
    
    // IF stage    
    wire            PCSrc_IF,
                    Jump_IF;
    wire    [31:0]  PC_Branch_IF,
                    PC_Jump_IF;

    // ID stage
    wire            RegWrite_ID;
    wire    [4:0]   WriteRegister_ID;
    wire    [31:0]  PC_plus_four_ID,
                    instruction_ID,
                    WriteData_ID;

    // EX stage
    wire            ALUSrc_EX,
                    RegDst_EX,
                    MemWrite_EX,
                    MemRead_EX,
                    BranchEq_EX,
                    BranchNeq_EX,
                    MemToReg_EX,
                    RegWrite_EX,
                    Jump_EX;
    wire    [1:0]   ALUOp_EX;
    wire    [4:0]   RegisterRt_EX,
                    RegisterRd_EX;
    wire    [31:0]  PC_plus_four_EX,
                    ReadData_1_EX,
                    ReadData_2_EX,
                    Immediate_EX,
                    PC_Jump_EX;
    
    // MEM stage 
    wire            MemToReg_MEM,
                    RegWrite_MEM,
                    BranchEq_MEM,
                    BranchNeq_MEM,
                    Is_Zero_MEM,
                    MemWrite_MEM,
                    MemRead_MEM,
                    Jump_MEM;
    wire    [4:0]   RegisterRd_MEM;
    wire    [31:0]  ALU_Result_MEM,
                    WriteData_MEM,
                    PC_Branch_MEM,
                    PC_Jump_MEM;

    // WB stage
    wire            MemToReg_WB,
                    RegWrite_WB;
    wire    [4:0]   RegisterRd_WB;
    wire    [31:0]  ALU_Result_WB,
                    ReadData_WB;

    // IF stage
        wire [31:0] Wire_20, Wire_21;
        IF_Jin if_ (
            .PCSrc(PCSrc_IF), .PC_branch(PC_Branch_IF), 
            .clock(clock), 
            .Jump(Jump_IF), .PC_Jump(PC_Jump_IF),
            .PC_plus_four(Wire_20), .instruction(Wire_21)
        );

    // IF/ID
        IF_ID_Register_Jin ifid (
            .PC_plus_four_in(Wire_20), .instruction_in(Wire_21),
            .clock(clock), 
            .PC_plus_four_out(PC_plus_four_ID), .instruction_out(instruction_ID)
        );

    // ID stage
        wire [31:0] Wire_1, Wire_10, Wire_11, Wire_12, Wire_31;
        wire [4:0] Wire_13, Wire_14;
        wire [1:0] Wire_4;
        wire Wire_2, Wire_3, Wire_5, Wire_6, Wire_7, Wire_8, Wire_9, Wire_30, Wire_32;
        ID id (
            .PC_plus_four_in(PC_plus_four_ID), .PC_plus_four_out(Wire_1),
            .instruction(instruction_ID), 
            .WriteRegister(WriteRegister_ID), .WriteData(WriteData_ID),
            .RegWrite_in(RegWrite_ID), 
            .clock(clock), 
            .ALUSrc(Wire_2), .RegDst(Wire_3), .ALUOp(Wire_4), 
            .MemWrite(Wire_5), .MemRead(Wire_6), 
            .BranchEq(Wire_7), .BranchNeq(Wire_30),
            .MemToReg(Wire_8), .RegWrite_out(Wire_9),
            .Jump(Wire_32), .PC_Jump(Wire_31),
            .ReadData_1(Wire_10), .ReadData_2(Wire_11), 
            .Immediate(Wire_12), 
            .RegisterRt(Wire_13), .RegisterRd(Wire_14)
        );

    // ID/EX
        ID_EX_Register idex (
            .PC_plus_four_in(Wire_1), .PC_plus_four_out(PC_plus_four_EX),
            .PC_Jump_in(Wire_31), .PC_Jump_out(PC_Jump_EX), 
            .clock(clock), 
            .ALUSrc_in(Wire_2), .RegDst_in(Wire_3), .ALUOp_in(Wire_4), 
            .MemWrite_in(Wire_5), .MemRead_in(Wire_6), 
            .BranchEq_in(Wire_7), .BranchNeq_in(Wire_30),
            .MemToReg_in(Wire_8), .RegWrite_in(Wire_9),
            .Jump_in(Wire_32),
            .ALUSrc_out(ALUSrc_EX), .RegDst_out(RegDst_EX), .ALUOp_out(ALUOp_EX), 
            .MemWrite_out(MemWrite_EX), .MemRead_out(MemRead_EX), 
            .BranchEq_out(BranchEq_EX), .BranchNeq_out(BranchNeq_EX),
            .MemToReg_out(MemToReg_EX), .RegWrite_out(RegWrite_EX),
            .Jump_out(Jump_EX),
            .ReadData_1_in(Wire_10), .ReadData_2_in(Wire_11), 
            .Immediate_in(Wire_12),
            .RegisterRt_in(Wire_13), .RegisterRd_in(Wire_14),
            .ReadData_1_out(ReadData_1_EX), .ReadData_2_out(ReadData_2_EX),
            .Immediate_out(Immediate_EX), 
            .RegisterRt_out(RegisterRt_EX), .RegisterRd_out(RegisterRd_EX)
        );

    // EX stage
        wire [31:0] wire_20, wire_23, wire_24, wire_32;
        wire [4:0] wire_22;
        wire wire_21, wire_25, wire_26, wire_27, wire_28, wire_29, wire_30, wire_31;
		Execute Ex(
		    .Read_data1(ReadData_1_EX),   .Read_data2(ReadData_2_EX),
		    .Immediate(Immediate_EX),     .ALUSrc(ALUSrc_EX),
		    .RegDst(RegDst_EX),           .ALUOp(ALUOp_EX), 
		    .MemWrite_in(MemWrite_EX),    .MemWrite_out(wire_25),
		    .MemRead_in(MemRead_EX),      .MemRead_out(wire_26),
		    .BranchEq_in(BranchEq_EX),    .BranchEq_out(wire_27),
            .BranchNeq_in(BranchNeq_EX),  .BranchNeq_out(wire_30),
		    .MemToReg_in(MemToReg_EX),    .MemToReg_out(wire_28),
		    .RegWrite_in(RegWrite_EX),    .RegWrite_out(wire_29),
		    .rt(RegisterRt_EX),           .rd(RegisterRd_EX), 
		    .ID_EX_Next_PC(PC_plus_four_EX),
		    .EX_MEM_NEXT_PC(wire_24),
            .PC_Jump_in(PC_Jump_EX),      .PC_Jump_out(wire_32),
            .Jump_in(Jump_EX),            .Jump_out(wire_31),
		    .ALUResult(wire_20),          .Zero(wire_21), 
		    .WriteReg(wire_22),           .Write_data(wire_23));
		    
    // EX/MEM
        EX_MEM_Register exmem(
            .clock(clock),
            .ALUResult_in(wire_20),     .ALUResult_out(ALU_Result_MEM),
            .Zero_in(wire_21),          .Zero_out(Is_Zero_MEM),
            .WriteReg_in(wire_22),      .WriteReg_out(RegisterRd_MEM),
            .Write_data_in(wire_23),    .Write_data_out(WriteData_MEM),
            .EX_MEM_NEXT_PC_in(wire_24),.EX_MEM_NEXT_PC_out(PC_Branch_MEM),
            .MemWrite_in(wire_25),      .MemWrite_out(MemWrite_MEM),
            .MemRead_in(wire_26),       .MemRead_out(MemRead_MEM),
            .BranchEq_in(wire_27),      .BranchEq_out(BranchEq_MEM),
            .BranchNeq_in(wire_30),     .BranchNeq_out(BranchNeq_MEM),
            .MemToReg_in(wire_28),      .MemToReg_out(MemToReg_MEM),
            .RegWrite_in(wire_29),      .RegWrite_out(RegWrite_MEM),
            .PC_Jump_in(wire_32),              .PC_Jump_out(PC_Jump_MEM),
            .Jump_in(wire_31),                 .Jump_out(Jump_MEM)
        );
        
    // MEM stage 
        wire Wire_15, Wire_16;
        wire [31:0] Wire_19,  Wire_17;
        wire [4:0] Wire_18;
        MEM_Jin mem (
            .MemToReg_in(MemToReg_MEM),  .MemToReg_out(Wire_15),
            .RegWrite_in(RegWrite_MEM),  .RegWrite_out(Wire_16),
            .ALU_Result_in(ALU_Result_MEM),  .ALU_Result_out(Wire_17),
            .RegisterRd_in(RegisterRd_MEM),  .RegisterRd_out(Wire_18),
            .BranchEq(BranchEq_MEM), .BranchNeq(BranchNeq_MEM),
            .Is_Zero(Is_Zero_MEM),  .PCSrc(PCSrc_IF),
            .PC_Jump_in(PC_Jump_MEM), .PC_Jump_out(PC_Jump_IF),
            .Jump_in(Jump_MEM), .Jump_out(Jump_IF),
            .MemWrite(MemWrite_MEM),    .MemRead(MemRead_MEM),  .WriteData(WriteData_MEM),
            .ReadData(Wire_19),  .PC_Branch_in(PC_Branch_MEM),    
            .PC_Branch_out(PC_Branch_IF)
        );
    
    // MEM/WB
        MEM_WB_Register_Jin memwb (
            .MemToReg_in(Wire_15),   .MemToReg_out(MemToReg_WB),
            .RegWrite_in(Wire_16),   .RegWrite_out(RegWrite_WB),
            .ReadData_in(Wire_19),   .ReadData_out(ReadData_WB),
            .ALU_Result_in(Wire_17), .ALU_Result_out(ALU_Result_WB),
            .RegisterRd_in(Wire_18), .RegisterRd_out(RegisterRd_WB),
            .clock(clock)
        );
    
    // WB stage
        WB_Jin wb (
            .ALU_Result(ALU_Result_WB),    .ReadData(ReadData_WB),    
            .MemToReg(MemToReg_WB),
            .WriteData(WriteData_ID),      
            .RegWrite_in(RegWrite_WB),  .RegWrite_out(RegWrite_ID),
            .RegisterRd_in(RegisterRd_WB),  .RegisterRd_out(WriteRegister_ID)
        );

    
    integer filePointer;
    initial     begin
        #0 begin    
            filePointer = $fopen("All_Memory.txt");
            $fwrite(filePointer, "==========================================================\n");
        end
    end
    
    integer i;
    integer clkCount = 0;
    always @ (negedge clock)    begin
        $fwrite(filePointer, "CLOCK = %d, ClkCount = %d, PC = 0x%H\n", clock, clkCount, if_.Wire_2);
        // IF Memory
        // $fwrite(filePointer, "Instruction Memory: \n");
        // for (i = 0; i < if_.Test4.size; i = i + 1)    
        //     $fwrite(filePointer, "[%d]: 0x%H\n", i, if_.Test4.memory[i]);
        // $fwrite(filePointer, "----------------------------------------------------------\n");
        // Register Memory
        $fwrite(filePointer, "Register Memory: \n");
        for (i = 0; i < id.Test2.size; i = i + 1)    
            $fwrite(filePointer, "[%d]: 0x%H\n", i, id.Test2.Data_register[i]);
        $fwrite(filePointer, "----------------------------------------------------------\n");
        // Data Memory
        $fwrite(filePointer, "Data Memory: \n");
        for (i = 0; i < mem.Test2.size; i = i + 1)    
            $fwrite(filePointer, "[%d]: 0x%H\n", i, mem.Test2.memory[i]);
        $fwrite(filePointer, "==========================================================\n");
    end

    always #5 begin
        clock = ~clock; clkCount = clkCount + 1;
    end

    initial #300 begin
        $fclose(filePointer);
        $stop;
    end
endmodule
