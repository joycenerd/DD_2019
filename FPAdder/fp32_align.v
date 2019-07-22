`timescale 1ns / 1ps

/* Alignment */
module fadd_align (		
	input [31:0] a, b,	// fp a and b
	input sub,			// add or sub
	output sign,			// result sign
	output [7:0] temp_exp,	// result exponent
	output op_sub,			// fraction operation
	output [23:0] large_frac24,		// fraction of large one
	output [26:0] small_frac27);	// fraction of small one

	// 不看sign bit,判斷a or b大
	wire exchange = (b[30:0] > a[30:0]);
	wire [31:0] fp_large = exchange? b : a;
	wire [31:0] fp_small = exchange? a : b;

	// 轉成1.f格式
	wire fp_large_hidden_bit = |fp_large[30:23];
	wire fp_small_hidden_bit = |fp_small[30:23];
	wire [23:0] large_frac24 = {fp_large_hidden_bit, fp_large[22:0]};
	wire [23:0] small_frac24 = {fp_small_hidden_bit, fp_small[22:0]};

	// 儲存較大數的exponent
	assign temp_exp = fp_large[30:23];

	// 判斷結果值正負
	assign sign = exchange ? sub^b[31] : a[31];
	
	// fraction運算使用加法或減法
	assign op_sub = sub ^ fp_large[31] ^ fp_small[31];
	
	// ea-eb
	wire [7:0] exp_diff = fp_large[30:23] - fp_small[30:23];
	
	// 計算需要位移幾位, 並且位移
	wire [49:0] small_frac50 = (exp_diff >= 26) ? 
								{26'h0, small_frac24} : 
								{small_frac24, 26'h0} >> exp_diff;
	
	// 留下24bit以及保護.循環位, 計算多出來的位數, 使用reduction OR簡化成1bit
	assign small_frac27 = {small_frac50[49:24], |small_frac50[23:0]};
endmodule