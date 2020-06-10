`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/18 23:02:36
// Design Name: 
// Module Name: sim_9_ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim_9_ALU;
    reg [31:0] Read_data1;
    reg [31:0] Read_data2;
    reg [31:0] Immediate;
    reg ALUSrc;
    reg [1:0] ALUOp;
    wire [3:0] ALUControl;
    wire Zero;
    wire [31:0] ALUResult;
    reg clock;
    
    AluControl AC(
            .FuncCode(Immediate[5:0]), .ALUOp(ALUOp), .ALUControl(ALUControl));
    Alu ALU(
            .Read_data1(Read_data1), .Read_data2(Read_data2), .Immediate(Immediate), 
            .ALUSrc(ALUSrc), .ALUOp(ALUOp), .ALUResult(ALUResult), .Zero(Zero));
    
    integer filePointer;
    initial begin
        #0 begin
            clock = 0;
            filePointer = $fopen("ALU.txt");
            $fwrite(filePointer, "==========================================================\n");
        end
        
        #10 begin
            Read_data1 = 32'h0011;
            Read_data2 = 32'h0022;
            Immediate = 32'h0020;
            ALUSrc = 0;
            ALUOp = 2'b10;
            $fwrite(filePointer, "Add:   %d",ALUResult);
        end    
        
        #10 begin
            Read_data1 = 32'h0011;
            Read_data2 = 32'h0022;
            Immediate = 32'h0020;
            ALUSrc = 0;
            ALUOp = 2'b10;
            $fwrite(filePointer, "Minus: %d",ALUResult);
        end    
        
        #10 begin
            Read_data1 = 32'h0011;
            Read_data2 = 32'h0022;
            Immediate = 32'h0022;
            ALUSrc = 0;
            ALUOp = 2'b10;
            $fwrite(filePointer, "AND:   %d",ALUResult);
        end    
        
        #10 begin
            Read_data1 = 32'h0011;
            Read_data2 = 32'h0022;
            Immediate = 32'h0024;
            ALUSrc = 0;
            ALUOp = 2'b10;
            $fwrite(filePointer, "OR:    %d",ALUResult);
        end  
        
        #10 begin
            Read_data1 = 32'h0011;
            Read_data2 = 32'h0022;
            Immediate = 32'h0025;
            ALUSrc = 0;
            ALUOp = 2'b10;
            $fwrite(filePointer, "slt:   %d",ALUResult);
        end  
        
        #10 begin
            Read_data1 = 32'h0011;
            Read_data2 = 32'h0022;
            Immediate = 32'h002a;
            ALUSrc = 0;
            ALUOp = 2'b10;
            $fwrite(filePointer, "%d",ALUResult);
        end  
        
        #10 begin
            Read_data1 = 32'h0011;
            Read_data2 = 32'h0022;
            Immediate = 32'h0000;
            ALUSrc = 0;
            ALUOp = 2'b00;
            $fwrite(filePointer, "%d",ALUResult);
        end  
        
        #10 begin
            Read_data1 = 32'h0011;
            Read_data2 = 32'h0022;
            Immediate = 32'h0000;
            ALUSrc = 0;
            ALUOp = 2'b01;
            $fwrite(filePointer, "%d",ALUResult);
        end  
    end
    
    always #5 begin
        clock = ~clock;
    end
    
    initial #100 begin
        $fclose(filePointer);
        $stop;
    end
endmodule
