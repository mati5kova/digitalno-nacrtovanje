module top (
    input logic clock,
    input logic reset,
    input logic [7:0] SW,
    output logic [2:0] RGB,
    output logic pwm_out
);

    rgb_controller controller(
        .clock(clock),
        .reset(reset),
        .SW(SW),
        .RGB(RGB),
        .pwm_out(pwm_out)
    );

endmodule