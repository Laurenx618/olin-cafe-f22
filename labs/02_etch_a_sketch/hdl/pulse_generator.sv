/*
  Outputs a pulse generator with a period of "ticks".
  out should go high for one cycle ever "ticks" clocks.
*/
`timescale 1ns/1ps

module adder_1(a, b, c_in, sum, c_out);

input wire a, b, c_in;
output logic sum, c_out;

logic half_sum;
logic a_and_b;

always_comb begin : adder_gates
  // See Example 4.7 (p. 182) in your textbook for an explanation.
  a_and_b = a & b;
  half_sum = a ^ b;
  c_out = a_and_b | (half_sum & c_in);
  sum = half_sum ^ c_in;
end

endmodule


module adder_n(a, b, c_in, sum, c_out);

parameter N = 2;

input  wire [N-1:0] a, b;
input wire c_in;
output logic [N-1:0] sum;
output wire c_out;

wire [N:0] carries;
assign carries[0] = c_in;
assign c_out = carries[N];
generate
  genvar i;
  for(i = 0; i < N; i++) begin : ripple_carry
    adder_1 ADDER (
      .a(a[i]),
      .b(b[i]),
      .c_in(carries[i]),
      .sum(sum[i]),
      .c_out(carries[i+1])
    );
  end
endgenerate

endmodule


module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;
logic c_out;
logic [N-1:0] counter;
logic counter_comparator;

logic [N-1:0] counter_pp;
logic [N-1:0] reset_ff;
adder_n #(.N(N)) adder_0(
  .a(7'd1), .b(counter), .c_in(1'b0), .sum(counter_pp), .c_out(c_out)
);

always_ff @ ( posedge clk ) begin
  if (reset_ff) counter <= 0;
  else if (ena) counter <= counter_pp;
end

always_comb begin : interesting
  out = &(counter_pp ~^ ticks);
  reset_ff = out | rst;
end

endmodule
