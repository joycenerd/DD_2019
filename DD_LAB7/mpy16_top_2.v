`include "multiplier16_1.v"

module mpy_top (
	input [15:0] a,		// input a
	input [15:0] b,		// input b
	output [15:0] out	// multiplication result
);

	wire a_sign;				// sign of a
	wire [4:0] a_exp;		// exponent of a
	wire [10:0] a_mantissa;		// mantissa of a

	wire b_sign;				
	wire [4:0] b_exp;		
	wire [10:0] b_mantissa;		

	reg        out_sign;			// sign of output
	reg [4:0]  out_exp;		// exponent output
	reg [10:0] out_mantissa;		// mantissa output

	reg [15:0] multiplier_a;	// multiplier input a
	reg [15:0] multiplier_b;	// multiplier input b
	wire [15:0] multiplier_out;	// multiplier output out

	assign  out[15] = out_sign;					// MSB for sign
	assign  out[14:10] = out_exp;				// 8 bits for exponent
	assign  out[9:0] = out_mantissa[9:0];		// 23 bits for mantissa

	assign a_sign = a[15];						// MSB for sign
	assign a_exp[4:0] = a[14:10];			// 8 bits for exponent
	assign a_mantissa[10:0] = {1'b1, a[9:0]};	// 23 bits for mantissa

	assign b_sign = b[15];						// MSB for sign
	assign b_exp[4:0] = b[14:10];			// 8 bits for exponent
	assign b_mantissa[10:0] = {1'b1, b[9:0]};	// 23 bits for mantissa

	// Multiplication
	multiplier16 mpy(multiplier_a,multiplier_b,multiplier_out);




	always @ (*) begin
		// if input_a is NaN or input_b is NaN return NaN
		// exponent=255 and fraction!=0 
        if ( ((a_exp == 31) && (a_mantissa[9:0] != 0)) ||
			 ((b_exp == 31) && (b_mantissa[9:0] != 0) )) begin
			out_sign <= 1;
			out_exp <= 31;
			
			out_mantissa[9] <= 1;
			out_mantissa[8:0] <= 0;

        // if input_a is Inf return Inf
		// Inf= exponent=255 and fraction=0

		// Inf*b=Inf
        end else if (a_exp == 31) begin
			out_sign <= a_sign ^ b_sign;
			out_exp <= 31;
			out_mantissa <= 0;

			//if input_b is zero return NaN
			//Inf*0=NaN
			if ((b_exp == 0) && (b_mantissa[9:0] == 0)) begin
				out_sign <= 1;
				out_exp <= 31;
				out_mantissa[9] <= 1;
				out_mantissa[8:0] <= 0;
			end

        // if input_b is Inf return Inf
        end else if (b_exp == 31) begin
			out_sign <= a_sign ^ b_sign;
			out_exp <= 31;
			out_mantissa <= 0;

			//if input_a is zero return NaN
			if ((a_exp == 0) && (a_mantissa[9:0] == 0)) begin
				out_sign <= 1;
				out_exp <= 31;
				out_mantissa[9] <= 1;
				out_mantissa[8:0] <= 0;
			end

        // if input_a is zero return zero
        end else if ((a_exp == 0) && (a_mantissa[9:0] == 0)) begin
			out_sign <= a_sign ^ b_sign;
			out_exp <= 0;
			out_mantissa <= 0;

        // if input_b is zero return zero
        end else if ((b_exp == 0) && (b_mantissa[9:0] == 0)) begin
			out_sign <= a_sign ^ b_sign;
			out_exp <= 0;
			out_mantissa <= 0;
		
		//	Multiplication Operation
        end else begin
			multiplier_a <= a;
			multiplier_b <= b;
			
			out_sign = multiplier_out[15];
			out_exp = multiplier_out[14:10];
			out_mantissa = multiplier_out[9:0];

        end
	end


endmodule