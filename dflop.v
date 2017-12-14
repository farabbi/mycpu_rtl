module dflop
(
    input  wire clock,
    input  wire D,
    output reg Q
);

always @(posedge clock)
begin
    Q <= D;
end

endmodule
