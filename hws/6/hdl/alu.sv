`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"


module comparator_lt(a, b, out);
parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out;

logic [N-1:0] sum;
logic [N-1:0] c_out_temp;
logic [N-1:0] c_out;
wire signed [N-1:0] b_invert;
adder_n #(.N(N)) add_b ( .a(~b), .b(31'd1), .c_in(1'b0), .sum(b_invert), .c_out(c_out_temp));
adder_n #(.N(N)) adder_32bit_a ( .a(a), .b(b_invert), .c_in(1'b0), .sum(sum), .c_out(c_out));
always_comb out = sum;
endmodule

module sub(a, b, out);
parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out;

logic [N-1:0] sum;
logic [N-1:0] c_out_temp;
logic [N-1:0] c_out;
wire signed [N-1:0] b_invert;
adder_n #(.N(N)) add_b ( .a(~b), .b(31'd1), .c_in(1'b0), .sum(b_invert), .c_out(c_out_temp));
adder_n #(.N(N)) adder_32bit_a ( .a(a), .b(b_invert), .c_in(1'b0), .sum(sum), .c_out(c_out));
always_comb out = sum;
endmodule


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

logic [N-1:0] b_out, SLL_temp, SRL_temp, SRA_temp, ALU_AND, ALU_OR, ALU_XOR, ALU_ADD, ALU_SLL, ALU_SRL, ALU_SRA, ALU_SLT, ALU_SUB, ALU_SLTU;
logic carry, negative, lt;
// assign carries[0] = c_in;
wire c_out;

// comparator_lt #(.N(N)) compare0(.a(b), .b(32'd31), .out(lt));
shift_left_logical #(.N(N)) sll(.in(a), .shamt(b), .out(SLL_temp));
shift_right_logical #(.N(N)) srl(.in(a), .shamt(b), .out(SRL_temp));
shift_right_arithmetic #(.N(N)) sra(.in(a), .shamt(b), .out(SRA_temp));
adder_n #(.N(N)) adder_32bit_a (.a(a), .b(b_out), .c_in(control), .sum(ALU_ADD), .c_out(c_out));
comparator_lt #(.N(N)) ls (.a(a), .b(b), .out(ALU_SLT));
sub #(.N(N)) subtraction (.a(a), .b(b), .out(ALU_SUB));

always_comb begin
    lt = (b>32);
    b_out = control[0] ? ~b : b;
    ALU_AND = a & b;
    ALU_OR = a | b;
    ALU_XOR = a ^ b;
    ALU_SLL = lt ? 32'b0 : SLL_temp;
    ALU_SRL = lt ? 32'b0 : SRL_temp;
    ALU_SRA = lt ? 32'b0 : SRA_temp;
end



mux16 #(.N(N)) MUX_0 (
	// python: print(", ".join([f".in{i:02d}(in{i:02d})" for i in range(16)]))
	.in00(32'b0), .in01(ALU_AND), .in02(ALU_OR), .in03(ALU_XOR), 
	.in04(32'b0), .in05(ALU_SLL), .in06(ALU_SRL), .in07(ALU_SRA), 
	.in08(ALU_ADD), .in09(32'b0), .in10(32'b0), .in11(32'b0), 
	.in12(ALU_SUB), .in13(ALU_SLT), .in14(32'b0), .in15(ALU_SLTU),
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
    overflow = (a[31] ~^ b[31] ~^ control[0]) & (ALU_ADD[31] ^ a[31]) & (~control);
    carry = (~control) & c_out;
    negative = result[31];
    zero = &(~result);
    equal = &(a ~^ b);
end


endmodule