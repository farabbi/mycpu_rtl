module slt
(
    input  wire a31,
    input  wire b31,
    input  wire cout,
    input  wire unsigned_op,
    output wire less
);

assign less = (unsigned_op==1 && cout==0)
            | (unsigned_op==0 && a31==1 && b31==0)
            | (unsigned_op==0 && a31==0 && b31==0 && cout==0)
            | (unsigned_op==0 && a31==1 && b31==1 && cout==0);

endmodule
