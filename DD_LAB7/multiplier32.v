/**********      Muitiplication Top Module     **********/
/*	Input: input_a, input_b		Output: mpy_output		*/
/*	Function: 32-bit Floating-point Multiplier			*/
/*			  mpy_output = input_a * input_b			*/
/********************************************************/
module multiplier32(
	input  [31:0] mpy_input_a, mpy_input_b,
	output [31:0] mpy_output
);
	reg a_sign;				// sign of a
	reg [7:0] a_exponent;	// exponent of a
	reg [23:0] a_mantissa;	// mantissa of a

	reg b_sign;				// sign of b
	reg [7:0] b_exponent;	// exponent of b
	reg [23:0] b_mantissa;	// mantissa of b

	reg o_sign;				// sign of output
	reg [7:0] o_exponent;	// exponent output
	reg [22:0] o_mantissa;	// mantissa output

	reg [47:0] product;		// product of mantissa

	assign mpy_output[31] = o_sign;
	assign mpy_output[30:23] = o_exponent;
	assign mpy_output[22:0] = o_mantissa[22:0];

	always @ (*) begin
		a_sign = mpy_input_a[31];
		a_exponent = mpy_input_a[30:23];
		a_mantissa = {1'b1, mpy_input_a[22:0]};

		b_sign = mpy_input_b[31];
		b_exponent = mpy_input_b[30:23];
		b_mantissa = {1'b1, mpy_input_b[22:0]};
	
		o_sign = a_sign ^ b_sign;
		o_exponent = a_exponent + b_exponent - 127;
		product = a_mantissa * b_mantissa;
			
		// Normalization
		if(product[47] == 1) begin
			o_exponent = o_exponent + 1;
			product = product >> 1;
		end
		
		// Rounding
		o_mantissa = product[46:23];
		if(product[22]) begin
			o_mantissa = o_mantissa + 1;
		end
		

	end
endmodule