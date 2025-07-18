﻿# Arithmetic Calculator (Verilog)

This project implements a **4-bit Arithmetic Calculator** in Verilog that supports multiple operations, including addition, subtraction, multiplication (Booth's algorithm), division (restoring division), GCD computation (using FSM), and bitwise logic operations (AND, OR, XOR).

## 🛠 Features

- **ADD (000)**: 4-bit addition with carry-out using a CLA-based adder.
- **SUB (001)**: 4-bit subtraction using 2's complement.
- **MUL (010)**: Signed 4-bit multiplication using Booth's Algorithm.
- **DIV (011)**: Unsigned 4-bit restoring division with quotient and remainder output.
- **GCD (100)**: Computes the greatest common divisor using a finite state machine.


## 📦 Module Overview
### 1. `CLA_Adder_Subtractor.v`
Implements a 4-bit carry lookahead adder/subtractor using generate and propagate logic.

### 2. `booth_multiplier.v`
Performs signed multiplication using Booth's algorithm (efficient for negative numbers).

### 3. `Restoring_Division.v`
Performs 4-bit unsigned division using the restoring division algorithm with error detection for divide-by-zero.

### 4. `GCD_FSM.v`
Calculates the GCD of two numbers using the Euclidean algorithm within an FSM. Outputs `done` and `error` signals.

### 5. `Arithmetic_Calculator.v`
Top-level module that integrates all arithmetic units. Operates based on a 3-bit `opcode` and synchronizes control and result signals for each operation.

### 6. `Arithmetic_Calculator_TB.v`
SystemVerilog testbench to validate all operations. Automatically sequences through test cases, checks outputs, and displays readable results to the console.


## 📝 How to Run

1. **Using Xcelium, ModelSim, or Icarus Verilog:**
   ```bash
   iverilog -o calc_tb Arithmetic_Calculator.v CLA_Adder_Subtractor.v booth_multiplier.v Restoring_Division.v GCD_FSM.v Arithmetic_Calculator_TB.v
   vvp calc_tb
**Waveform (Optional):
Add $dumpfile("calc.vcd"); $dumpvars; in the testbench to generate waveform for GTKWave.
📌 Notes
Supports signed multiplication and unsigned division.

GCD module is FSM-based and handles invalid inputs (like A=0, B=0).

Each operation is initiated using a start pulse and confirmed with a done signal.

✍️ Author
Anshika Yadav
B.Tech ECE | IIT Guwahati

