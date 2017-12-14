module branch
(
    input  wire [ 7:0] type,
    input  wire [31:0] opa,
    input  wire [31:0] opb,
    output wire        br_taken,
    output wire        j_taken,
    output wire        jr_taken
);

assign jr_taken = type[7];
assign j_taken = type[6];
assign br_taken = type[5] & opa[31]
                | type[4] & (opa[31] | ~(|opa))
                | type[3] & (~opa[31] & (|opa))
                | type[2] & ~opa[31]
                | type[1] & (opa!=opb)
                | type[0] & (opa==opb);

endmodule
