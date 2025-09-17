module freq_div (
    input wire clk,
    input wire rst,
    output reg clk_1hz
);
    // 26 bits are enough to count to 50 million (2^26 = 67,108,864)
    reg [25:0] counter;		  
	parameter MAX_COUNT = 49_999_999;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_1hz <= 0;
        end else begin
            if (counter == MAX_COUNT) begin
                counter <= 0;
                clk_1hz <= ~clk_1hz; // Toggle output every 50M cycles ? 1�Hz
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

module contador_ascendente (
    input clk,
    input rst,
    input en,
    output reg [3:0] count
);

always @ (posedge clk or posedge rst) begin
    if (rst)
        count <= 4'b0000;
    else if (en)
        count <= count + 1'b1;
end

endmodule

module contador_con_div(
	input wire clk,
	input wire rst,
	input wire en,
	output wire [3:0] count
	);
	
	wire clk_1hz;
	
	freq_div div1( 
	.clk(clk),
	.rst(rst),
	.clk_1hz(clk_1hz)
	);	   
	
	contador_ascendente contador1(	 
	.clk(clk_1hz),
	.rst(rst),
	.en(en),
	.count(count)
	); 
	
endmodule  

module binary_to_hex_cathode_comun (
    input wire A, B, C, D,
    output wire a, b, c, d, e, f, g
);

// Segmento a
assign a = (~A & ~B) | (~A & D) | (~A & C) | (B & C) | (A & ~D) | (A & ~B & ~C);

// Segmento b
assign b = (~A & ~C & ~D) | (~A & ~B) | (~A & C & D) | (~B & ~D) | (A & ~C & D);

// Segmento c
assign c = ~A & ((~C & ~D) | (C & D)) | ((A & ~B) | (~A & B));

// Segmento d
assign d = (~A & ~B & ~D) | (~A & ~B & C) | (B & ~C & D);

// Segmento e
assign e = (~B & ~D) | (A & B) | (C & ~D) | (A & C);

// Segmento f
assign f = (~C & ~D) | (~A & B & ~C) | (A & ~B) | (B & C & ~D) | (A & C);

// Segmento g
assign g = (~A & B & ~C) | (~A & ~B & C) | (A & ~B) | (C & ~D) | (A & D);

endmodule
