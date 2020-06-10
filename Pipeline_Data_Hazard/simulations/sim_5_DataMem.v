`timescale 1ns / 1ps

module sim_5_DataMem;
    reg MemWrite, MemRead;
    reg[31:0] Address, WriteData;
    wire[31:0] ReadData;

    initial     begin
        #0 begin                
            MemWrite = 1'b0; MemRead = 1'b0; Address = 32'd0; WriteData = 32'd0;
        end
        #10 begin
            MemWrite = 1'b1; MemRead = 1'b0; Address = 32'd0; WriteData = 32'hffff;
        end
        #10 begin
            MemWrite = 1'b1; MemRead = 1'b0; Address = 32'd4; WriteData = 32'heeee;
        end
        #10 begin
            MemWrite = 1'b1; MemRead = 1'b0; Address = 32'd8; WriteData = 32'hdddd;
        end
        #10 begin
            MemWrite = 1'b0; MemRead = 1'b1; Address = 32'd0; WriteData = 32'h1111;
        end
        #10 begin
            MemWrite = 1'b0; MemRead = 1'b1; Address = 32'd4; WriteData = 32'h2222;
        end
        #10 begin
            MemWrite = 1'b0; MemRead = 1'b1; Address = 32'd8; WriteData = 32'h3333;
        end
    end

    DataMemory_Jin Test1 (
        .MemWrite(MemWrite), .MemRead(MemRead), .Address(Address),
        .WriteData(WriteData), .ReadData(ReadData)
    );

    initial #80 $stop;
endmodule
