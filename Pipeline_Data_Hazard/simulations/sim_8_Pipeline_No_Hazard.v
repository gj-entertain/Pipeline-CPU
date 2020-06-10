`timescale 1ns / 1ps

module sim_8_Pipeline_No_Hazard;

    reg clock, Print_clock; 

    initial begin
        clock = 1'b0;
        Print_clock = 1'b0;
    end
    
    // IF stage    
    //wire            PCSrc_IF;
    wire    [31:0]  PC_Next_IF;

    // ID stage
    wire            RegWrite_ID,
                    Flush;
    wire    [1:0]   Forward_ID1,
                    Forward_ID2;
    wire    [4:0]   WriteRegister_ID;
    wire    [31:0]  PC_plus_four_ID,
                    instruction_ID,
                    WriteData_ID;

    // EX stage
    wire            ALUSrc_EX,
                    RegDst_EX,
                    MemWrite_EX,
                    MemRead_EX,
                    //Branch_EX,
                    MemToReg_EX,
                    RegWrite_EX;
    wire    [1:0]   ALUOp_EX;
    wire    [4:0]   RegisterRs_EX,
                    RegisterRt_EX,
                    RegisterRd_EX;
    wire    [31:0]  //PC_plus_four_EX,
                    ReadData_1_EX,
                    ReadData_2_EX,
                    Immediate_EX;
    
    // MEM stage 
    wire            MemToReg_MEM,
                    RegWrite_MEM,
                    //Branch_MEM,
                    //Is_Zero_MEM,
                    MemWrite_MEM,
                    MemRead_MEM;
    wire    [4:0]   RegisterRd_MEM;
    wire    [31:0]  ALU_Result_MEM,
                    WriteData_MEM;
                    //PC_Branch_MEM;

    // WB stage
    wire            MemToReg_WB,
                    RegWrite_WB;
    wire    [4:0]   RegisterRd_WB;
    wire    [31:0]  ALU_Result_WB,
                    ReadData_WB;
                    
    // Hard Detection
    wire           PC_Write_IF,
                    IF_ID_Write,
                    Control_0;
    // Forwarding Unit
    wire    [1:0]   Forward_ALU1,
                    Forward_ALU2;
    // Flush Detection
    // wire            Flush;
    //wire            Stall;
    // assign  Stall   =   HD.stall;
    // wire MayBranch_ID, Zero_ID;
    // assign MayBranch_ID = id.MayBranch;
    // assign Zero_ID = id.Zero;
    
    wire    MayBranch_ID, BranchEq_ID, BranchNeq_ID, Jump_ID, Zero_ID;
    // assign Jump = id.Jump;
    // assign Branch = ((id.BranchEq & id.Zero) | (id.BranchNeq & ~id.Zero));
    
    //wire [31:0] BranchData_1, BranchData_2;
    // assign BranchData_1 = id.BranchData_1;
    // assign BranchData_2 = id.BranchData_2;

    
                    
    // IF stage
        wire [31:0] Wire_20, Wire_21;
        IF_Jin if_ (
            .PCSrc(Flush),           .PC_Write(PC_Write_IF),
            .PC_Next(PC_Next_IF),       .clock(clock), 
            .PC_plus_four(Wire_20),     .instruction(Wire_21)
        );

    // IF/ID
        IF_ID_Register_Jin ifid (
            .PC_plus_four_in(Wire_20),      .instruction_in(Wire_21),
            .IF_ID_Write(IF_ID_Write),      .clock(clock), 
            .Flush(Flush),
            .PC_plus_four_out(PC_plus_four_ID), 
            .instruction_out(instruction_ID)
        );

    // ID stage
        wire [31:0] /*Wire_1,*/ Wire_10, Wire_11, Wire_12;
        wire [4:0] Wire_13p, Wire_13, Wire_14;
        wire [1:0] Wire_4;
        wire Wire_2, Wire_3, Wire_5, Wire_6, /*Wire_7,*/ Wire_8, Wire_9;
        ID id (
            .PC_plus_four_in(PC_plus_four_ID),  //.PC_plus_four_out(Wire_1),
            .instruction(instruction_ID),      
            .WriteRegister(WriteRegister_ID),   .WriteData(WriteData_ID),
            .RegWrite_in(RegWrite_ID), 
            .clock(clock),                      .Control_0(Control_0),
            .ALUSrc(Wire_2),            .RegDst(Wire_3),        .ALUOp(Wire_4), 
            .MemWrite(Wire_5),          .MemRead(Wire_6),       //.Branch(Wire_7), 
            .MEM_data(ALU_Result_MEM),  .WB_data(WriteData_ID),
            .Forward_ID1(Forward_ID1),  .Forward_ID2(Forward_ID2),
            .MemToReg(Wire_8),          .RegWrite_out(Wire_9),
            .ReadData_1(Wire_10),       .ReadData_2(Wire_11), 
            .Immediate(Wire_12),        .PC_Next(PC_Next_IF),
            .RegisterRs(Wire_13p),      //.Flush(Flush),
            .RegisterRt(Wire_13),       .RegisterRd(Wire_14),
            .MayBranch(MayBranch_ID),      .BranchEq(BranchEq_ID),
            .BranchNeq(BranchNeq_ID),      .Jump(Jump_ID),
            .Zero(Zero_ID)
        );

    // ID/EX
        ID_EX_Register idex (
            //.PC_plus_four_in(Wire_1), .PC_plus_four_out(PC_plus_four_EX), 
            .clock(clock), 
            .ALUSrc_in(Wire_2),         .ALUSrc_out(ALUSrc_EX), 
            .RegDst_in(Wire_3),         .RegDst_out(RegDst_EX), 
            .ALUOp_in(Wire_4),          .ALUOp_out(ALUOp_EX), 
            .MemWrite_in(Wire_5),       .MemWrite_out(MemWrite_EX), 
            .MemRead_in(Wire_6),        .MemRead_out(MemRead_EX), 
            //.Branch_in(Wire_7),         .Branch_out(Branch_EX), 
            .MemToReg_in(Wire_8),       .MemToReg_out(MemToReg_EX), 
            .RegWrite_in(Wire_9),       .RegWrite_out(RegWrite_EX), 
            .ReadData_1_in(Wire_10),    .ReadData_1_out(ReadData_1_EX), 
            .ReadData_2_in(Wire_11),    .ReadData_2_out(ReadData_2_EX),
            .Immediate_in(Wire_12),     .Immediate_out(Immediate_EX), 
            .RegisterRs_in(Wire_13p),   .RegisterRs_out(RegisterRs_EX), 
            .RegisterRt_in(Wire_13),    .RegisterRt_out(RegisterRt_EX), 
            .RegisterRd_in(Wire_14),    .RegisterRd_out(RegisterRd_EX) 
        );

    // EX stage
        wire [31:0] wire_20, wire_23; //wire_24;
        wire [4:0] wire_22;
        wire /*wire_21,*/ wire_25, wire_26, /*wire_27,*/ wire_28, wire_29;
        Execute Ex(
            .Read_data1(ReadData_1_EX),   .Read_data2(ReadData_2_EX),
            .Immediate(Immediate_EX),     .ALUSrc(ALUSrc_EX),
            .RegDst(RegDst_EX),           .ALUOp(ALUOp_EX), 
            .MemWrite_in(MemWrite_EX),    .MemWrite_out(wire_25),
            .MemRead_in(MemRead_EX),      .MemRead_out(wire_26),
            //.Branch_in(Branch_EX),        .Branch_out(wire_27),
            .MemToReg_in(MemToReg_EX),    .MemToReg_out(wire_28),
            .RegWrite_in(RegWrite_EX),    .RegWrite_out(wire_29),
            .rt(RegisterRt_EX),           .rd(RegisterRd_EX), 
            //.ID_EX_Next_PC(PC_plus_four_EX),
            //.EX_MEM_NEXT_PC(wire_24),
            .ALUResult(wire_20),          //.Zero(wire_21), 
            .WriteReg(wire_22),           .Write_data(wire_23),
            
            .MEM_data(ALU_Result_MEM),    .WB_data(WriteData_ID),
            .Forward_ALU1(Forward_ALU1),  .Forward_ALU2(Forward_ALU2)
            );
            
    // EX/MEM
        EX_MEM_Register exmem(
            .clock(clock),
            .ALUResult_in(wire_20),         .ALUResult_out(ALU_Result_MEM),
            //.Zero_in(wire_21),              .Zero_out(Is_Zero_MEM),
            .WriteReg_in(wire_22),          .WriteReg_out(RegisterRd_MEM),
            .Write_data_in(wire_23),        .Write_data_out(WriteData_MEM),
            //.EX_MEM_NEXT_PC_in(wire_24),    .EX_MEM_NEXT_PC_out(PC_Branch_MEM),
            .MemWrite_in(wire_25),          .MemWrite_out(MemWrite_MEM),
            .MemRead_in(wire_26),           .MemRead_out(MemRead_MEM),
            //.Branch_in(wire_27),            .Branch_out(Branch_MEM),
            .MemToReg_in(wire_28),          .MemToReg_out(MemToReg_MEM),
            .RegWrite_in(wire_29),          .RegWrite_out(RegWrite_MEM));
        
    // MEM stage 
        wire Wire_15, Wire_16;
        wire [31:0] Wire_19,  Wire_17;
        wire [4:0] Wire_18;
        MEM_Jin mem (
            .MemToReg_in(MemToReg_MEM),     .MemToReg_out(Wire_15),
            .RegWrite_in(RegWrite_MEM),     .RegWrite_out(Wire_16),
            .ALU_Result_in(ALU_Result_MEM), .ALU_Result_out(Wire_17),
            .RegisterRd_in(RegisterRd_MEM), .RegisterRd_out(Wire_18),
            //.Branch(Branch_MEM),            .Is_Zero(Is_Zero_MEM),  
            //.PCSrc(PCSrc_IF),               
            .MemWrite(MemWrite_MEM),        .clock(clock),
            .MemRead(MemRead_MEM),          .WriteData(WriteData_MEM),
            .ReadData(Wire_19)
            //.PC_Branch_in(PC_Branch_MEM), .PC_Branch_out(PC_Branch_IF)
        );
    
    // MEM/WB
        MEM_WB_Register_Jin memwb (
            .MemToReg_in(Wire_15),          .MemToReg_out(MemToReg_WB),
            .RegWrite_in(Wire_16),          .RegWrite_out(RegWrite_WB),
            .ReadData_in(Wire_19),          .ReadData_out(ReadData_WB),
            .ALU_Result_in(Wire_17),        .ALU_Result_out(ALU_Result_WB),
            .RegisterRd_in(Wire_18),        .RegisterRd_out(RegisterRd_WB),
            .clock(clock)
        );
    
    // WB stage
        WB_Jin wb (
            .ALU_Result(ALU_Result_WB),     .ReadData(ReadData_WB),    
            .MemToReg(MemToReg_WB),         .WriteData(WriteData_ID),      
            .RegWrite_in(RegWrite_WB),      .RegWrite_out(RegWrite_ID),
            .RegisterRd_in(RegisterRd_WB),  .RegisterRd_out(WriteRegister_ID)
        );
        
    // Forwarding
        Forwarding FW(
            .RegWrite_MEM(RegWrite_MEM),    .RegWrite_WB(RegWrite_WB),
            .RegisterRs_EX(RegisterRs_EX),  .RegisterRt_EX(RegisterRt_EX),
            .RegisterRd_MEM(RegisterRd_MEM),.RegisterRd_WB(RegisterRd_WB),
            .Forward_ALU1(Forward_ALU1),    .Forward_ALU2(Forward_ALU2)
        );
        
        
        Forwarding_ID fid (
            .RegWrite_MEM(RegWrite_MEM),     .RegWrite_WB(RegWrite_WB),
            .RegisterRs_ID(Wire_13p),        .RegisterRt_ID(Wire_13),
            .RegisterRd_MEM(RegisterRd_MEM), .RegisterRd_WB(RegisterRd_WB),
            .Forward_ID1(Forward_ID1),       .Forward_ID2(Forward_ID2)
        );
        
     // Hazard Detection
         HazardDetect HD (
            .MemRead_EX(MemRead_EX),        .MayBranch_ID(MayBranch_ID),
            .clock(clock),                  .RegWrite_EX(RegWrite_EX),
            .RegWrite_out_EX(wire_22),      .RegisterRd_MEM(RegisterRd_MEM),
            .RegisterRt_EX(RegisterRt_EX),  .MemRead_MEM(MemRead_MEM),
            .RegisterRs_ID(Wire_13p),       .RegisterRt_ID(Wire_13),
            .PC_Write(PC_Write_IF),         .IF_ID_Write(IF_ID_Write),
            .Control_0(Control_0)
         );
         
          FlushDetection fd (
              .BranchEq(BranchEq_ID),         .BranchNeq(BranchNeq_ID),
              .Zero(Zero_ID),                 .Jump(Jump_ID),
              .Flush(Flush)
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
    always @ (Print_clock)    begin
        $fwrite(filePointer, "CLOCK = %d, ClkCount = %d, PC = 0x%H\n", clock, clkCount, if_.Wire_2);
        // IF Memory
        // $fwrite(filePointer, "Instruction Memory: \n");
        // for (i = 0; i < if_.Test4.size; i = i + 1)    
        //     $fwrite(filePointer, "[%d]: 0x%H\n", i, if_.Test4.memory[i]);
        // $fwrite(filePointer, "----------------------------------------------------------\n");
        // Register Memory
        $fwrite(filePointer, "Register Memory: \n");
            $fwrite(filePointer, "[t0]: 0x%H    ", id.Test2.Data_register[8]);
            $fwrite(filePointer, "[t1]: 0x%H    ", id.Test2.Data_register[9]);
            $fwrite(filePointer, "[t2]: 0x%H  \n", id.Test2.Data_register[10]);
            
            $fwrite(filePointer, "[t3]: 0x%H    ", id.Test2.Data_register[11]);
            $fwrite(filePointer, "[t4]: 0x%H    ", id.Test2.Data_register[12]);
            $fwrite(filePointer, "[t5]: 0x%H  \n", id.Test2.Data_register[13]);
            
            $fwrite(filePointer, "[t6]: 0x%H    ", id.Test2.Data_register[14]);
            $fwrite(filePointer, "[t7]: 0x%H    ", id.Test2.Data_register[15]);
            $fwrite(filePointer, "[t8]: 0x%H  \n", id.Test2.Data_register[24]);
            
            $fwrite(filePointer, "[t9]: 0x%H    ", id.Test2.Data_register[25]);
            $fwrite(filePointer, "[s0]: 0x%H    ", id.Test2.Data_register[16]);
            $fwrite(filePointer, "[s1]: 0x%H  \n", id.Test2.Data_register[17]);
            
            $fwrite(filePointer, "[s2]: 0x%H    ", id.Test2.Data_register[18]);
            $fwrite(filePointer, "[s3]: 0x%H    ", id.Test2.Data_register[19]);
            $fwrite(filePointer, "[s4]: 0x%H  \n", id.Test2.Data_register[20]);
            
            $fwrite(filePointer, "[s5]: 0x%H    ", id.Test2.Data_register[21]);
            $fwrite(filePointer, "[s6]: 0x%H    ", id.Test2.Data_register[22]);
            $fwrite(filePointer, "[s7]: 0x%H  \n", id.Test2.Data_register[23]);
        $fwrite(filePointer, "----------------------------------------------------------\n");
        // Data Memory
        $fwrite(filePointer, "Data Memory: \n");
        for (i = 0; i < mem.Test2.size; i = i + 1)    
            $fwrite(filePointer, "[%d]: 0x%H\n", i, mem.Test2.memory[i]);
        $fwrite(filePointer, "==========================================================\n");
    end

    always #4 begin
        clock = ~clock; clkCount = clkCount + 1;
        #1 Print_clock = ~Print_clock;
    end

    initial #500 begin
        $fclose(filePointer);
        $stop;
    end
endmodule
