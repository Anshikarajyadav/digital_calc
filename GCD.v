module GCD_FSM (
    input clk,
    input rst,
    input start,
    input [3:0] A_in, 
    input [3:0] B_in,
    output reg done,
    output reg [3:0] GCD,
    output reg error
);
    localparam IDLE = 2'b00,
               CALC = 2'b01,
               DONE = 2'b10;

    reg [3:0] A, B;
    reg [1:0] state;
    reg [3:0] nextA, nextB;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            A <= 0;
            B <= 0;
            GCD <= 0;
            done <= 0;
            error <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    error <= 0;
                    if (start) begin
                        if (A_in == 0 && B_in == 0) begin
                            error <= 1;
                            GCD <= 4'b1111;
                            done <= 1;
                            state <= DONE;
                        end else begin
                            A <= A_in;
                            B <= B_in;
                            state <= CALC;
                        end
                    end
                end

                CALC: begin
                    if (B == 0) begin
                        GCD <= A;
                        done <= 1;
                        state <= DONE;
                    end else begin
                        nextA = B;
                        nextB = A % B;
                        A <= nextA;
                        B <= nextB;
                    end
                end

                DONE: begin
                    if (!start)
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule