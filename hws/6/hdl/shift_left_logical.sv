`timescale 1ns/1ps
`default_nettype none
module shift_left_logical(in, shamt, out);

parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

input wire [N-1:0] in;            // the input number that will be shifted left. Fill in the remainder with zeros.
input wire [$clog2(N)-1:0] shamt; // the amount to shift by (think of it as a decimal number from 0 to 31). 
output logic [N-1:0] out;       

mux32 #(.N(N)) MUX_0 (
	// python: print(", ".join([f".in{i:02d}(in{i:02d})" for i in range(16)]))
	.in00(in), .in01({{in[30:0]},{1{1'b0}}}), .in02({{in[29:0]},{2{1'b0}}}), .in03({{in[28:0]},{3{1'b0}}}), 
	.in04({{in[27:0]},{4{1'b0}}}), .in05({{in[26:0]},{5{1'b0}}}), .in06({{in[25:0]},{6{1'b0}}}), .in07({{in[24:0]},{7{1'b0}}}), 
	.in08({{in[23:0]},{8{1'b0}}}), .in09({{in[22:0]},{9{1'b0}}}), .in10({{in[21:0]},{10{1'b0}}}), .in11({{in[20:0]},{11{1'b0}}}), 
	.in12({{in[19:0]},{12{1'b0}}}), .in13({{in[18:0]},{13{1'b0}}}), .in14({{in[17:0]},{14{1'b0}}}), .in15({{in[16:0]},{15{1'b0}}}),
    .in16({{in[15:0]},{16{1'b0}}}), .in17({{in[14:0]},{17{1'b0}}}), .in18({{in[13:0]},{18{1'b0}}}), .in19({{in[12:0]},{19{1'b0}}}), 
	.in20({{in[11:0]},{20{1'b0}}}), .in21({{in[10:0]},{21{1'b0}}}), .in22({{in[9:0]},{22{1'b0}}}), .in23({{in[8:0]},{23{1'b0}}}), 
	.in24({{in[7:0]},{24{1'b0}}}), .in25({{in[6:0]},{25{1'b0}}}), .in26({{in[5:0]},{26{1'b0}}}), .in27({{in[4:0]},{27{1'b0}}}), 
	.in28({{in[3:0]},{28{1'b0}}}), .in29({{in[2:0]},{29{1'b0}}}), .in30({{in[1:0]},{30{1'b0}}}), .in31({31{1'b0}}),
	.select(shamt), .out(out)
);

endmodule
