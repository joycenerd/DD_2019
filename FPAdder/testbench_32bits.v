`include "fp32_adder.v"
`timescale 1ns / 1ps

module test_bench;

	/* Variables Declaration */
	reg[31:0] testInput_a;
	reg[31:0] testInput_b;
	reg [31:0] correct_ans;
	wire [31:0] adder_ans;
	/* Variables Declaration */

	/* 待驗證的Module */
	fpadder test(
		.a(testInput_a),
		.b(testInput_b),
		.sub(1'b0),
		.s(adder_ans));

	reg [4:0] cnt_test, cnt_right;
	initial begin
		$dumpfile("adder32.vcd");
		$dumpvars;

		#0
			cnt_test = 0;
			cnt_right = 0;
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'hBA9DBB67;		// -0.0012034
			testInput_b = 32'h4148F5CB;		// 12.560008
			correct_ans = 32'h4148F0DD;		// 12.5588045
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'h43E20FCC;		// 452.1234
			testInput_b = 32'hC1AC8ADB;		// -21.5678
			correct_ans = 32'h43D7471E;		// 430.5556
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'hC49A522C;		// -1234.5679
			testInput_b = 32'h442987E6;		// 678.1234
			correct_ans = 32'hC40B1C72;		// -556.44446
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'hA6AD6DA0;		// -1.2034E-15
			testInput_b = 32'h2BADAB89;		// 1.234E-12
			correct_ans = 32'h2BAD802E;		// 1.2327966E-12
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'hD6DA0A6A;		// -1.1986913E-14
			testInput_b = 32'hDAB892BA;		// -2.5976362E-16
			correct_ans = 32'hDAB96CC4;		// -2.609623E-16
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'h522CC49A;		// 1.855082E-11
			testInput_b = 32'h87E64429;		// -3.4646615E-34
			correct_ans = 32'h522CC49A;		// 1.855082E-11
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'h0FCC43E2;		// 2.01421E-29
			testInput_b = 32'hC9DBC1AC;		// -1800245.5
			correct_ans = 32'hC9DBC1AC;		// -1800245.5
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'hBB67BA9D;		// -3.5359033E-3
			testInput_b = 32'hF5CB4148;		// -5.1531266E-32
			correct_ans = 32'hF5CB4148;		// -5.1531266E-32
			cnt_test = cnt_test + 1;
		#10 
			if (adder_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, adder_ans);
			end
		#1	/********* Test Pattern *********/
			testInput_a = 32'h3B67BA9D;		// 3.5359033E-3
			testInput_b = 32'hBB67BA9D;		// -3.5359033E-3
			correct_ans = 32'h00000000;		// 0
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
input [31:0] testInput_a, testInput_b, correct_ans;
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
input [31:0] testInput_a, testInput_b, correct_ans, result;
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

endmodule