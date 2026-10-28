module top (
    input logic clk,
    input logic rst,
    input logic up_down,
    output logic [3:0] gray_code
);
    logic reset = !rst;
    logic [3:0] binary_count;
    bin2gray #(.WIDTH(4)) convert_bin2gray (
        .bin(binary_count),
        .gray(gray_code)
    );

    logic one_hz_pulse;
    divider100MHzTo1Hz #(.WIDTH(27)) divider (
        .clk(clk),
        .reset(reset),
        .out(one_hz_pulse)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            binary_count <= '0;
        end
        else if (one_hz_pulse) begin
            if (up_down)
                binary_count <= binary_count - 1'b1;
            else 
                binary_count <= binary_count + 1'b1;
        end
    end
endmodule

module divider100MHzTo1Hz #(parameter WIDTH = 27) (
    input logic clk,
    input logic reset,
    output logic out
);
    logic [WIDTH-1:0] counter;

    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= '0;
            out <= 1'b0;
        end
        else if (counter == 100_000_000 - 1'b1) begin
            counter <= 0;
            out <= 1'b1;
        end
        else begin
            counter <= counter + 1'b1;
            out <= 1'b0;
        end
    end
endmodule

module bin2gray #(parameter WIDTH = 4) (
    input logic [WIDTH-1:0] bin,
    output logic [WIDTH-1:0] gray
);
    always_comb begin
        case (bin)
        4'd0:    gray = 4'd0;
        4'd1:    gray = 4'd1;
        4'd2:    gray = 4'd3;
        4'd3:    gray = 4'd2;
        4'd4:    gray = 4'd6;
        4'd5:    gray = 4'd7;
        4'd6:    gray = 4'd5;
        4'd7:    gray = 4'd4;
        4'd8:    gray = 4'd12;
        4'd9:    gray = 4'd13;
        4'd10:   gray = 4'd15;
        4'd11:   gray = 4'd14;
        4'd12:   gray = 4'd10;
        4'd13:   gray = 4'd11;
        4'd14:   gray = 4'd9;
        4'd15:   gray = 4'd8;
        default: gray = 4'd0;
        endcase
    end
endmodule