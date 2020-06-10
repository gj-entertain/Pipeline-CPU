`timescale 1ns / 1ps

module sim_1_Output_IF;

    reg PCSrc, clock;
    reg[31:0] PC_branch;
    wire [31:0] PC_plus_four, instruction;


    wire[31:0] Wire_1, Wire_2;
    IF_Jin Test1 (
        .PCSrc(PCSrc), .PC_branch(PC_branch), .clock(clock),
        .PC_plus_four(Wire_1), .instruction(Wire_2)
    );
    IF_ID_Register_Jin Test2 (
        .PC_plus_four_in(Wire_1), .instruction_in(Wire_2), .clock(clock),
        .PC_plus_four_out(PC_plus_four), .instruction_out(instruction)
    );


    integer filePointer;
    initial     begin
        #0 begin    
            PCSrc = 1'b0; PC_branch = 32'd0; clock = 1'b0; clkCount = 0;
            filePointer = $fopen("Output_Instruction_Memory.txt");
            $fwrite(filePointer, "==========================================================\n");
        end
    end
    integer i;
    always @ (negedge clock)    begin
        $fwrite(filePointer, "CLK = %d\n", clkCount);
        for (i = 0; i < Test1.Test4.size; i = i + 1)    
            $fwrite(filePointer, "Index: 0d%d, PC: 0x%H, Instruction: 0x%H\n", i, (i >> 2), Test1.Test4.memory[i]);
        $fwrite(filePointer, "----------------------------------------------------------\n");
    end

    integer clkCount;
    always #23 PCSrc = ~PCSrc;
    always #10 begin
        clock = ~clock; clkCount = clkCount + 1;
    end

    initial #500 $stop;
endmodule
