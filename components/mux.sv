module mux2 #(parameter WIDTH = 8) (
    input logic [WIDTH-1:0] D0, D1,
    input logic S, // select
    output logic [WIDTH-1:0] Y
);
    assign Y = S ? D1 : D0;
endmodule

module mux3 #(parameter WIDTH = 8) (
    input logic [WIDTH-1:0] D0, D1, D2,
    input logic [1:0] S,
    output logic [WIDTH-1:0] Y
);

    always_comb begin
        case (S)
            2'b01: Y = D1;
            2'b10: Y = D2;
            default: Y = D0;
        endcase
    end

endmodule