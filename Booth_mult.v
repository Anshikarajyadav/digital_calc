module booth_multiplier(
    input signed [3:0] multiplicand,
    input signed [3:0] multiplier,
    output reg signed [7:0] product
);
    reg signed [7:0] A, S;
    reg signed [8:0] P; // {acc[3:0], multiplier[3:0], Q-1}
    integer i;

    always @* begin
        A = {multiplicand, 4'b0000};         // multiplicand shifted left by 4
        S = {-multiplicand, 4'b0000};        // -multiplicand shifted left by 4
        P = {4'b0000, multiplier, 1'b0};     // Initialize P = {acc=0, multiplier, Q-1}

        for (i = 0; i < 4; i = i + 1) begin
            case (P[1:0])
                2'b01: P[8:1] = P[8:1] + A; // Add multiplicand
                2'b10: P[8:1] = P[8:1] + S; // Subtract multiplicand
                default: ; // No op
            endcase
            // Arithmetic right shift (preserve sign)
            P = {P[8], P[8:1]};
        end

        product = P[8:1]; // Final 8-bit signed product
    end
endmodule