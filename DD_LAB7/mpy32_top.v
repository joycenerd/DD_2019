`include "multiplier32.v"

/**********      Muitiplication Top Module     **********/
/*	Input: input_a, input_b		Output: mpy_output		*/
/*	Function: Special Case Detector						*/
/*			  mpy_output = input_a * input_b			*/
/********************************************************/
module mpy_top (
	input [31:0] input_a,		// input a
	input [31:0] input_b,		// input b
	output [31:0] mpy_output	// multiplication result
);

	wire a_sign;				// sign of a
	wire [7:0] a_exponent;		// exponent of a
	wire [23:0] a_mantissa;		// mantissa of a

	wire b_sign;				// sign of b
	wire [7:0] b_exponent;		// exponent of b
	wire [23:0] b_mantissa;		// mantissa of b

	reg        o_sign;			// sign of output
	reg [7:0]  o_exponent;		// exponent output
	reg [23:0] o_mantissa;		// mantissa output

	reg [31:0] multiplier_a_in;	// multiplier input a
	reg [31:0] multiplier_b_in;	// multiplier input b
	wire [31:0] multiplier_out;	// multiplier output out

	assign  mpy_output[31] = o_sign;					// MSB for sign
	assign  mpy_output[30:23] = o_exponent;				// 8 bits for exponent
	assign  mpy_output[22:0] = o_mantissa[22:0];		// 23 bits for mantissa

	assign a_sign = input_a[31];						// MSB for sign
	assign a_exponent[7:0] = input_a[30:23];			// 8 bits for exponent
	assign a_mantissa[23:0] = {1'b1, input_a[22:0]};	// 23 bits for mantissa

	assign b_sign = input_b[31];						// MSB for sign
	assign b_exponent[7:0] = input_b[30:23];			// 8 bits for exponent
	assign b_mantissa[23:0] = {1'b1, input_b[22:0]};	// 23 bits for mantissa

	// Multiplication
	multiplier32 mpy
	(
		.mpy_input_a(multiplier_a_in),
		.mpy_input_b(multiplier_b_in),
		.mpy_output(multiplier_out)
	);




	always @ (*) begin
		// if input_a is NaN or input_b is NaN return NaN 
        if ( ((a_exponent == 255) && (a_mantissa[22:0] != 0)) ||
			 ((b_exponent == 255) && (b_mantissa[22:0] != 0) )) begin
			o_sign <= 1;
			o_exponent <= 255;
			
			o_mantissa[22] <= 1;
			o_mantissa[21:0] <= 0;

        // if input_a is Inf return Inf
        end else if (a_exponent == 255) begin
			o_sign <= a_sign ^ b_sign;
			o_exponent <= 255;
			o_mantissa <= 0;

			//if input_b is zero return NaN
			if ((b_exponent == 0) && (b_mantissa[22:0] == 0)) begin
				o_sign <= 1;
				o_exponent <= 255;
				o_mantissa[22] <= 1;
				o_mantissa[21:0] <= 0;
			end

        // if input_b is Inf return Inf
        end else if (b_exponent == 255) begin
			o_sign <= a_sign ^ b_sign;
			o_exponent <= 255;
			o_mantissa <= 0;

			//if input_a is zero return NaN
			if ((a_exponent == 0) && (a_mantissa[22:0] == 0)) begin
				o_sign <= 1;
				o_exponent <= 255;
				o_mantissa[22] <= 1;
				o_mantissa[21:0] <= 0;
			end

        // if input_a is zero return zero
        end else if ((a_exponent == 0) && (a_mantissa[22:0] == 0)) begin
			o_sign <= a_sign ^ b_sign;
			o_exponent <= 0;
			o_mantissa <= 0;

        // if input_b is zero return zero
        end else if ((b_exponent == 0) && (b_mantissa[22:0] == 0)) begin
			o_sign <= a_sign ^ b_sign;
			o_exponent <= 0;
			o_mantissa <= 0;
		
		//	Multiplication Operation
        end else begin
			multiplier_a_in <= input_a;
			multiplier_b_in <= input_b;
			
			o_sign = multiplier_out[31];
			o_exponent = multiplier_out[30:23];
			o_mantissa = multiplier_out[22:0];
        end
	end


endmodule