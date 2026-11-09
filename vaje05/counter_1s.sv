module prescaler #(parameter LIMIT = 100000000) ( // default 1Hz
    input logic clk,
    input logic rst,
    output logic tick
);
    localparam int WIDTH = (LIMIT > 1) ? $clog2(LIMIT) : 1;

    logic [WIDTH-1:0] counter;

    always_ff @(posedge clk) begin : count
        if (rst) begin
            counter <= '0;
            tick <= 1'b0;
        end
        else if (counter == LIMIT - 1) begin
            counter <= '0;
            tick <= 1'b1;
        end
        else begin
            counter <= counter + 1'b1;
            tick <= 1'b0;
        end
    end   
endmodule

module counter_1s (
    input logic clk,
    input logic rst,    // BTNC
    input logic enable, // SW0
    output logic [31:0] count
);

    logic second;
    prescaler #(.LIMIT(100_000_000)) oneHz (
        .clk(clk),
        .rst(rst | ~enable),
        .tick(second)
    );

    always_ff @(posedge clk) begin : counter
        if (rst) begin
            count <= 'b0;
        end
        else if (enable) begin
            if (second) begin
               count <= count + 1'b1; 
            end
        end
    end
    
endmodule