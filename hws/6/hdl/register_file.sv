`default_nettype none
`timescale 1ns/1ps

module register_file(
  clk, //Note - intentionally does not have a reset! 
  wr_ena, wr_addr, wr_data,
  rd_addr0, rd_data0,
  rd_addr1, rd_data1
);
// Not parametrizing, these widths are defined by the RISC-V Spec!
input wire clk;

// Write channel
input wire wr_ena;
input wire [4:0] wr_addr;
input wire [31:0] wr_data;

// Two read channels
input wire [4:0] rd_addr0, rd_addr1;
output logic [31:0] rd_data0, rd_data1;
logic [31:0] x00; 
parameter RESET = 0;

always_comb x00 = 32'd0; // ties x00 to ground. 

// DON'T DO THIS:
// logic [31:0] register_file_registers [31:0]
// CAN'T: because that's a RAM. Works in simulation, fails miserably in synthesis.

// Hint - use a scripting language if you get tired of copying and pasting the logic 32 times - e.g. python: print(",".join(["x%02d"%i for i in range(0,32)]))
wire [31:0] x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
N = 32;

mux32 #(.N(N)) MUX_0 (
	// python: print(", ".join([f".in{i:02d}(in{i:02d})" for i in range(16)]))
	.in00(x00), .in01(x01), .in02(x02), .in03(x03), 
	.in04(x04), .in05(x05), .in06(x06), .in07(x07), 
	.in08(x08), .in09(x09), .in10(x10), .in11(x11), 
	.in12(x12), .in13(x13), .in14(x14), .in15(x15),
  .in00(x16), .in01(x17), .in02(x18), .in03(x19), 
	.in04(x20), .in05(x21), .in06(x22), .in07(x23), 
	.in08(x24), .in09(x25), .in10(x26), .in11(x27), 
	.in12(x28), .in13(x29), .in14(x30), .in15(x31),
	.select(rd_addr0[4:0]), .out(rd_data0)
);


mux32 #(.N(N)) MUX_1 (
	// python: print(", ".join([f".in{i:02d}(in{i:02d})" for i in range(16)]))
	.in00(x00), .in01(x01), .in02(x02), .in03(x03), 
	.in04(x04), .in05(x05), .in06(x06), .in07(x07), 
	.in08(x08), .in09(x09), .in10(x10), .in11(x11), 
	.in12(x12), .in13(x13), .in14(x14), .in15(x15),
  .in00(x16), .in01(x17), .in02(x18), .in03(x19), 
	.in04(x20), .in05(x21), .in06(x22), .in07(x23), 
	.in08(x24), .in09(x25), .in10(x26), .in11(x27), 
	.in12(x28), .in13(x29), .in14(x30), .in15(x31),
	.select(rd_addr1[4:0]), .out(rd_data1)
);

decoder_5_to_32 #(.N(N)) decoder_0 (
  .ena(wr_ena), .in(wr_addr), .out(wr_data)
);
alu #(.N(N)) alu(.a(rd_data0), .b(rd_data1), .control(), .result(wr_data), .overflow(), .zero(), .equal())

always_comb d = rst ? RESET : (ena ? d : q);
always_ff @(posedge clk) begin
  q <= d;
end



endmodule