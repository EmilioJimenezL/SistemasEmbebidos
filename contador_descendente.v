module contador_descendente (
    input clk,
    input rst,
    input en,
    output reg [3:0] count
);

always @ (posedge clk or posedge rst) begin
    if (rst)
        count <= 4'b1111;
    else if (en)
        count <= count - 1'b1;
end

endmodule
