module value_to_digit (
    input logic [31:0] value,
    input logic [7:0] anode_select,
    output logic [3:0] digit
);
    always_comb begin
        case (anode_select)
            8'hFE: digit = value[3:0];
            8'hFD: digit = value[7:4];
            8'hFB: digit = value[11:8];
            8'hF7: digit = value[15:12];
            8'hEF: digit = value[19:16];
            8'hDF: digit = value[23:20];
            8'hBF: digit = value[27:24];
            8'h7F: digit = value[31:28];
            default: digit = 4'h0;
        endcase
    end
endmodule

module digit_to_segments (
    input logic [3:0] digit,
    output logic [6:0] segs // segs[6:0] = {G, F, E, D, C, B, A}
);
    /*
         ----A----
        |         |
        F         B
        |         |
        |----G----|
        |         |
        E         C
        |         |
        |----D----|
    */
    always_comb begin
        case (digit)
            4'h0: segs = 7'b1000000;
            4'h1: segs = 7'b1111001;
            4'h2: segs = 7'b0100100;
            4'h3: segs = 7'b0110000;
            4'h4: segs = 7'b0011001;
            4'h5: segs = 7'b0010010;
            4'h6: segs = 7'b0000010;
            4'h7: segs = 7'b1111000;
            4'h8: segs = 7'b0000000;
            4'h9: segs = 7'b0010000;
            4'hA: segs = 7'b0001000;
            4'hB: segs = 7'b0000011;
            4'hC: segs = 7'b1000110;
            4'hD: segs = 7'b0100001;
            4'hE: segs = 7'b0000110;
            4'hF: segs = 7'b0001110;
            default: segs = 7'b1000000;
        endcase
    end
endmodule


module timer_002s (
    input logic clk,
    input logic rst,
    output logic time_tick
);
    prescaler #(.LIMIT(200_000)) timer (
        .clk(clk),
        .rst(rst),
        .tick(time_tick)
    );
endmodule

module anode_assert (
    input logic clk,
    input logic rst,
    input logic clock_enable,
    output logic [7:0] anode_select
);
    logic [2:0] counter_3b;

    always_ff @(posedge clk) begin
        if (rst) begin
            counter_3b <= '0;
            // anode_select <= '0;
        end
        else if (clock_enable) begin
            counter_3b <= counter_3b + 1'b1;
        end
    end

    assign anode_select = ~(8'b1 << counter_3b);
endmodule

module SevSegDisplay (
    input logic clk,
    input logic rst,
    input logic [3:0] digit1, // least significant digit, shown on AN0
    input logic [3:0] digit2,
    input logic [3:0] digit3,
    input logic [3:0] digit4,
    input logic [3:0] digit5,
    input logic [3:0] digit6,
    input logic [3:0] digit7,
    input logic [3:0] digit8, // most significant digit, shown on AN7
    output logic [7:0] anode_select,
    output logic [6:0] segs
);
    logic [31:0] digit;
    assign digit = {digit8, digit7, digit6, digit5, digit4, digit3, digit2, digit1};

    logic [3:0] current_digit;

    logic time_tick;

    timer_002s timer002s (
        .clk(clk),
        .rst(rst),
        .time_tick(time_tick)
    );

    anode_assert anodeAssertInstance (
        .clk(clk),
        .rst(rst),
        .clock_enable(time_tick),
        .anode_select(anode_select)
    );

    value_to_digit v2d (
        .value(digit),
        .anode_select(anode_select),
        .digit(current_digit)
    );

    digit_to_segments digit2segments (
        .digit(current_digit),
        .segs(segs)
    );

endmodule