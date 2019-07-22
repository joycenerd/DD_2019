`timescale 1ns/1ps
`include "mpy16_top.v"

module testbench;
	/* Variables Declaration */
	reg [15:0] testInput_a, testInput_b;
	wire [15:0] mpy_ans;
	reg [15:0] correct_ans;

	reg [3:0] cnt_test;
	reg [3:0] cnt_right;
	/* Variable Declaration */



	/* Multiplier */
	mpy_top mpy_top(
		.in_a(testInput_a),
		.in_b(testInput_b),
		.out(mpy_ans)
	);
	/* Multiplier */



	/*-------------------- Start Testing --------------------*/
	initial begin
		$dumpfile("test16.fsdb");  
		$dumpvars;

		#0
			cnt_test = 0;
			cnt_right = 0;
		
		#1	/********* Test Pattern *********/
			testInput_a = 16'hBB67;		// -0.9253
			testInput_b = 16'hF5CB;		// -2.373E-4
			correct_ans = 16'h755C;		// 2.195E-4
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 16'h0FCC;		// 4.76E-4
			testInput_b = 16'h8ADB;		// -2.092E-4
			correct_ans = 16'h8002;		// -1E-7
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 16'h522C;		// 49.38
			testInput_b = 16'h87E6;		// -1.205E-4
			correct_ans = 16'h9E18;		// -5.95E-3
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 16'h6DA0;		// 5760.0
			testInput_b = 16'hAB89;		// -5.887E-2
			correct_ans = 16'hDD4C;		// -339.0
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		#1	/********* Test Pattern *********/
			testInput_a = 16'h67BB;		// 1979.0
			testInput_b = 16'hB4F5;		// -0.3098
			correct_ans = 16'hE0CA;		// -613.0
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 16'h0000;		// -16.23
			testInput_b = 16'hDB8A;		// -241.3
			correct_ans = 16'h0000;		// 3916.0
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 16'h2C52;		// 0.0675
			testInput_b = 16'h0000;		// -1671.0
			correct_ans = 16'h0000;		// -112.8
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 16'hA06D;		// -8.644E-3
			testInput_b = 16'h89AB;		// -1.73E-4
			correct_ans = 16'h0019;		// 1.5E-6
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
	end
/*-------------------- End Testing --------------------*/



/*--------------- Standard Output for Success Case ---------------*/
task success_case;
input [15:0] testInput_a, testInput_b, ans;
begin
	cnt_right = cnt_right + 1;

	$display ("Test %d ", cnt_test);
	$display ("///////////////////////");
	$display ("//// Successful %d ////", cnt_right);
	$display ("///////////////////////");
	$display ("%h * %h = ?", testInput_a, testInput_b);
	$display ("Answer = %h\n", mpy_ans);
end endtask
/*--------------- Standard Output for Success Case ---------------*/



/*--------------- Standard Output for Failure Case ---------------*/
task failure_case;
input [15:0] testInput_a, testInput_b, ans, mpy_ans;
begin
	$display ("Test %d ", cnt_test);
	$display ("///////////////////////");
	$display ("///////// Fail ////////");
	$display ("///////////////////////");
	$display ("%h * %h = ?", testInput_a, testInput_b);
	$display ("your answer = %h", mpy_ans);
	$display ("correct answer = %h\n", ans);
end endtask
/*--------------- Standard Output for Failure Case ---------------*/



endmodule