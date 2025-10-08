module scm_0_0416 (
    X,
    Y
);

  // Port mode declarations:
  input  signed  [31:0] X;
  output signed  [31:0] Y;

  //Multipliers:

  wire signed [55:0]
    w1,
    w1024,
    w1025,
    w16384,
    w15359,
    w65600,
    w50241,
    w61436,
    w11195,
    w8192,
    w19387,
    w155096,
    w174483,
    w697932;

  assign w1 = X;
  assign w1024 = w1 << 10;
  assign w1025 = w1 + w1024;
  assign w16384 = w1 << 14;
  assign w15359 = w16384 - w1025;
  assign w65600 = w1025 << 6;
  assign w50241 = w65600 - w15359;
  assign w61436 = w15359 << 2;
  assign w11195 = w61436 - w50241;
  assign w8192 = w1 << 13;
  assign w19387 = w11195 + w8192;
  assign w155096 = w19387 << 3;
  assign w174483 = w19387 + w155096;
  assign w697932 = w174483 << 2;

  assign Y = w697932[55:24];

endmodule //multiplier_block
