`timescale 1ns / 1ps

module alu_operations_five (
    input  clk,
    input  rst_n,
    input  load,      
    input  signed [31:0]  ID_EX_A,
    input  signed [31:0]  ID_EX_B,
    input  signed [5:0]   opcode,
    output reg signed [31:0] ALU_result
);
    
    
    reg signed [31:0] rA;
    reg signed [31:0] rB;
    reg [5:0] rop;

    localparam ADD = 6'b000000;
    localparam SUB = 6'b000001;
    localparam AND = 6'b000010;
    localparam OR  = 6'b000011;
    localparam SLT = 6'b000100;
    localparam MUL = 6'b000101;

    wire valid_op = (opcode == ADD) || (opcode == SUB) || (opcode == AND) || (opcode == OR)  || (opcode == SLT) || (opcode == MUL);
    
    //operation isolation
    wire signed [31:0] gated_a = valid_op ? ID_EX_A : 32'sd0;
    wire signed [31:0] gated_b = valid_op ? ID_EX_B : 32'sd0;

    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) 
        begin
            rA  <= 32'sd0;
            rB  <= 32'sd0;
            rop <= 6'd0;
            ALU_result <= 32'sd0;
        end 
        
        else 
        begin
            if (load) 
            begin
                rA  <= gated_a;
                rB  <= gated_b;
                rop <= opcode;
            end

            if (load) 
            begin
                case (rop)
                    ADD: ALU_result <= rA + rB;
                    SUB: ALU_result <= rA - rB;
                    AND: ALU_result <= rA & rB;
                    OR : ALU_result <= rA | rB;
                    SLT: ALU_result <= ($signed(rA) < $signed(rB)) ? 32'sd1 : 32'sd0;
                    MUL: ALU_result <= $signed(rA) * $signed(rB);
                    
                    default: ALU_result <= 32'sd0;
                endcase
            end
        end
    end

endmodule
