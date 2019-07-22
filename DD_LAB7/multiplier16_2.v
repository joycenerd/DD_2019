module multiplier16(a,b,out);

	input  [15:0] a, b;
	output [15:0] out;

	reg a_sign;				// sign of a
	reg [4:0] a_exp;	// exponent of a
	reg [10:0] a_mantissa;	// mantissa of a

	reg b_sign;				// sign of b
	reg [4:0] b_exp;	// exponent of b
	reg [10:0] b_mantissa;	// mantissa of b

	reg out_sign;				// sign of output
	reg [4:0] out_exp;	// exponent output
	reg [10:0] out_mantissa;	// mantissa output

	reg [21:0] product;		// product of mantissa

	assign out[15] = out_sign;
	assign out[14:10] = out_exp;
	assign out[9:0] = out_mantissa[9:0];

	always @ (*) begin
		a_sign = a[15];
		a_exp = a[14:10];
		a_mantissa = {1'b1, a[9:0]};

		b_sign = b[15];
		b_exp = b[14:10];
		b_mantissa = {1'b1, b[9:0]};
	
		out_sign = a_sign ^ b_sign;
		out_exp = a_exp + b_exp - 15;
		product = a_mantissa * b_mantissa;
			
		// Normalization
		if(product[21] == 1) begin
			out_exp = out_exp + 1;
			product = product >> 1;
		end
		
		// Rounding
		out_mantissa = product[20:10];
		if(product[9]) begin
			out_mantissa = out_mantissa + 1;
		end
		

	end
endmodule