module CLA_Adder_Subtractor (
    input [3:0] A, B,
    input mode, // 0 = add, 1 = subtract
    output [3:0] Sum,
    output Cout
);
    wire [3:0] B_adj = B ^ {4{mode}}; // 2's complement B if subtracting
    wire [3:0] G = A & B_adj;         // Generate
    wire [3:0] P = A ^ B_adj;         // Propagate
    wire [4:0] C;                     // Carry chain

    assign C[0] = mode;              // Cin = 0 for add, 1 for subtract
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    
    assign Sum = P ^ C[3:0];
    assign Cout = C[4];
endmodule