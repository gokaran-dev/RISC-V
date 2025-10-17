`timescale 1ns / 1ps

module tb_alu_operations_five;

    reg signed [31:0] ID_EX_A;
    reg signed [31:0] ID_EX_B;
    reg signed [5:0]  opcode;
    reg               clk;
    reg               rst_n;
    reg               load;

    wire signed [31:0] ALU_result;

    // Instantiate DUT
    alu_operations_five DUT (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .ID_EX_A(ID_EX_A),
        .ID_EX_B(ID_EX_B),
        .opcode(opcode),
        .ALU_result(ALU_result)
    );


    localparam ADD = 6'b000000;
    localparam SUB = 6'b000001;
    localparam AND = 6'b000010;
    localparam OR  = 6'b000011;
    localparam SLT = 6'b000100;
    localparam MUL = 6'b000101;

    //clock generation
    initial clk = 1'b0;
    always #5 clk = ~clk;

    //made a simple task so applying different stimulus becomes easier
    task apply;
        input signed [31:0] a;
        input signed [31:0] b;
        input signed [5:0]  op;
        input integer  wait_cycles;
        begin
            ID_EX_A = a;
            ID_EX_B = b;
            opcode  = op;
            @(posedge clk);
            load = 1'b1;
            @(posedge clk);
            load = 1'b0;
            repeat (wait_cycles) @(posedge clk);
        end
    endtask

    initial
    begin
        rst_n = 1'b0;
        load  = 1'b0;
        ID_EX_A = 32'sd0;
        ID_EX_B = 32'sd0;
        opcode  = 6'b000000;
        
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
        
        #100 //for registers to settle in.
        
       
        apply(32'd10,  32'd5,  ADD,  2);   
        apply(32'd20,  32'd8,  SUB,  2);   

        apply(32'hFF00FF00, 32'h0F0F0F0F, AND, 2);
        apply(32'hFF00FF00, 32'h0F0F0F0F, OR,  2);
        
        //signed operation check
        apply(32'd15, 32'd20, SLT, 2);     
        apply(32'd25, 32'd20, SLT, 2);     
        apply(32'hFFFFFFFF, 32'd1, SLT, 2);
        
        //multiplication and overflow check
        apply(32'd6, 32'd7, MUL, 2);       
        apply(32'd65536, 32'd65536, MUL, 2); 
        
        apply(32'd5, 32'd10, SUB, 2);    

        // invalid opcode default
        apply(32'b10101010101010101010101010101010, 32'd0, 6'b111111, 2);

        repeat (4) @(posedge clk);
        $finish;
    end

endmodule
