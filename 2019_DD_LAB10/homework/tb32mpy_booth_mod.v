`timescale 1ns/1ps
`include "32mpy_booth_mod.v"

module tb_lab();
reg [31:0] in_a;
reg [31:0] in_b;
reg CLK;
reg reset;
wire [63:0] out;
wire out_valid;

reg [5:0]	count;
reg signed [64:0]	correct_ans;
reg error;
reg signed [63:0]	 temp_a;
reg signed [63:0]	temp_b;

lab m1(CLK, reset, in_a, in_b, out, out_valid);

initial begin
	$dumpfile("lab10.vcd");  //gtkwave
	$dumpvars;
	CLK = 1'b0;
	
	#10 reset = 1;//正數*正數
	temp_a = 32'd30;
	temp_b = 32'd90;
	#20 reset = 0;
	
	#680 reset = 1;//正數*負數
	temp_a = 32'd30;
	temp_b = -32'd90;
	#20 reset = 0;
	
	#680 reset = 1;//負數*正數
	temp_a = -32'd30;
	temp_b = 32'd90;
	#20 reset = 0;
	
	#680 reset = 1;//負數*負數
	temp_a = -32'd30;
	temp_b = -32'd90;
	#20 reset = 0;

	/*#680 reset = 1;//無號最大數*無號最大數
	temp_a = 64'd4294967295;
	temp_b = 64'd4294967295;
	#20 reset = 0;
	
	#680 reset = 1;//無號溢位數*1
	temp_a = 64'd4294967296;
	temp_b = 64'd1;
	#20 reset = 0;
	
	#680 reset = 1;//無號溢位數*1
	temp_a = 64'd4294967297;
	temp_b = 64'd1;
	#20 reset = 0;*/

	#680 $finish;
end

always #10 CLK = ~CLK;

always @(posedge CLK or posedge reset)
begin
	if(reset)//初始化
	begin
		count <= 0;
		in_a <= temp_a;
		in_b <= temp_b;
		correct_ans <= 0;
		error <= 0;
	end

	else//對答案
	begin
		correct_ans <= temp_a *temp_b;
		count <= count +1;

		if(out_valid==1)
			if($signed(out) != correct_ans)
			begin
				error <=1;
				$display ();
				$display ("// Fail //");
				$display ("//%d * %d = ?",temp_a, temp_b);
				$display ("//your answer is %d, but correct answer is %d\n",
				$signed(out), correct_ans);
			end
			
			else
			begin
				error <= 0;
				$display ();
				$display ("// Successful //");
				$display ("//%d * %d = ?",temp_a, temp_b);
				$display ("//your answer is %d,  correct answer is %d\n",
				$signed(out), correct_ans);
			end
	end
end

endmodule
