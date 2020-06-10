`timescale 1ns / 1ps

module sim_6_Output_DataMemory;


    reg MemToReg_in, RegWrite_in, MemWrite, MemRead, Branch, Is_Zero, clock;
    reg [4:0] RegisterRd_in;
    reg [31:0] PC_Branch_in, ALU_Result_in, WriteData;
    wire MemToReg_out, RegWrite_out, PCSrc;
    wire [31:0] ReadData, ALU_Result_out, PC_Branch_out;
    wire [4:0] RegisterRd_out;

    initial begin
        #0 begin
            MemToReg_in = 1'b0; RegWrite_in = 1'b0; PC_Branch_in = 32'hffff; RegisterRd_in = 5'b11111;
            MemWrite = 1'b0; MemRead = 1'b0; ALU_Result_in = 32'd0; WriteData = 32'd0;
            Branch = 1'b0; Is_Zero = 1'b0; clock = 1'b0;
        end
        #10 begin
            MemWrite = 1'b1; MemRead = 1'b0; ALU_Result_in = 32'd0; WriteData = 32'hffff;
            Branch = 1'b1; Is_Zero = 1'b0;
        end
        #10 begin
            MemWrite = 1'b1; MemRead = 1'b0; ALU_Result_in = 32'd4; WriteData = 32'heeee;
            Branch = 1'b0; Is_Zero = 1'b1;
        end
        #10 begin
            MemWrite = 1'b1; MemRead = 1'b0; ALU_Result_in = 32'd8; WriteData = 32'hdddd;
            Branch = 1'b1; Is_Zero = 1'b1;
        end
        #10 begin
            MemWrite = 1'b0; MemRead = 1'b1; ALU_Result_in = 32'd0; WriteData = 32'h1111;
        end
        #10 begin
            MemWrite = 1'b0; MemRead = 1'b1; ALU_Result_in = 32'd4; WriteData = 32'h2222;
        end
        #10 begin
            MemWrite = 1'b0; MemRead = 1'b1; ALU_Result_in = 32'd8; WriteData = 32'h3333;
        end
    end

    wire Wire_1, Wire_2;
    wire [31:0] Wire_5,  Wire_3;
    wire [4:0] Wire_4;
    MEM_Jin Test1 (
        .MemToReg_in(MemToReg_in),  .MemToReg_out(Wire_1),
        .RegWrite_in(RegWrite_in),  .RegWrite_out(Wire_2),
        .ALU_Result_in(ALU_Result_in),  .ALU_Result_out(Wire_3),
        .RegisterRd_in(RegisterRd_in),  .RegisterRd_out(Wire_4),
        .Branch(Branch),    .Is_Zero(Is_Zero),  .PCSrc(PCSrc),
        .MemWrite(MemWrite),    .MemRead(MemRead),  .WriteData(ALU_Result_in),
        .ReadData(Wire_5),  .PC_Branch_in(PC_Branch_in),    
        .PC_Branch_out(PC_Branch_out)
    );

    MEM_WB_Register_Jin Test2 (
        .MemToReg_in(Wire_1),   .MemToReg_out(MemToReg_out),
        .RegWrite_in(Wire_2),   .RegWrite_out(RegWrite_out),
        .ReadData_in(Wire_5),   .ReadData_out(ReadData),
        .ALU_Result_in(Wire_3), .ALU_Result_out(ALU_Result_out),
        .RegisterRd_in(Wire_4), .RegisterRd_out(RegisterRd_out),
        .clock(clock)
    );

    
    integer filePointer;
    initial     begin
        #0 begin    
            filePointer = $fopen("Output_Data_Memory.txt");
            $fwrite(filePointer, "==========================================================\n");
        end
    end
    integer i;
    always @ (negedge clock)    begin
        $fwrite(filePointer, "CLK = %d\n", clkCount);
        for (i = 0; i <  Test1.Test2.size; i = i + 1)    
            $fwrite(filePointer, "Index: 0d%d, Data: 0x%H\n", i, Test1.Test2.memory[i]);
        $fwrite(filePointer, "----------------------------------------------------------\n");
    end

    integer clkCount = 0;
    always #7 begin
        clock = ~clock; clkCount = clkCount + 1;
    end

    initial #80 begin  
        $fclose(filePointer); $stop; 
    end

endmodule
