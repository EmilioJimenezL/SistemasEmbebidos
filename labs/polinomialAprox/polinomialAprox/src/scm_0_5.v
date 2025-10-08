module scm_0_5 (
    X,
    Y
);

  // Port mode declarations:
  input  signed  [31:0] X;
  output signed  [31:0] Y;

  //Multipliers:

  wire signed [55:0]
    w1,
    w8388608;

  assign w1 = X;
  assign w8388608 = w1 << 23;

  assign Y = w8388608[55:24];

endmodule //multiplier_block