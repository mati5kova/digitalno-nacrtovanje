///////////////////////////////////////////////////////////////////////
// uarttxctrl
//
// Purpose: Control FSM of the UART transmitter (8N1, no parity).
//          IDLE waits for Start and loads the shift register. START,
//          DATA and STOP each last one bit period, measured by Tick
//          from baudgen. DATA repeats for DATA_BITS bits, shifting
//          the register after every bit except the last.
//          Tx is registered, so the serial line never glitches. It
//          resets to 1, the idle level of a UART line.
// Author:  <your name>
// Date:    <date>
///////////////////////////////////////////////////////////////////////

module uarttxctrl #(parameter DATA_BITS = 8) (
  input  logic clk, reset,
  input  logic Start, Tick, SerialBit,
  output logic Load, Shift, BaudClear,
  output logic Busy, Done,
  output logic Tx);

  localparam CNT_WIDTH = $clog2(DATA_BITS);
  localparam logic [CNT_WIDTH-1:0] LAST_BIT = CNT_WIDTH'(DATA_BITS - 1);

  typedef enum logic [1:0] {IDLE, START, DATA, STOP} statetype;

  statetype             State, NextState;
  logic [CNT_WIDTH-1:0] BitCount;
  logic                 LastBit, TxNext;

  // state register
  always_ff @(posedge clk)
    if (reset) State <= IDLE;
    else       State <= NextState;

  // TODO: bit counter (always_ff)
  //   - cleared on reset and while the FSM is in START
  //   - incremented on every Tick while the FSM is in DATA
  always_ff @(posedge clk) begin : bitCounterBlock
    if (reset || (State == START)) begin
        BitCount <= '0;
    end
    else if ((State == DATA) && Tick) begin
        BitCount <= BitCount + 1'b1;
    end
  end

  // TODO: LastBit is high while BitCount equals LAST_BIT
  assign LastBit = (BitCount == LAST_BIT);

  // TODO: next state logic (always_comb, case on State)
  //   start with NextState = State, then for each state:
  //   IDLE  -> START when Start
  //   START -> DATA  on Tick
  //   DATA  -> STOP  on Tick of the last bit
  //   STOP  -> IDLE  on Tick
  //   add a default branch
  always_comb begin : nextStateBlock
    NextState = State;
    case (State)
        IDLE: if (Start || Load) NextState = START;
        START: if (Tick) NextState = DATA;
        DATA: if (Tick && LastBit) NextState = STOP;
        STOP: if(Tick || Done) NextState = IDLE;
        default: NextState = State;
    endcase
  end

  // TODO: serial line level for each state (always_comb, case on State)
  //   START: 0,  DATA: SerialBit,  IDLE and STOP: 1
  always_comb begin : serialLineLevelBlock
    TxNext = Tx;
    case (State)
        IDLE: TxNext = 1'b1;
        START: TxNext = 1'b0;
        DATA: TxNext = SerialBit;
        STOP: TxNext = 1'b1;
        default: TxNext = Tx;
    endcase
  end

  // TODO: output register: Tx <= TxNext, reset value 1 (the idle level)
  always_ff @(posedge clk) begin : outputRegisterBlock
    if (reset) begin
      Tx <= 1'b1;
    end
    else begin
      Tx <= TxNext;
    end
  end

  // TODO: outputs (assign)
  //   Load      high in IDLE when Start arrives
  //   Shift     high on Tick in DATA, except for the last bit
  //   BaudClear high in IDLE
  //   Busy      high in every state except IDLE
  //   Done      high on Tick in STOP
  assign Load = (State == IDLE) && Start;
  assign Shift = (State == DATA) && Tick && ~LastBit;
  assign BaudClear = (State == IDLE);
  assign Busy = (State != IDLE);
  assign Done = (State == STOP) && Tick;

endmodule
