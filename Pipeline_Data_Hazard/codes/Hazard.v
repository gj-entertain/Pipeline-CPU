`timescale 1ns / 1ps

module Forwarding (
    input RegWrite_MEM,
    input RegWrite_WB,
    input [4:0] RegisterRs_EX,
    input [4:0] RegisterRt_EX,
    input [4:0] RegisterRd_MEM,
    input [4:0] RegisterRd_WB,
    output reg [1:0] Forward_ALU1,
    output reg [1:0] Forward_ALU2
);
    initial begin
        Forward_ALU1 = 2'b00;
        Forward_ALU2 = 2'b00;
    end
    
    always @(*) begin
        Forward_ALU1 = 2'b00;
        Forward_ALU2 = 2'b00;
    
        if (RegWrite_MEM && (RegisterRd_MEM != 5'b00000)
            && (RegisterRd_MEM == RegisterRs_EX)
        )
            Forward_ALU1 = 2'b10;
        else if (RegWrite_WB && (RegisterRd_WB != 5'b00000)
            && (RegisterRd_WB == RegisterRs_EX)
        )
            Forward_ALU1 = 2'b01;
        
        if (RegWrite_MEM && (RegisterRd_MEM != 5'b00000)
            && (RegisterRd_MEM == RegisterRt_EX)
        )
            Forward_ALU2 = 2'b10;
        else if (RegWrite_WB && (RegisterRd_WB != 5'b00000)
                && (RegisterRd_WB == RegisterRt_EX)
        )
            Forward_ALU2 = 2'b01;
    end
endmodule

module Forwarding_ID (
    input RegWrite_MEM,
    input RegWrite_WB,
    input [4:0] RegisterRs_ID,
    input [4:0] RegisterRt_ID,
    input [4:0] RegisterRd_MEM,
    input [4:0] RegisterRd_WB,
    output reg [1:0] Forward_ID1,
    output reg [1:0] Forward_ID2
);
    initial begin
    Forward_ID1 = 2'b00;
    Forward_ID2 = 2'b00;
end

    always @(*) begin
        Forward_ID1 = 2'b00;
        Forward_ID2 = 2'b00;
    
        if (RegWrite_MEM && (RegisterRd_MEM != 5'b00000)
            && (RegisterRd_MEM == RegisterRs_ID)
        )
            Forward_ID1 = 2'b10;
        else if (RegWrite_WB && (RegisterRd_WB != 5'b00000)
            && (RegisterRd_WB == RegisterRs_ID)
        )
            Forward_ID1 = 2'b01;
        
        if (RegWrite_MEM && (RegisterRd_MEM != 5'b00000)
            && (RegisterRd_MEM == RegisterRt_ID)
        )
            Forward_ID2 = 2'b10;
        else if (RegWrite_WB && (RegisterRd_WB != 5'b00000)
                && (RegisterRd_WB == RegisterRt_ID)
        )
            Forward_ID2 = 2'b01;
    end
endmodule

module HazardDetect(
    input MemRead_EX,
    input MemRead_MEM,
    input MayBranch_ID,
    input clock,
    input RegWrite_EX,
    input [4:0] RegisterRd_MEM,
    input [4:0] RegWrite_out_EX,
    input [4:0] RegisterRt_EX,
    input [4:0] RegisterRs_ID,
    input [4:0] RegisterRt_ID,
    output reg PC_Write,
    output reg IF_ID_Write,
    output reg Control_0
    );
    reg stall;
    
    initial begin
        stall = 0;
        PC_Write = 1;
        IF_ID_Write = 1;
        Control_0 = 0;
    end
    
    always @(negedge clock) begin
    //always @(*) begin
        stall = (MemRead_EX && ((RegisterRt_EX == RegisterRs_ID) || (RegisterRt_EX == RegisterRt_ID))) ||
            (RegWrite_EX && MayBranch_ID && ((RegWrite_out_EX == RegisterRs_ID) || (RegWrite_out_EX == RegisterRt_ID))) ||
            (MemRead_EX && MayBranch_ID && ((RegisterRt_EX == RegisterRs_ID) || (RegisterRt_EX == RegisterRt_ID))) ||
            (MemRead_MEM && MayBranch_ID && ((RegisterRd_MEM == RegisterRs_ID) || (RegisterRd_MEM == RegisterRt_ID)));
        PC_Write = ~stall;
        IF_ID_Write = ~stall;
        Control_0 = stall;
    end
endmodule

module FlushDetection (
    input BranchEq,
    input BranchNeq,
    input Zero,
    input Jump,
    output wire Flush
);
    assign Flush = (BranchEq & Zero) | (BranchNeq & ~Zero) | Jump;
endmodule