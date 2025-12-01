module dir_val (
    output vma,
    input [4:0] cs
);

// Lógica equivalente pero más legible
wire term1 = ~cs[3] & cs[2] & cs[1] & ~cs[0];
wire term2 = cs[3] & ~cs[2] & ~cs[1] & ~cs[0];

assign vma = term1 | term2;

endmodule