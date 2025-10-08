module scm_0_1666 (
    X,
    Y
);

  // Port mode declarations:
  input  signed  [31:0] X;
  output signed  [31:0] Y;

  //Multipliers:

  wire signed [55:0]
    w1,
    w32768,
    w32769,
    w16,
    w32785,
    w2048,
    w30737,
    w2049,
    w8196,
    w22541,
    w721312,
    w698771,
    w2795084;

  assign w1 = X;
  assign w32768 = w1 << 15;
  assign w32769 = w1 + w32768;
  assign w16 = w1 << 4;
  assign w32785 = w32769 + w16;
  assign w2048 = w1 << 11;
  assign w30737 = w32785 - w2048;
  assign w2049 = w1 + w2048;
  assign w8196 = w2049 << 2;
  assign w22541 = w30737 - w8196;
  assign w721312 = w22541 << 5;
  assign w698771 = w721312 - w22541;
  assign w2795084 = w698771 << 2;

  assign Y = w2795084[55:24];

endmodule //multiplier_block