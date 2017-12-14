module fetch_adel
(
    input  wire [1:0] pc_offset,
    output wire       fetch_adel
);

assign fetch_adel = pc_offset!=2'b00;

endmodule
