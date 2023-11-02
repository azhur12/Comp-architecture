module alu(a, b, ALUControl, res, zero);
    input [31:0] a, b;
    input [2:0] ALUControl;
    output reg [31:0] res;
    output reg zero;
    always @(*) begin
        #1;
        if (ALUControl == 3'b000) begin
            res = a & b;
        end

        if (ALUControl == 3'b001) begin
            res = a | b;
        end

        if (ALUControl == 3'b010) begin
            res = a + b;
        end

        if (ALUControl == 3'b110) begin
            res = a - b;
        end

        if (ALUControl == 3'b111) begin
            if (a < b) begin
                res = 1;
            end
            else begin
                res = 0;
            end
        end

        if (a - b == 0) begin
            zero = 1;
        end
        else begin
            zero = 0;
        end
    end
endmodule