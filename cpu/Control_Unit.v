module ctr_unit(opcode, funct, memToReg, memWrite, Branch, ALUControl, ALUSrc, regDST, RegWrite);
    input [5:0] opcode;
    input [5:0] funct;
    output reg memToReg, memWrite, Branch, ALUSrc, regDST, RegWrite;
    output reg [2:0] ALUControl;
    always @(*) begin
        #1;
        if (opcode == 6'b100011) begin //lw
            RegWrite = 1'b1;
            regDST = 1'b0;
            ALUSrc = 1'b1;
            Branch = 1'b0;
            memWrite = 1'b0;
            memToReg = 1'b1;
            ALUControl = 3'b010;
        end

        if (opcode == 6'b101011) begin
            RegWrite = 1'b0;
            ALUSrc = 1'b1;
            Branch = 1'b0;
            memWrite = 1'b1;
            ALUControl = 3'b010;
        end

        if (opcode == 6'b000100) begin
            RegWrite = 1'b0;
            ALUSrc = 1'b0;
            Branch = 1'b1;
            memWrite = 1'b0;
            ALUControl = 3'b110;
        end


        if (opcode == 6'b000000) begin //R-type
            RegWrite <= 1'b1;
            regDST <= 1'b1;
            ALUSrc <= 1'b0;
            Branch <= 1'b0;
            memWrite <= 1'b0;
            memToReg <= 1'b0;

            if (funct == 6'b100000) begin //add
                ALUControl <= 3'b010;
            end
            
            if (funct == 6'b100010) begin
                ALUControl <= 3'b110;
            end

            if (funct == 6'b100100) begin
                ALUControl <= 3'b000;
            end

            if (funct == 6'b100101) begin
                ALUControl <= 3'b001;
            end

            if (funct == 6'b101010) begin
                ALUControl <= 3'b111;
            end
        end

        if (opcode == 6'b001000) begin //addi
            ALUSrc <= 1'b1;
            RegWrite <= 1'b1;
            memToReg <= 1'b0;
            regDST <= 1'b0;
            memWrite <= 1'b0;
            Branch <= 1'b0;
            ALUControl <= 3'b010;
        end

        if (opcode == 6'b001100) begin //andi - те же флаги что и в addi, кроме алу кнтрола, тут использовать ALUcontrol = 3'b000;
            ALUSrc <= 1'b1;
            RegWrite <= 1'b1;
            memToReg <= 1'b0;
            regDST <= 1'b0;
            memWrite <= 1'b0;
            Branch <= 1'b0;
            ALUControl <= 3'b000;
        end
        #1;
    end
endmodule