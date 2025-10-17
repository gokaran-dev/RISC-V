`timescale 1ns / 1ps
module alu (
    input  [31:0] ID_EX_A,
    input  [31:0] ID_EX_B,
    input  [5:0]  opcode,
    output reg [31:0] ALU_result
 
    );

    parameter ADD = 6'b000000;
    parameter SUB = 6'b000001;
    parameter AND = 6'b000010;
    parameter OR  = 6'b000011;
    parameter SLT = 6'b000100;
    parameter MUL = 6'b000101;

    always @(*) begin
        case (opcode)
            ADD: ALU_result = ID_EX_A + ID_EX_B;
            SUB: ALU_result = ID_EX_A - ID_EX_B;
            AND: ALU_result = ID_EX_A & ID_EX_B;
            OR : ALU_result = ID_EX_A  | ID_EX_B;
            SLT: ALU_result = (ID_EX_A < ID_EX_B) ? 32'd1 : 32'd0;
            MUL: ALU_result = ID_EX_A * ID_EX_B;
            default: ALU_result = 32'hxxxxxxxx;
        endcase
    end

endmodule
