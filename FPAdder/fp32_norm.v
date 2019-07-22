`timescale 1ns / 1ps

/* Normalization */
module fadd_norm (
	input sign,			// result sign
	input [7:0] temp_exp,	// temp exponent
	input [27:0] cal_frac,	// fraction before normalization
	output [31:0] s);		// result
	
	wire [26:0] f4, f3, f2, f1, f0;
	
	// 從左邊找到第一個1
	wire [4:0] zeros;	// 左邊數起有幾個0
	assign zeros[4] = ~|cal_frac[26:11];	// 16-bit 0
	assign f4 = zeros[4]? {cal_frac[10:0],16'b0} : cal_frac[26:0];
	assign zeros[3] = ~|f4[26:19];			// 8-bit 0
	assign f3 = zeros[3]? {f4[18:0], 8'b0} : f4;
	assign zeros[2] = ~|f3[26:23];			// 4-bit 0
	assign f2 = zeros[2]? {f3[22:0], 4'b0} : f3;
	assign zeros[1] = ~|f2[26:25];			// 2-bit 0
	assign f1 = zeros[1]? {f2[24:0], 2'b0} : f2;
	assign zeros[0] = ~f1[26];				// 1-bit 0
	assign f0 = zeros[0]? {f1[25:0], 1'b0} : f1;
	reg [26:0] frac0;
	reg [7:0] exp0;
	
	// 位移以及修改exponent
	always @ * begin
		if (cal_frac==0) begin	// Result is 0
			frac0 = 0;
			exp0 = 0;
		end
		else if (cal_frac[27]) begin
			frac0 = cal_frac[27:1];	// 1x.xxxxxxxxxxxxxxxxxxxxxxx xx
			exp0 = temp_exp + 8'h1; // ->1.xxxxxxxxxxxxxxxxxxxxxxx xxx
		end
		else begin
			exp0 = temp_exp - zeros;
			frac0 = f0; // 01.xxxxxxxxxxxxxxxxxxxxxxx xxx
			
		end
	end
	
	// Rounding
	wire frac_plus_1 =
	frac0[2] & (frac0[1] | frac0[0]) |
	frac0[2] & ~frac0[1] & ~frac0[0] & frac0[3];

	wire [24:0] frac_round = {1'b0, frac0[26:3]} + frac_plus_1;
	wire [7:0] exponent = frac_round[24] ?
							exp0 + 8'h1 :
							exp0;
	
	assign s = {sign, exponent, frac_round[22:0]};
endmodule