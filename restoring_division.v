module Restoring_Division (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg error
);
    integer i;
    reg [7:0] temp;           // 8-bit for shifting dividend + remainder
    reg [4:0] rem;            // 5-bit to hold intermediate remainder

    always @* begin
        if (divisor == 0) begin
            error = 1'b1;
            quotient = 4'b1111;
            remainder = 4'b1111;
        end else begin
            error = 1'b0;
            quotient = 4'b0000;
            temp = {4'b0000, dividend}; // Initialize with dividend in lower 4 bits

            for (i = 0; i < 4; i = i + 1) begin
                temp = temp << 1; // Shift left (remainder << 1 + next bit of dividend)
                rem = temp[7:4] - divisor;

                if (rem[4] == 1) begin
                    // Negative result → restore and append 0
                    quotient = quotient << 1;
                end else begin
                    // Valid subtraction → update remainder and append 1
                    temp[7:4] = rem[3:0];
                    quotient = (quotient << 1) | 1'b1;
                end
            end

            remainder = temp[7:4]; // Final remainder
        end
    end
endmodule