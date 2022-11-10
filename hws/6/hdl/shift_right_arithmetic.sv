`timescale 1ns/1ps
`default_nettype none
module shift_right_arithmetic(in,shamt,out);
parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

//port definitions
input  wire [N-1:0] in;    // A 32 bit input
input  wire [$clog2(N)-1:0] shamt; // Shift ammount
output wire [N-1:0] out; // The same as SRL, but maintain the sign bit (MSB) after the shift! 
// It's similar to SRL, but instead of filling in the extra bits with zero, we
// fill them in with the sign bit.
// Remember the *repetition operator*: {n{bits}} will repeat bits n times.

mux32 #(.N(N)) MUX_0 (
	// python: print(", ".join([f".in{i:02d}(in{i:02d})" for i in range(16)]))
	.in00(in), .in01({{1{in[31]}},{in[31:1]}}), .in02({{2{in[31]}},{in[31:2]}}), .in03({{3{in[31]}},{in[31:3]}}), 
	.in04({{4{in[31]}},{in[31:4]}}), .in05({{5{in[31]}},{in[31:5]}}), .in06({{6{in[31]}},{in[31:6]}}), .in07({{7{in[31]}},{in[31:7]}}), 
	.in08({{8{in[31]}},{in[31:8]}}), .in09({{9{in[31]}},{in[31:9]}}), .in10({{10{in[31]}},{in[31:10]}}), .in11({{11{in[31]}},{in[31:11]}}), 
	.in12({{12{in[31]}},{in[31:12]}}), .in13({{13{in[31]}},{in[31:13]}}), .in14({{14{in[31]}},{in[31:14]}}), .in15({{15{in[31]}},{in[31:15]}}),
    .in16({{16{in[31]}},{in[31:16]}}), .in17({{17{in[31]}},{in[31:17]}}), .in18({{18{in[31]}},{in[31:18]}}), .in19({{19{in[31]}},{in[31:19]}}), 
	.in20({{20{in[31]}},{in[31:20]}}), .in21({{21{in[31]}},{in[31:21]}}), .in22({{22{in[31]}},{in[31:22]}}), .in23({{23{in[31]}},{in[31:23]}}), 
	.in24({{24{in[31]}},{in[31:24]}}), .in25({{25{in[31]}},{in[31:25]}}), .in26({{26{in[31]}},{in[31:26]}}), .in27({{27{in[31]}},{in[31:27]}}), 
	.in28({{28{in[31]}},{in[31:28]}}), .in29({{29{in[31]}},{in[31:29]}}), .in30({{30{in[31]}},{in[31:30]}}), .in31({{31{in[31]}},{in[31]}}),
	.select(shamt), .out(out)
);

endmodule
