module vaddr2paddr
(
    input  wire [31:0] vaddr,
    output wire [31:0] paddr
);

assign paddr = {3'b0, vaddr[28:0]};

endmodule
