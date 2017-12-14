module hi_reg
(
    input  wire        clock,
    input  wire        reset,
    input  wire [31:0] value,
    input  wire        we,
    output reg  [31:0] value_out
);

always @(posedge clock)
begin
    if (reset)
    begin
        value_out <= 32'b0;
    end
    else if (we)
    begin
        value_out <= value;
    end
end

endmodule
