`timescale 1ns / 1ps


module sim_8_ID;
    reg clock, RegWrite_in;
    reg [4:0] WriteRegister;
    reg [31:0] PC_plus_four_in, instruction, WriteData;
    wire ALUSrc, RegDst,MemWrite,MemRead,Branch,MemToReg,RegWrite_out;
    wire [1:0] ALUOp;
    wire [4:0] RegisterRt, RegisterRd;
    wire [31:0] PC_plus_four_out,ReadData_1, ReadData_2,Immediate;
    
    initial begin
        #0 begin
            clock = 1'b0; RegWrite_in = 1'b1; WriteRegister = 5'd8; 
            PC_plus_four_in = 32'hffff; instruction = 32'b00000001000010011000100000100000;
            WriteData = 32'hccccc;
        end
        #50 begin
            RegWrite_in = 1'b1; WriteRegister = 5'd9; WriteData = 32'hddddd;
        end
        #50 begin
            RegWrite_in = 1'b0;
        end
    end

    wire [31:0] Wire_1, Wire_10, Wire_11, Wire_12;
    wire [4:0] Wire_13, Wire_14;
    wire [1:0] Wire_4;
    wire Wire_2, Wire_3, Wire_5, Wire_6, Wire_7, Wire_8, Wire_9;
    ID Test1 (
        .PC_plus_four_in(PC_plus_four_in), .PC_plus_four_out(Wire_1),
        .instruction(instruction), .WriteRegister(WriteRegister), .WriteData(WriteData),
        .RegWrite_in(RegWrite_in), .clock(clock), 
        .ALUSrc(Wire_2), .RegDst(Wire_3), .ALUOp(Wire_4), .MemWrite(Wire_5), 
        .MemRead(Wire_6), .Branch(Wire_7), .MemToReg(Wire_8), .RegWrite_out(Wire_9),
        .ReadData_1(Wire_10), .ReadData_2(Wire_11), .Immediate(Wire_12), 
        .RegisterRt(Wire_13), .RegisterRd(Wire_14)
    );

    ID_EX_Register Test2 (
        .PC_plus_four_in(Wire_1), .PC_plus_four_out(PC_plus_four_out), 
        .clock(clock), 
        .ALUSrc_in(Wire_2), .RegDst_in(Wire_3), .ALUOp_in(Wire_4), .MemWrite_in(Wire_5), 
        .MemRead_in(Wire_6), .Branch_in(Wire_7), .MemToReg_in(Wire_8), .RegWrite_in(Wire_9),
        .ALUSrc_out(ALUSrc), .RegDst_out(RegDst), .ALUOp_out(ALUOp), .MemWrite_out(MemWrite),
        .MemRead_out(MemRead), .Branch_out(Branch), .MemToReg_out(MemToReg),
        .RegWrite_out(RegWrite_out),
        .ReadData_1_in(Wire_10), .ReadData_2_in(Wire_11), .Immediate_in(Wire_12),
        .RegisterRt_in(Wire_13), .RegisterRd_in(Wire_14),
        .ReadData_1_out(ReadData_1), .ReadData_2_out(ReadData_2),
        .Immediate_out(Immediate), .RegisterRt_out(RegisterRt), .RegisterRd_out(RegisterRd)
    );


    integer filePointer;
    initial     begin
        #0 begin    
            filePointer = $fopen("Register_Memory.txt");
            $fwrite(filePointer, "==========================================================\n");
        end
    end
    
    integer i;
    integer clkCount = 0;
    always @ (negedge clock)    begin
        $fwrite(filePointer, "CLK = %d\n", clkCount);
        for (i = 0; i < Test1.Test2.size; i = i + 1)    
            $fwrite(filePointer, "[%d]: 0x%H\n", i, Test1.Test2.Data_register[i]);
        $fwrite(filePointer, "----------------------------------------------------------\n");
    end

    always #5 begin
        clock = ~clock; clkCount = clkCount + 1;
    end

    initial #200 begin
        $fclose(filePointer);
        $stop;
    end
endmodule
