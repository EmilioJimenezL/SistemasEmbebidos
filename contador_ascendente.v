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
