`timescale 1ns / 1ps

module sim_7_Register;
    reg clock, RegWrite;
    reg [4:0] WriteRegister,ReadRegister_1,ReadRegister_2;
    reg [31:0] WriteData;
    wire [31:0]  ReadData_1, ReadData_2;

    initial begin
        #0 begin
            clock = 1'b0; RegWrite = 1'b0; WriteRegister = 5'd0; 
            ReadRegister_1 = 5'd1; ReadRegister_2 = 5'd2; WriteData = 32'd0;
        end
        #50 begin
            RegWrite = 1'b1; WriteRegister = 5'd11; WriteData = 32'hffff;
        end
        #50 begin
            RegWrite = 1'b1; WriteRegister = 5'd22; WriteData = 32'heeee;
        end
        #50 begin
            RegWrite = 1'b0; ReadRegister_1 = 5'd11; ReadRegister_2 = 5'd22;
        end
        #50 begin
            RegWrite = 1'b0; ReadRegister_1 = 5'd0; ReadRegister_2 = 5'd31;
        end
    end

    RegFile Test1 (
        .clock(clock),  .RegWrite(RegWrite), .WriteRegister(WriteRegister), 
        .ReadRegister_1(ReadRegister_1), .ReadRegister_2(ReadRegister_2),
        .WriteData(WriteData), .ReadData_1(ReadData_1), .ReadData_2(ReadData_2)
    );
    
    integer filePointer;
    initial     begin
        #0 begin    
            filePointer = $fopen("Register_Memory.txt");
            $fwrite(filePointer, "==========================================================\n");
        end
    end
    
    integer i;
    always @ (negedge clock)    begin
        $fwrite(filePointer, "CLK = %d\n", clkCount);
        for (i = 0; i < Test1.size; i = i + 1)    
            $fwrite(filePointer, "Index: 0d%d, Content: 0x%H\n", i, Test1.Data_register[i]);
        $fwrite(filePointer, "----------------------------------------------------------\n");
    end

    integer clkCount = 0;
    always #20 begin
        clock = ~clock; clkCount = clkCount + 1;
    end

    initial #200 begin
        $fclose(filePointer);
        $stop;
    end

endmodule
