`include "fp16_adder.v"
`timescale 1ns / 1ps

module test_bench;

	/* Variables Declaration */
	reg[15:0] testInput_a;
	reg[15:0] testInput_b;
	reg [15:0] correct_ans;
	wire [15:0] adder_ans;
	/* Variables Declaration */

	/* 待驗證的Module */
	fpadder test(
		.a(testInput_a),
		.b(testInput_b),
		.sub(1'b0),
		.s(adder_ans));

	reg [4:0] cnt_test, cnt_right;
	initial begin
		$dumpfile("adder16.vcd");
		$dumpvars;

		#0
			cnt_test = 0;
			cnt_right = 0;
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'hfe00;		// -0.9253
			testInput_b = 32'hF5CB;		// -2.373E-4
			correct_ans = 32'hfe00;		// 2.373E4
			cnt_test = cnt_test + 1;
		#10 
			if(adder_ans[14:10]==31 && adder_ans[9:0]!=0) begin
				nan_case(testInput_a,testInput_b,correct_ans);
			end
			else if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'h0FCC;		// 4.76E-4
			testInput_b = 32'h8ADB;		// -2.092E-4
			correct_ans = 32'h0C5E;		// 2.666E-4
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'h522C;		// 49.38
			testInput_b = 32'h87E6;		// -1.205E-4
			correct_ans = 32'h522C;		// 49.38
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'h6DA0;		// 5760.0
			testInput_b = 32'hAB89;		// -5.887E-2
			correct_ans = 32'h6DA0;		// 5760.0
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'h0A6A;		// 1.957E-4
			testInput_b = 32'h92BA;		// -8.21E-4
			correct_ans = 32'h9120;		// -6.256E-4
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'hC49A;		// -4.6
			testInput_b = 32'h4429;		// 4.16
			correct_ans = 32'hB710;		// -0.4414
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'h43E2;		// 3.941
			testInput_b = 32'hC1AC;		// -2.836
			correct_ans = 32'h3C6C;		// 1.105
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'hBA9D;		// -0.8267
			testInput_b = 32'h4148;		// 2.64
			correct_ans = 32'h3F42;		// 1.814
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
		#1	/********* Test Pattern *********/
			testInput_a = 32'hBA9D;		// -0.8267
			testInput_b = 32'h3A9D;		// 0.8267
			correct_ans = 32'h0000;		// 0
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end

		#1	/********* Test Pattern *********/
			testInput_a = 32'hBA9D;		// -0.8267
			testInput_b = 32'h3A9D;		// 0.8267
			correct_ans = 32'h0000;		// 0
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end

		$finish;
	end



/*--------------- Standard Output for Success Case ---------------*/
task success_case;
input [15:0] testInput_a, testInput_b, correct_ans;
begin
	cnt_right = cnt_right + 1;

	$display ("Test %d ", cnt_test);
	$display ("///////////////////////");
	$display ("//// Successful %d ////", cnt_right);
	$display ("///////////////////////");
	$display ("%h + %h = ?", testInput_a, testInput_b);
	$display ("Answer = %h\n", correct_ans);
end endtask
/*--------------- Standard Output for Success Case ---------------*/



/*--------------- Standard Output for Failure Case ---------------*/
task failure_case;
input [15:0] testInput_a, testInput_b, correct_ans, result;
begin
	$display ("Test %d ", cnt_test);
	$display ("///////////////////////");
	$display ("///////// Fail ////////");
	$display ("///////////////////////");
	$display ("%h + %h = ?", testInput_a, testInput_b);
	$display ("your answer = %h", result);
	$display ("correct answer = %h\n", correct_ans);
end endtask
/*--------------- Standard Output for Failure Case ---------------*/


/*--------------- Standard Output for NaN Case ---------------*/
task nan_case;
input [15:0] testInput_a, testInput_b, correct_ans;
begin
	$display ("Test %d ", cnt_test);
	$display ("///////////////////////");
	$display ("///////// Successful ////////");
	$display ("///////////////////////");
	$display ("%h + %h = ?", testInput_a, testInput_b);
	//$display ("your answer = %h", result);
	$display ("Answer = %h\n", correct_ans);
	$display("Input is NaN\n\n");
end endtask
/*--------------- Standard Output for NaN Case ---------------*/

endmodule