`timescale 1ns/1ps
`default_nettype none
module shift_left_logical(in, shamt, out);

parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

input wire [N-1:0] in;            // the input number that will be shifted left. Fill in the remainder with zeros.
input wire [$clog2(N)-1:0] shamt; // the amount to shift by (think of it as a decimal number from 0 to 31). 
output logic [N-1:0] out;       

mux32 #(.N(N)) MUX_0 (
	// python: print(", ".join([f".in{i:02d}(in{i:02d})" for i in range(16)]))
	.in00(in), .in01({{in[31:1]},{1{1'b0}}}), .in02({{in[31:2]},{2{1'b0}}}), .in03({{in[31:3]},{3{1'b0}}}), 
	.in04({{in[31:4]},{4{1'b0}}}), .in05({{in[31:5]},{5{1'b0}}}), .in06({{in[31:6]},{6{1'b0}}}), .in07({{in[31:7]},{7{1'b0}}}), 
	.in08({{in[31:8]},{8{1'b0}}}), .in09({{in[31:9]},{9{1'b0}}}), .in10({{in[31:10]},{10{1'b0}}}), .in11({{in[31:11]},{11{1'b0}}}), 
	.in12({{in[31:12]},{12{1'b0}}}), .in13({{in[31:13]},{13{1'b0}}}), .in14({{in[31:14]},{14{1'b0}}}), .in15({{in[31:15]},{15{1'b0}}}),
    .in16({{in[31:16]},{16{1'b0}}}), .in17({{in[31:17]},{17{1'b0}}}), .in18({{in[31:18]},{18{1'b0}}}), .in19({{in[31:19]},{19{1'b0}}}), 
	.in20({{in[31:20]},{20{1'b0}}}), .in21({{in[31:21]},{21{1'b0}}}), .in22({{in[31:22]},{22{1'b0}}}), .in23({{in[31:23]},{23{1'b0}}}), 
	.in24({{in[31:24]},{24{1'b0}}}), .in25({{in[31:25]},{25{1'b0}}}), .in26({{in[31:26]},{26{1'b0}}}), .in27({{in[31:27]},{27{1'b0}}}), 
	.in28({{in[31:28]},{28{1'b0}}}), .in29({{in[31:29]},{29{1'b0}}}), .in30({{in[31:30]},{30{1'b0}}}), .in31({31{1'b0}}),
	.select(shamt), .out(out)
);

endmodule
