`timescale 1ns / 1ps

module sim_6_Judge_Branch;

    reg Branch, Is_Zero;
    wire PCSrc;

    initial begin
        #0 begin    Branch = 1'b0; Is_Zero = 1'b0;  end
        #20 begin    Branch = 1'b1; Is_Zero = 1'b0;  end
        #20 begin    Branch = 1'b0; Is_Zero = 1'b1;  end
        #20 begin    Branch = 1'b1; Is_Zero = 1'b1;  end
    end

    Judge_Branch_Jin Test1 (
        .Branch(Branch),    .Is_Zero(Is_Zero),  .PCSrc(PCSrc)
    );

    initial #80 $stop;
endmodule
