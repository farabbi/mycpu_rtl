module adel
(
    input  wire [4:0] load_type,
    input  wire [1:0] offset,
    output wire       adel
);

assign adel = (offset[0]!=0) & (load_type[2] | load_type[3])
            | (offset!=2'b0) & load_type[4];

endmodule

module ades
(
    input  wire [2:0] store_type,
    input  wire [1:0] offset,
    output wire       ades
);

assign ades = (offset[0]!=0) & store_type[1]
            | (offset!=2'b0) & store_type[2];

endmodule
