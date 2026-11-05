module prescaler #(parameter PRESCALER_WIDTH = 8)(
    input logic clk,
    input logic rst,
    input logic [PRESCALER_WIDTH-1:0] limit,
    output logic pwm_tick
);

    logic [PRESCALER_WIDTH-1:0] counter;

    always_ff @(posedge clk) begin
        if (rst) begin
            pwm_tick <= 1'b0;
            counter <= '0;
        end
        else if (counter == limit - 1) begin
            pwm_tick <= 1'b1;
            counter <= '0;
        end
        else begin
            pwm_tick <= 1'b0;
            counter <= counter + 1;
        end
    end

endmodule


// PWM controller
module PWM_controller (
    input logic clk,
    input logic rst,
    input logic [1:0] SW,
    input logic pwm_tick,
    output logic PWM
);
    logic [3:0] counter;

    always_ff @(posedge clk) begin
        if (rst) begin
            counter <= 4'b0;
        end
        else if (pwm_tick) begin
            counter <= counter + 1;
        end
    end

    logic [3:0] threshold;

    always_comb begin
        case (SW)
            2'b00:   threshold = 4'b0000;
            2'b01:   threshold = 4'b0010;
            2'b10:   threshold = 4'b0100;
            2'b11:   threshold = 4'b1000;
            default: threshold = 4'b0000;
        endcase
    end

    assign PWM = counter < threshold;

endmodule


module rgb_controller (
    input logic clock,
    input logic reset,
    input logic [7:0] SW,
    output logic [2:0] RGB,
    output logic pwm_out
);
    // define parameters
    localparam PRESCALER_WIDTH =  12;
    localparam LIMIT = 3125;

    // define the limit_value
    logic [PRESCALER_WIDTH-1:0] limit_value;
    assign limit_value = LIMIT;

    // instantiate the prescaler
    // produces a 32 kHz clock
    logic pwm_tick;
    prescaler #(.PRESCALER_WIDTH(PRESCALER_WIDTH)) pwm_prescaler(
        .clk(clock),
        .rst(reset),
        .limit(limit_value),
        .pwm_tick(pwm_tick)
    );

    // instantiate the PWM controller for the red LED
    PWM_controller PWM_red(
        .clk(clock),
        .rst(reset),
        .SW(SW[1:0]),
        .pwm_tick(pwm_tick),
        .PWM(RGB[0])
    );

    // instantiate the PWM controller for the green LED
    PWM_controller PWM_green(
        .clk(clock),
        .rst(reset),
        .SW(SW[3:2]),
        .pwm_tick(pwm_tick),
        .PWM(RGB[1])
    );

    // instantiate the PWM controller for the blue LED
    PWM_controller PWM_blue(
        .clk(clock),
        .rst(reset),
        .SW(SW[5:4]),
        .pwm_tick(pwm_tick),
        .PWM(RGB[2])
    );

    // oscilloscope probe: mirror the RGB channel selected by SW[7:6] onto pwm_out
    // employ always_comb and case statement, do not forget the default branch
    always_comb begin
        case (SW[7:6])
            2'b00:   pwm_out = RGB[0];
            2'b01:   pwm_out = RGB[1];
            2'b10:   pwm_out = RGB[2];
            default: pwm_out = 1'b0;
        endcase
    end

endmodule