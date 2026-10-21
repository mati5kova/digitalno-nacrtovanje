/*
Your task is to implement a “dummy” 4-bit Arithmetic Logic Unit (ALU) with the following interface:
- a, b: 4-bit inputs 
- alu_control: 3-bit input for selecting the operation 
- c: 4-bit output

`alu_control` Value	       Operation
000	                       Addition
001	                       Subtraction
010	                       Bitwise AND
011	                       Bitwise OR
100	                       Bitwise XOR
101	                       Compare (equal)
110	                       Pass-through b
111	                       Pass-through a
*/

/*
Tips:
1. Employ operators and intermediate signals to obtain the results of each operation. 
2. Connect input signals to the rightmost switches (SW0 to SW7), and selection signals to the leftmost switches (SW13 to SW15). 
   The output signal should be connected to LEDs (LED0 to LED3). 
3. Employ nested conditionals.
*/

module adder4bit (
    input logic  [3:0] a, b,
    output logic [3:0] sum,
    output logic carry_out
);
logic carry1, carry2, carry3;

assign sum[0] = a[0] ^ b[0];
assign carry1 = a[0] & b[0];

assign sum[1] = a[1] ^ b[1] ^ carry1;
assign carry2 = (a[1] & b[1]) | (carry1 & (a[1] ^ b[1]));

assign sum[2] = a[2] ^ b[2] ^ carry2;
assign carry3 = (a[2] & b[2]) | (carry2 & (a[2] ^ b[2]));

assign sum[3] = a[3] ^ b[3] ^ carry3;
assign carry_out = (a[3] & b[3]) | (carry3 & (a[3] ^ b[3]));
endmodule

module subtractor4bit(
    input logic [3:0] a, b,
    output logic [3:0] diff,
    output logic underflow
);
assign diff = a - b;
assign underflow = a < b;
endmodule

module and4bit(
    input logic [3:0] a, b,
    output logic [3:0] c
);
assign c = a & b;
endmodule

module or4bit(
    input logic [3:0] a, b,
    output logic [3:0] c
);
assign c = a | b;
endmodule

module xor4bit(
    input logic [3:0] a, b,
    output logic [3:0] c
);
assign c = a ^ b;
endmodule

module compare4bit(
    input logic [3:0] a, b,
    output logic [3:0] c
);
assign c = a == b ? 4'b1111 : 4'b0000;
endmodule

module top (
    input logic  [3:0] a, b,
    input logic  [2:0] alu_control,
    output logic  [3:0] c
);

logic carry_out;
logic [3:0] result_add;
adder4bit operation_add (
    .a(a),
    .b(b),
    .sum(result_add),
    .carry_out(carry_out)
);

logic underflow;
logic [3:0] result_sub;
subtractor4bit operation_sub(
    .a(a),
    .b(b),
    .diff(result_sub),
    .underflow(underflow)
);

logic [3:0] result_and;
and4bit operation_and(
    .a(a),
    .b(b),
    .c(result_and)
);

logic [3:0] result_or;
or4bit operation_or(
    .a(a),
    .b(b),
    .c(result_or)
);

logic [3:0] result_xor;
xor4bit operation_xor(
    .a(a),
    .b(b),
    .c(result_xor)
);

logic [3:0] result_compare;
compare4bit operation_compare(
    .a(a),
    .b(b),
    .c(result_compare)
);

always_comb begin
    case (alu_control)
        3'b000: begin
            c = result_add;
        end
        3'b001: begin
            c = result_sub;
        end
        3'b010: begin
            c = result_and;
        end
        3'b011: begin
            c = result_or;
        end
        3'b100: begin
            c = result_xor;
        end
        3'b101: begin
            c = result_compare;
        end
        3'b110: begin
            c = b;
        end
        3'b111: begin
            c = a;
        end
        default: begin 
            c = 4'b0000;
        end
    endcase    
end


endmodule