module top (
    input  logic a,        // SW0
    input  logic b,        // SW1
    input  logic c,        // SW2
    output logic [3:0] y   // LED0–LED3
);
    assign y[0] = a & b | c;
    assign y[1] = a & c;
    assign y[2] = a | c;
    assign y[3] = a & b & c;
endmodule