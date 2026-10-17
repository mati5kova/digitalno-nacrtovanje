module top (
    input  logic [7:0] num1, num2,
    output logic [7:0] num1_led, num2_led,
    output logic CA, CB, CC, CD, CE, CF, CG, DP,
    output logic AN [7:0]
);

assign num1_led = num1;
assign num2_led = num2;

logic less_than, greater_than, equal_to;

assign less_than = num1 < num2;
assign greater_than = num1 > num2;
assign equal_to = num1 == num2;

assign CA = ~(greater_than || equal_to);
assign CB = 1'b1;
assign CC = ~(greater_than);
assign CD = ~(less_than || greater_than || equal_to);
assign CE = ~(less_than || greater_than || equal_to);
assign CF = ~(less_than || greater_than || equal_to);
assign CG = ~(greater_than || equal_to);

assign DP = 1'b1; // decimal point

assign AN = 8'b11110111;

endmodule
