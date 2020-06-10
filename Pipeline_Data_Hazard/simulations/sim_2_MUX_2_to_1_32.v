// define time scale
    `timescale 1ns / 1ps

module sim_2_MUX_2_to_1_32;

    reg[31:0] Q_in_0, Q_in_1;
    reg PCSrc;
    wire[31:0] Q_out;

    MUX_2_to_1_32_Jin Test1 (Q_in_0, Q_in_1, PCSrc, Q_out);

    initial begin
        #0 begin 
            Q_in_0 = 32'd1; Q_in_1 = 32'hffff; PCSrc = 1'b0; 
        end
        #100 begin
            PCSrc = 1'b1; 
        end
        #100 begin                                                  
            Q_in_0 = 32'h2222; Q_in_1 = 32'h3333; PCSrc = 1'b0;
        end
        #100 begin
            PCSrc = 1'b1; 
        end
    end


    initial #500 $stop;
endmodule
