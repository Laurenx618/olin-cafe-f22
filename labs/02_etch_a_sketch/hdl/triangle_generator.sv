// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and hold its value otherwise.

module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;
logic [N-1:0] adder_a, c_out, counter_pp, count_is_0, count_is_max, next_state;

typedef enum logic {COUNTING_UP = 1'b1, COUNTING_DOWN = 1'b0} state_t;
state_t state;
always_comb begin
    case (state)
        COUNTING_UP: adder_a = 1;
        COUNTING_DOWN: adder_a = -1;
        default : adder_a = 0;
    endcase
end
adder_n #(.N(N)) adder (
    .a(adder_a), .b(out), .c_in(1'b0), .sum(counter_pp), .c_out(c_out)
);

always_ff @(posedge clk) begin : Register
    if (rst) out <= 0;
    else if (ena) out <= counter_pp;
end

always_comb begin
    count_is_0 = (counter_pp == 0);
    count_is_max = (counter_pp == {N{1'b1}});

    case (state)
        COUNTING_UP: begin
            if (count_is_max) begin
                next_state = COUNTING_DOWN;
            end
            else next_state = COUNTING_UP;
        end
        COUNTING_DOWN: begin
            if (count_is_0) next_state = COUNTING_UP;
            else next_state = COUNTING_DOWN;
        end
        default: next_state = COUNTING_UP;
    endcase
end

always_ff @( posedge clk ) begin : blockName
    if (rst) state <= 0;
    else if (ena) state <= next_state;
end

endmodule