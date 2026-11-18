///////////////////////////////////////////////////////////////////////
// hellotxctrl
//
// Purpose: Message sender FSM. A pulse on Send walks Addr through the
//          MSG_LEN characters of msgrom. For every character it pulses
//          TxStart for one cycle, then waits for TxDone from the UART
//          transmitter before moving to the next one. Send is ignored
//          while a message is being sent.
// Author:  <your name>
// Date:    <date>
///////////////////////////////////////////////////////////////////////

module hellotxctrl #(parameter MSG_LEN = 14) (
  input  logic       clk, reset,
  input  logic       Send, TxDone,
  output logic [3:0] Addr,
  output logic       TxStart, Busy);

  localparam logic [3:0] LAST_ADDR = 4'(MSG_LEN - 1);

  typedef enum logic [1:0] {IDLE, START, WAIT} statetype;

  statetype State, NextState;
  logic     LastChar;

  // state register
  always_ff @(posedge clk)
    if (reset) State <= IDLE;
    else       State <= NextState;

  // TODO: character address register Addr (always_ff)
  //   - cleared on reset and when Send arrives in IDLE
  //   - incremented when TxDone arrives in WAIT
  always_ff @(posedge clk) begin : charAddRegBlock
    if (reset || (State == IDLE && Send)) begin
        Addr <= '0;
    end else if (State == WAIT && TxDone) begin
        Addr <= Addr + 1'b1;
    end
  end

  // TODO: LastChar is high while Addr equals LAST_ADDR
  assign LastChar = (Addr == LAST_ADDR);

  // TODO: next state logic (always_comb, case on State)
  //   IDLE  -> START when Send
  //   START -> WAIT  always (START lasts exactly one cycle)
  //   WAIT  -> IDLE  when TxDone and this was the last character
  //   WAIT  -> START when TxDone otherwise
  //   add a default branch
  always_comb begin : nextStateLogicBlock
    NextState = State;
    case (State)
        IDLE: if (Send) NextState = START;
        START: NextState = WAIT;
        WAIT: if (TxDone) begin
            if (LastChar) NextState = IDLE;
            else NextState = START;
        end
        default: NextState = State;
    endcase
  end

  // TODO: outputs (assign)
  //   TxStart high in START
  //   Busy    high in every state except IDLE
  assign TxStart = (State == START);
  assign Busy = (State != IDLE);

endmodule
