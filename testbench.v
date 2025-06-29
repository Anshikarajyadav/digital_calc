module Arithmetic_Calculator_TB;
    reg clk, rst, start;
    reg [2:0] opcode;
    reg [3:0] operand_A, operand_B;
    wire [7:0] result;
    wire done, error;

    Arithmetic_Calculator uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .opcode(opcode),
        .operand_A(operand_A),
        .operand_B(operand_B),
        .result(result),
        .done(done),
        .error(error)
    );

    // Clock generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize inputs
        rst = 1;
        start = 0;
        opcode = 0;
        operand_A = 0;
        operand_B = 0;
        
        // Reset the system
        #20;
        rst = 0;
        #10;
        
        // Test ADD operation
        test_operation(3'b000, 4'b0101, 4'b0011, "5 + 3 = 8");
        test_operation(3'b000, 4'b1111, 4'b0001, "15 + 1 = 16 (overflow)");
        
        // Test SUB operation
        test_operation(3'b001, 4'b1000, 4'b0011, "8 - 3 = 5");
        test_operation(3'b001, 4'b0011, 4'b1000, "3 - 8 = -5 (2's complement)");
        
        // Test MUL operation
        test_operation(3'b010, 4'b0011, 4'b0100, "3 * 4 = 12");
        test_operation(3'b010, 4'b1101, 4'b0100, "-3 * 4 = -12");
        test_operation(3'b010, 4'b1101, 4'b1100, "-3 * -4 = 12");
        
        // Test DIV operation
        test_operation(3'b011, 4'b1010, 4'b0010, "10 / 2 = 5 rem 0");
        test_operation(3'b011, 4'b1010, 4'b0011, "10 / 3 = 3 rem 1");
        test_operation(3'b011, 4'b1010, 4'b0000, "10 / 0 = Error");
        
        // Test GCD operation
        test_operation(3'b100, 4'b1000, 4'b1100, "GCD(8,12) = 4");
        test_operation(3'b100, 4'b0101, 4'b0011, "GCD(5,3) = 1");
        test_operation(3'b100, 4'b0000, 4'b0000, "GCD(0,0) = Error");
        
        // Test bitwise operations
        test_operation(3'b101, 4'b1100, 4'b1010, "12 AND 10 = 8");
        test_operation(3'b110, 4'b1100, 4'b1010, "12 OR 10 = 14");
        test_operation(3'b111, 4'b1100, 4'b1010, "12 XOR 10 = 6");
        
        // Test invalid opcode
        opcode = 3'bxxx;
        operand_A = 4'b0001;
        operand_B = 4'b0001;
        start = 1;
        #10;
        start = 0;
        wait(done);
        $display("Invalid opcode: Error: %b, Result: %h", error, result);
        #20;
        
        $display("All tests completed");
        $finish;
    end

    task test_operation;
        input [2:0] op;
        input [3:0] A, B;
        input string description;
        begin
            opcode = op;
            operand_A = A;
            operand_B = B;
            start = 1;
            #10;
            start = 0;
            wait(done);
            
            case (op)
                3'b000: $display("%s: %d + %d = %d (Cout: %b)", description, A, B, result[3:0], result[4]);
                3'b001: $display("%s: %d - %d = %d (Cout: %b)", description, A, B, result[3:0], result[4]);
                3'b010: $display("%s: %d * %d = %d", description, $signed(A), $signed(B), $signed(result));
                3'b011: 
                    if (error)
                        $display("%s: Division by zero error", description);
                    else
                        $display("%s: Quotient %d, Remainder %d", description, result[7:4], result[3:0]);
                3'b100: 
                    if (error)
                        $display("%s: GCD undefined error", description);
                    else
                        $display("%s: GCD = %d", description, result[3:0]);
                default: $display("%s: Result = %h", description, result);
            endcase
            #20;
        end
    endtask
endmodule