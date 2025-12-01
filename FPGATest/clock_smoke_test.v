// Top-level ports must match your pin assignments (e.g., CLOCK_50 and LED[0])
module clock_smoke_test (
    input  wire clk,      // connect to the board's 50 MHz clock pin
    input  wire rst_n,    // active-low reset (tie to a button or 1'b1)
    output reg  led       // connect to an LED pin
);
    // 50 MHz -> 1 Hz: toggle every 25,000,000 cycles
    localparam integer HALF_PERIOD = 25_000_000; // adjust if your clock differs

    reg [25:0] ctr = 26'd0; // wide enough for 25e6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctr <= 26'd0;
            led <= 1'b0;
        end else begin
            if (ctr == HALF_PERIOD-1) begin
                ctr <= 26'd0;
                led <= ~led;
            end else begin
                ctr <= ctr + 1'b1;
            end
        end
    end
endmodule