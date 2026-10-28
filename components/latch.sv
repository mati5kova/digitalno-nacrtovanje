module latch(
    input logic d,
    input logic en,
    output logic q,
    output logic nq,
);
    always_latch begin : blockName
        if (en) begin
            q <= d;
            nq <= ~d;
        end
    end
endmodule