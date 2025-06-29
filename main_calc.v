module Arithmetic_Calculator (
    input clk,
    input rst,
    input start,
    input [2:0] opcode,  // 3-bit opcode
    input [3:0] operand_A,
    input [3:0] operand_B,
    output reg [7:0] result,
    output reg done,
    output reg error
);
    // Operation codes
    localparam OP_ADD = 3'b000,
               OP_SUB = 3'b001,
               OP_MUL = 3'b010,
               OP_DIV = 3'b011,
               OP_GCD = 3'b100,
              // OP_AND = 3'b101,
               //OP_OR  = 3'b110,
               //OP_XOR = 3'b111;

    // Module outputs
    wire [3:0] add_result, sub_result;
    wire add_cout, sub_cout;
    wire signed [7:0] mul_result;
    wire [3:0] div_quotient, div_remainder;
    wire div_error;
    wire [3:0] gcd_result;
    wire gcd_done, gcd_error;

    // Control signals
    reg start_gcd;
    reg operation_active;
    reg [2:0] current_op;

    // Instantiate modules
    CLA_Adder_Subtractor adder (
        .A(operand_A), .B(operand_B), .mode(1'b0),
        .Sum(add_result), .Cout(add_cout)
    );

    CLA_Adder_Subtractor subtractor (
        .A(operand_A), .B(operand_B), .mode(1'b1),
        .Sum(sub_result), .Cout(sub_cout)
    );

    booth_multiplier mul (
        .multiplicand(operand_A), .multiplier(operand_B),
        .product(mul_result)
    );

    Restoring_Division div (
        .dividend(operand_A), .divisor(operand_B),
        .quotient(div_quotient), .remainder(div_remainder),
        .error(div_error)
    );

    GCD_FSM gcd_unit (
        .clk(clk), .rst(rst), .start(start_gcd),
        .A_in(operand_A), .B_in(operand_B),
        .done(gcd_done), .GCD(gcd_result),
        .error(gcd_error)
    );

    // Main FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
            done <= 0;
            error <= 0;
            start_gcd <= 0;
            operation_active <= 0;
            current_op <= 0;
        end else begin
            start_gcd <= 0;
            done <= 0;
            error <= 0;

            if (start && !operation_active) begin
                operation_active <= 1;
                current_op <= opcode;

                case (opcode)
                    OP_ADD: begin
                        result <= {3'b000, add_cout, add_result};
                        done <= 1;
                        operation_active <= 0;
                    end
                    OP_SUB: begin
                        result <= {3'b000, sub_cout, sub_result};
                        done <= 1;
                        operation_active <= 0;
                    end
                    OP_MUL: begin
                        result <= mul_result;
                        done <= 1;
                        operation_active <= 0;
                    end
                    OP_DIV: begin
                        if (div_error) begin
                            result <= 8'hFF;
                            error <= 1;
                            done <= 1;
                            operation_active <= 0;
                        end else begin
                            result <= {div_quotient, div_remainder};
                            done <= 1;
                            operation_active <= 0;
                        end
                    end
                    OP_GCD: begin
                        start_gcd <= 1;
                    end
                    //OP_AND: begin
                        result <= {4'b0000, operand_A & operand_B};
                        done <= 1;
                        operation_active <= 0;
                    end
                   // OP_OR: begin
                        result <= {4'b0000, operand_A | operand_B};
                        done <= 1;
                        operation_active <= 0;
                    end
                    //OP_XOR: begin
                        result <= {4'b0000, operand_A ^ operand_B};
                        done <= 1;
                        operation_active <= 0;
                    end
                    default: begin
                        result <= 8'hEE;
                        error <= 1;
                        done <= 1;
                        operation_active <= 0;
                    end
                endcase
            end else if (operation_active && current_op == OP_GCD) begin
                if (gcd_done) begin
                    result <= {4'b0000, gcd_result};
                    error <= gcd_error;
                    done <= 1;
                    operation_active <= 0;
                end
            end
        end
    end
endmodule
