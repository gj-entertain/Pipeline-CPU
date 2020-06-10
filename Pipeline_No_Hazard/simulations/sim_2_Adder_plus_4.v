// define time scale
    `timescale 1ns / 1ps

// Simulation for IF
module simulation;

    reg[31:0] PC_1;
    reg[31:0] PC_2;

    wire[31:0] PC_plus_four_1;
    wire[31:0] PC_plus_four_2;

    Adder_plus_four_Jin Test1 (PC_1, PC_plus_four_1);
    Adder_plus_four_Jin Test2 (PC_2, PC_plus_four_2);

    initial begin
        #0 begin 
            PC_1 = 32'd0; PC_2 = 32'd15;  
        end
        #500 begin
            PC_1 = 32'd15; PC_2 = 32'd0;
        end
    end
    
    initial #1000 $stop;
endmodule // simulation