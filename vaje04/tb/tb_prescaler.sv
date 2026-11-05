module tb_prescaler;

    // Testbench signals
    logic clk;
    logic rst;
    logic [7:0] limit;
    logic pwm_tick;

    // Instantiate the DUT
    prescaler dut (
        .clk(clk),
        .rst(rst),
        .limit(limit),
        .pwm_tick(pwm_tick)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test procedure
    initial begin
        $dumpfile("tb_prescaler.vcd");
        $dumpvars(0, tb_prescaler);

        clk = 0;
        rst = 1;
        limit = 5;
        #10;
        rst = 0;

        // Let the counter run through several periods
        #200;

        $finish;
    end

    // Log every pwm_tick pulse
    always @(posedge clk) begin
        if (pwm_tick)
            $display("t=%0t pwm_tick pulse", $time);
    end

endmodule