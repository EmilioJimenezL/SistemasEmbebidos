// alu4.v — 4-bit ALU (synchronous) with flags
module alu4 (
    input  wire        clk,
    input  wire [3:0]  a,
    input  wire [3:0]  b,
    input  wire [4:0]  cs,          // control select
    output reg  [3:0]  operacion,   // ALU result
    output reg  [3:0]  rc            // flags: [3]=overflow, [2]=zero, [1]=sign, [0]=carry
);

    // internal
    reg        carry;               // carry/aux flag for ops
    wire [4:0] sum5  = {1'b0, a} + {1'b0, b};  // 5-bit for carry on add
    wire [4:0] diff5 = {1'b0, a} + {1'b0, (~b + 4'b0001)}; // a + (~b + 1) => subtraction (a - b)

    // signed-add overflow for 4-bit two's complement
    // overflow = carry into MSB xor carry out of MSB
    // equivalently: (a[3]&b[3]&~operacion[3]) | (~a[3]&~b[3]&operacion[3])
    function automatic overflow_add_4;
        input [3:0] a4, b4, r4;
        begin
            overflow_add_4 = (a4[3] & b4[3] & ~r4[3]) | (~a4[3] & ~b4[3] & r4[3]);
        end
    endfunction

    // signed-sub overflow for 4-bit two's complement
    // overflow = (a[3] & ~b[3] & ~r[3]) | (~a[3] & b[3] & r[3])
    function automatic overflow_sub_4;
        input [3:0] a4, b4, r4;
        begin
            overflow_sub_4 = (a4[3] & ~b4[3] & ~r4[3]) | (~a4[3] & b4[3] & r4[3]);
        end
    endfunction

    always @(posedge clk) begin
        // defaults
        operacion <= 4'b0000;
        carry     <= 1'b0;

        case (cs)
            5'b00001: begin
                // ADD: operacion = a + b
                operacion <= sum5[3:0];
                carry     <= sum5[4];
                rc[3]     <= overflow_add_4(a, b, sum5[3:0]); // overflow
            end

            5'b00010: begin
                // AND
                operacion <= a & b;
                carry     <= (a != b);  // per provided VHDL
                rc[3]     <= 1'b0;
            end

            5'b00011: begin
                // OR
                operacion <= a | b;
                carry     <= (a != b);
                rc[3]     <= 1'b0;
            end

            5'b00100: begin
                // XOR
                operacion <= a ^ b;
                carry     <= (a != b);
                rc[3]     <= 1'b0;
            end

            5'b00101: begin
                // NOT A
                operacion <= ~a;
                carry     <= 1'b0;
                rc[3]     <= 1'b0;
            end

            5'b00110: begin
                // SHIFT LEFT LOGICAL by 1
                operacion <= {a[2:0], 1'b0};
                carry     <= a[3];      // MSB shifted out (VHDL had a(4); for 4-bit it should be a(3))
                rc[3]     <= 1'b0;
            end

            5'b00111: begin
                // A AND 1111 => pass-through A
                operacion <= a & 4'b1111;
                carry     <= carry;     // no change (matches "Cout := Cout")
                rc[3]     <= rc[3];     // keep overflow as-is (matches cl(0) <= cl(0) intent)
            end

            default: begin
                // NOP
                operacion <= operacion; // hold
                carry     <= carry;
                rc[3]     <= rc[3];
            end
        endcase

        // common flags (updated every cycle after operation selection)
        rc[2] <= ~(operacion[3] | operacion[2] | operacion[1] | operacion[0]); // zero
        rc[1] <= operacion[3];                                                 // sign (MSB)
        rc[0] <= carry;                                                        // carry/aux
    end

endmodule
