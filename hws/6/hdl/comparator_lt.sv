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
always_comb out = (~a[N-1] ~& b[N-1]) & sum[N-1];
endmodule