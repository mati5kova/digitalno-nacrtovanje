module sync_dff (
    input logic d,
    input logic reset,
    input logic clk,
    output logic q, 
    output logic nq
);
    always_ff @ ( posedge clk ) begin : dff
        if (reset) begin
            q <= 1'b0;
            nq <= 1'b1;
        end
        else begin
            q <= d;
            nq <= ~d;
        end
    end
endmodule

module async_dff (
    input logic d,
    input logic reset,
    input logic clk,
    output logic q, 
    output logic nq
);
    always_ff @ ( posedge clk or posedge reset) begin : dff
        if (reset) begin
            q <= 1'b0;
            nq <= 1'b1;
        end
        else begin
            q <= d;
            nq <= ~d;
        end
    end
endmodule