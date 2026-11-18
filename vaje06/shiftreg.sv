///////////////////////////////////////////////////////////////////////
// shiftreg
//
// Purpose: Parallel-in, serial-out shift register. Load captures D,
//          Shift moves the contents one place towards bit 0. The bit
//          on SerialOut is always Q[0], so the LSB goes out first, as
//          the UART frame requires. Built structurally from the
//          generic mux2 and flopenr cells.
// Author:  <your name>
// Date:    <date>
///////////////////////////////////////////////////////////////////////

module shiftreg #(parameter WIDTH = 8) (
  input  logic             clk, reset,
  input  logic             Load, Shift,
  input  logic [WIDTH-1:0] D,
  output logic             SerialOut);

  logic [WIDTH-1:0] Q, ShiftedQ, NextQ;
  logic             En;

  assign ShiftedQ = {1'b0, Q[WIDTH-1:1]};
  assign En = Load | Shift;

  mux2 #(.WIDTH(WIDTH)) loadmux (
    .D0(ShiftedQ),
    .D1(D),
    .S(Load),
    .Y(NextQ)
  );

  flopenr #(.WIDTH(WIDTH)) datareg (
    .clk(clk),
    .reset(reset),
    .en(En),
    .D(NextQ),
    .Q(Q)
  );

  assign SerialOut = Q[0];

endmodule
