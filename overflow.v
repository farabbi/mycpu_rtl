module overflow
(
    input  wire a31,
    input  wire b31,
    input  wire s31,
    output wire overflow,
    input  wire overflow_op,
    input  wire do_sub
);

assign overflow = overflow_op ? (a31==0 && b31==0 && s31==1 && do_sub==0) | (a31==1 && b31==1 && s31==0 && do_sub==0) | (a31==0 && b31==1 && s31==1 && do_sub==1) | (a31==1 && b31==0 && s31==0 && do_sub==1) : 1'b0;

endmodule
