module div(
  input div_clk,
  input resetn,
  input div,
  input div_signed,
  input [31:0] x,
  input [31:0] y,
  output [31:0] s,
  output [31:0] r,
  output complete,
  input pipe3_valid
);
wire [63:0] x_abs;
wire [31:0] y_abs;
wire quotient_sign;
wire remainder_sign;
wire [63:0] new_dividend;
wire [31:0] new_quotient;
wire [31:0] new_remainder;

reg [5:0] count;
always @(posedge div_clk)
begin
  if (~resetn | ~pipe3_valid) begin
    count <= 0;
  end
  else if (div & pipe3_valid) begin
    if (count == 33) begin
      count <= 0;
    end
	else begin
	  count <= count + 6'd1;
	end
  end
end

reg [63:0] dividend;
reg [31:0] divisor;
reg [31:0] quotient;
reg [31:0] remainder;
always @(posedge div_clk)
begin
  if (~resetn) begin
    dividend <= 0;
  end
  else if (count == 0) begin
	dividend <= x_abs;
  end
  else begin
	dividend <= new_dividend;
  end
end
always @(posedge div_clk)
begin
  if (~resetn) begin
	divisor <= 0;
  end
  else if (count == 0) begin
	divisor <= y_abs;
  end
end
always @(posedge div_clk)
begin
  if (~resetn) begin
	quotient <= 0;
  end
  else begin
	quotient <= new_quotient;
  end
end
always @(posedge div_clk)
begin
  if (~resetn) begin
	remainder <= 0;
  end
  else begin
	remainder <= new_remainder;
  end
end

reg quotient_sign_reg;
reg remainder_sign_reg;
always @(posedge div_clk)
begin
  if (~resetn) begin
	quotient_sign_reg <= 0;
  end
  else if (count == 0) begin
	quotient_sign_reg <= quotient_sign;
  end
end
always @(posedge div_clk)
begin
  if (~resetn) begin
	remainder_sign_reg <= 0;
  end
  else if (count == 0) begin
	remainder_sign_reg <= remainder_sign;
  end
end

step_1 step_1(
  .x				(x),
  .y				(y),
  .div_signed		(div_signed),
  .x_abs			(x_abs),
  .y_abs			(y_abs),
  .quotient_sign	(quotient_sign),
  .remainder_sign	(remainder_sign)
);
step_2 step_2(
  .dividend			(dividend),
  .divisor			(divisor),
  .quotient			(quotient),
  .new_dividend		(new_dividend),
  .new_quotient		(new_quotient),
  .new_remainder	(new_remainder)
);
step_3 step_3(
  .quotient			(quotient),
  .remainder		(remainder),
  .quotient_sign	(quotient_sign_reg),
  .remainder_sign	(remainder_sign_reg),
  .quotient_result	(s),
  .remainder_result	(r)
);

assign complete = count == 33;
  
endmodule

module step_1(
  input [31:0] x,
  input [31:0] y,
  input div_signed,
  output [63:0] x_abs,
  output [31:0] y_abs,
  output quotient_sign,
  output remainder_sign
);
wire [31:0] x_abs_32bits;

assign quotient_sign = (x[31] ^ y[31]) & div_signed;
assign remainder_sign = x[31] & div_signed;

wire x_sign = x[31] & div_signed;
wire y_sign = y[31] & div_signed;
assign x_abs_32bits = ({32{x_sign}} ^ x) + x_sign;
assign x_abs = {32'b0, x_abs_32bits};
assign y_abs = ({32{y_sign}} ^ y) + y_sign;

endmodule

module step_2(
  input [63:0] dividend,
  input [31:0] divisor,
  input [31:0] quotient,
  output [63:0] new_dividend,
  output [31:0] new_quotient,
  output [31:0] new_remainder
);
wire [32:0] sub_a;
wire [32:0] sub_b;
wire [32:0] sub_b_inverse;
wire [32:0] sub_result;
assign sub_a = dividend[63:31];
assign sub_b = {1'b0, divisor};
assign sub_b_inverse = ~sub_b;
assign sub_result = sub_a + sub_b_inverse + 1;

wire sub_result_sign;
assign sub_result_sign = sub_result[32];

assign new_dividend = sub_result_sign ? {dividend[62:0], 1'b0} : {sub_result[31:0], dividend[30:0], 1'b0};
assign new_remainder = new_dividend[63:32];
assign new_quotient = {quotient[30:0], ~sub_result_sign};

endmodule

module step_3(
  input [31:0] quotient,
  input [31:0] remainder,
  input quotient_sign,
  input remainder_sign,
  output [31:0] quotient_result,
  output [31:0] remainder_result
);
assign quotient_result = ({32{quotient_sign}} ^ quotient) + quotient_sign;
assign remainder_result = ({32{remainder_sign}} ^ remainder) + remainder_sign;

endmodule
