module tb_pwm_controller;

    // Testbench signals
    logic clk;
    logic rst;
    logic [1:0] SW;
    logic pwm_tick;
    logic PWM;

    // Instantiate the DUT
    PWM_controller dut (
        .clk(clk),
        .rst(rst),
        .SW(SW),
        .pwm_tick(pwm_tick),
        .PWM(PWM)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Stand in for the prescaler: pulse pwm_tick high for one cycle
    // out of every 4 clock cycles
    logic [1:0] tick_count;

    always_ff @(posedge clk) begin
        tick_count <= tick_count + 1;
    end

    assign pwm_tick = (tick_count == 2'd3);

    // Test procedure
    initial begin
        $dumpfile("tb_pwm_controller.vcd");
        $dumpvars(0, tb_pwm_controller);

        clk = 0;
        rst = 1;
        tick_count = 0;
        SW = 2'b00;
        #10;
        rst = 0;

        // Run two full 64-cycle periods (1280 time units) at each duty cycle
        SW = 2'b00; #1280;   // 0 %
        SW = 2'b01; #1280;   // 12.5 %
        SW = 2'b10; #1280;   // 25 %
        SW = 2'b11; #1280;   // 50 %

        $finish;
    end

    // Log every PWM transition, so you can measure how long it stays
    // high relative to the 16-cycle period for each SW value
    always @(PWM) begin
        $display("t=%0t SW=%b PWM=%b", $time, SW, PWM);
    end

endmodule