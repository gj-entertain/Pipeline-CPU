`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 01:39:52
// Design Name: 
// Module Name: TEST
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


module TEST;
    reg clk,reset,print_clk;
    wire [31:0] out;
    single_cycle mmp(clk,reset,out);
    initial begin
        clk=0;
    end
    
    
    integer filePointer;
        initial     begin
        print_clk=0;
            #0 begin    
                filePointer = $fopen("All_Memory.txt");
                $fwrite(filePointer, "==========================================================\n");
            end
        end
        
        integer i;
        integer clkCount = 0;
        always @ (negedge print_clk)    begin
            $fwrite(filePointer, "CLOCK = %d, ClkCount = %d, PC = 0x%H\n", clk, clkCount >> 1, out);
            // IF Memory
            // $fwrite(filePointer, "Instruction Memory: \n");
            // for (i = 0; i < if_.Test4.size; i = i + 1)    
            //     $fwrite(filePointer, "[%d]: 0x%H\n", i, if_.Test4.memory[i]);
            // $fwrite(filePointer, "----------------------------------------------------------\n");
            // Register Memory
            $fwrite(filePointer, "Register Memory: \n");
                $fwrite(filePointer, "[t0]: 0x%H    ", mmp.pro3.Data_register[8]);
                $fwrite(filePointer, "[t1]: 0x%H    ", mmp.pro3.Data_register[9]);
                $fwrite(filePointer, "[t2]: 0x%H  \n", mmp.pro3.Data_register[10]);
                
                $fwrite(filePointer, "[t3]: 0x%H    ", mmp.pro3.Data_register[11]);
                $fwrite(filePointer, "[t4]: 0x%H    ", mmp.pro3.Data_register[12]);
                $fwrite(filePointer, "[t5]: 0x%H  \n", mmp.pro3.Data_register[13]);
                
                $fwrite(filePointer, "[t6]: 0x%H    ", mmp.pro3.Data_register[14]);
                $fwrite(filePointer, "[t7]: 0x%H    ", mmp.pro3.Data_register[15]);
                $fwrite(filePointer, "[t8]: 0x%H  \n", mmp.pro3.Data_register[24]);
                
                $fwrite(filePointer, "[t9]: 0x%H    ", mmp.pro3.Data_register[25]);
                $fwrite(filePointer, "[s0]: 0x%H    ", mmp.pro3.Data_register[16]);
                $fwrite(filePointer, "[s1]: 0x%H  \n", mmp.pro3.Data_register[17]);
                
                $fwrite(filePointer, "[s2]: 0x%H    ", mmp.pro3.Data_register[18]);
                $fwrite(filePointer, "[s3]: 0x%H    ", mmp.pro3.Data_register[19]);
                $fwrite(filePointer, "[s4]: 0x%H  \n", mmp.pro3.Data_register[20]);
                
                $fwrite(filePointer, "[s5]: 0x%H    ", mmp.pro3.Data_register[21]);
                $fwrite(filePointer, "[s6]: 0x%H    ", mmp.pro3.Data_register[22]);
                $fwrite(filePointer, "[s7]: 0x%H  \n", mmp.pro3.Data_register[23]);
            $fwrite(filePointer, "----------------------------------------------------------\n");
            // Data Memory
            $fwrite(filePointer, "Data Memory: \n");
            for (i = 0; i < mmp.pro5.size; i = i + 1)    
                $fwrite(filePointer, "[%d]: 0x%H\n", i, mmp.pro5.memory[i]);
            $fwrite(filePointer, "==========================================================\n");
        end
    
    always #9 begin
        clk=~clk; clkCount = clkCount + 1;
        #1 print_clk=~print_clk;
    end
    
     initial #2000 $stop;
endmodule
