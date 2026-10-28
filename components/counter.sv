module counter #(parameter LEN = 3) (
    input logic clk,
    input logic reset,
    output logic [LEN-1:0] count
);
    always_ff @(posedge clk) begin
        if (reset) begin
            count <= '0;
        end
        else begin
            count <= count + 1;
        end
    end
endmodule

module counter_next #(parameter LEN = 3) (
    input logic clk,
    input logic reset,
    output logic [LEN-1:0] count
);
    logic [LEN-1:0] count_next;
    always_comb begin
        count_next = count + 1;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            count <= '0;
        end
        else begin
            count <= count_next;
        end
    end
endmodule