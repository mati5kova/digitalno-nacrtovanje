///////////////////////////////////////////////////////////////////////
// baudgen
//
// Purpose: Baud rate generator. Counts clock cycles from 0 to LIMIT-1
//          and raises Tick for one cycle at LIMIT-1, so Tick fires
//          once per bit period. Clear holds the counter at 0, which
//          lets the transmitter start every frame with a full bit.
// Author:  <your name>
// Date:    <date>
///////////////////////////////////////////////////////////////////////

module baudgen #(parameter LIMIT = 868) (
  input  logic clk, reset,
  input  logic Clear,
  output logic Tick);

  // counter width and the last count value, derived from LIMIT
  localparam WIDTH = $clog2(LIMIT);
  localparam logic [WIDTH-1:0] LAST_COUNT = WIDTH'(LIMIT - 1);

  logic [WIDTH-1:0] Count;

  // TODO: counter register (always_ff, synchronous reset)
  //   - reset, Clear or Tick: Count goes back to 0
  //   - otherwise:            Count increments by 1
  always_ff @(posedge clk) begin 
    if (reset | Clear | Tick) begin
        Count <= '0;
    end
    else begin
        Count <= Count + 1'b1;
    end
  end

  // TODO: Tick is high while Count equals LAST_COUNT
  assign Tick = Count == LAST_COUNT;

endmodule
