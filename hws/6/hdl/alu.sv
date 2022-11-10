`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
parameter N = 32; // Don't need to support other numbers, just using this as a constant.

input wire [N-1:0] a, b; // Inputs to the ALU.
input alu_control_t control; // Sets the current operation.
output logic [N-1:0] result; // Result of the selected operation.

output logic overflow; // Is high if the result of an ADD or SUB wraps around the 32 bit boundary.
output logic zero;  // Is high if the result is ever all zeros.
output logic equal; // is high if a == b.

// Use *only* structural logic and previously defined modules to implement an 
// ALU that can do all of operations defined in alu_types.sv's alu_op_code_t.

logic [N-1:0] b_out, sum;
logic AND, carry, negative;
// assign carries[0] = c_in;
wire c_out;
always_comb begin
    b_out = control[0] ? ~b : b;
    AND = a & b;
    OR = a | b;
    XOR = a ^ b;
end

shift_left_logical #(.N(N)) sll(.in(a), .shamt(b), .out(SLL));
shift_right_logical #(.N(N)) srl(.in(a), .shamt(b), .out(SRL));
shift_right_arithmetic #(.N(N)) sra(.in(a), .shamt(b), .out(SRA));
adder_n #(.N(32)) adder_32bit_a (.a(a), .b(b_out), .c_in(control), .sum(ADD), .c_out(c_out));

comparator_lt #(.N(32)) ls(.a(a), .b(b), .out(SLT));


mux16 #(.N(N)) MUX_0 (
	// python: print(", ".join([f".in{i:02d}(in{i:02d})" for i in range(16)]))
	.in00(32'b0), .in01(AND), .in02(OR), .in03(XOR), 
	.in04(32'b0), .in05(SLL), .in06(SRL), .in07(SRA), 
	.in08(ADD), .in09(32'b0), .in10(32'b0), .in11(32'b0), 
	.in12(SUB), .in13(SLT), .in14(32'b0), .in15(SLTU),
	.select(control), .out(result)
);
/*
ALU_AND  = 4'b0001, 1
  ALU_OR   = 4'b0010, 2
  ALU_XOR  = 4'b0011, 3
  ALU_SLL  = 4'b0101, 5
  ALU_SRL  = 4'b0110, 6
  ALU_SRA  = 4'b0111, 7
  ALU_ADD  = 4'b1000, 8
  ALU_SUB  = 4'b1100, 12
  ALU_SLT  = 4'b1101, 13
  ALU_SLTU = 4'b1111, 15
  */


always_comb begin
    overflow = (a[31] ~^ b[31] ~^ control[0]) & (sum[31] ^ a[31]) & (~control);
    carry = (~control) & c_out;
    negative = result[31];
    zero = &(~result);
    equal = &(a ~^ b);
end


endmodule