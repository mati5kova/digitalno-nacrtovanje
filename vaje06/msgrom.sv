///////////////////////////////////////////////////////////////////////
// msgrom
//
// Purpose: Read-only message memory. Returns the ASCII code of the
//          character at position Addr of "Hello World!\r\n". The
//          carriage return and line feed move the terminal cursor to
//          the start of the next line.
// Author:  <your name>
// Date:    <date>
///////////////////////////////////////////////////////////////////////

module msgrom (input  logic [3:0] Addr,
               output logic [7:0] Char);

  always_comb
    case (Addr)
      4'd0:    Char = 8'h48;  // H
      4'd1:    Char = 8'h65;  // e
      // TODO: addresses 2 to 11, the rest of "llo World!"
      4'd2:    Char = 8'h6c;  // l
      4'd3:    Char = 8'h6c;  // l
      4'd4:    Char = 8'h6f;  // o
      4'd5:    Char = 8'h20;  // space
      4'd6:    Char = 8'h57;  // W
      4'd7:    Char = 8'h6f;  // o
      4'd8:    Char = 8'h72;  // r
      4'd9:    Char = 8'h6c;  // l
      4'd10:   Char = 8'h64;  // d
      4'd11:   Char = 8'h21;  // !
      4'd12:   Char = 8'h0D;  // carriage return
      4'd13:   Char = 8'h0A;  // line feed
      default: Char = 8'h00;
    endcase

endmodule
