`timescale 1ns/1ps
`include "mpy32_top.v"

module testbench;
	/* Variables Declaration */
	reg [31:0] testInput_a, testInput_b;
	wire [31:0] mpy_ans;
	reg [31:0] correct_ans;

	reg [3:0] cnt_test;
	reg [3:0] cnt_right;
	/* Variable Declaration */



	/* Multiplier */
	mpy_top mpy_top(
		.input_a(testInput_a),
		.input_b(testInput_b),
		.mpy_output(mpy_ans)
	);
	/* Multiplier */



	/*-------------------- Start Testing --------------------*/
	initial begin
		$dumpfile("test32.fsdb");  
		$dumpvars;

		#0
			cnt_test = 0;
			cnt_right = 0;
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'hBA9DBB67;		// -0.0012034
			testInput_b = 32'h4148F5CB;		// 12.560008
			correct_ans = 32'hBC77A3B4;		// -1.5114713E-2
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'h43E20FCC;		// 452.1234
			testInput_b = 32'hC1AC8ADB;		// -21.5678
			correct_ans = 32'hC6185D3B;		// -9751.308
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'hC49A522C;		// -1234.5679
			testInput_b = 32'h442987E6;		// 678.1234
			correct_ans = 32'hC94C6456;		// -837189.4
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
		
		#1	/********* Test Pattern *********/
			testInput_a = 32'hA6AD6DA0;		// -1.2034E-15
			testInput_b = 32'h2BADAB89;		// 1.234E-12
			correct_ans = 32'h92EB4E94;		// -1.4849956E-27
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'hD6DA0A6A;		// -1.1986913E-14
			testInput_b = 32'hDAB892BA;		// -2.5976362E-16
			correct_ans = 32'h721D3475;		// 3.113764E-30
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'h522CC49A;		// 1.855082E11
			testInput_b = 32'h87E64429;		// -3.4646615E-34
			correct_ans = 32'h9A9B66A2;		// 6.427231E-23
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'h0FCC43E2;		// 2.01421E-29
			testInput_b = 32'hC9DBC1AC;		// -1800245.5
			correct_ans = 32'h9A2F589B;		// -3.6260727E-23
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
        #1	/********* Test Pattern *********/
			testInput_a = 32'hBB67BA9D;		// -3.5359033E-3
			testInput_b = 32'hF5CB4148;		// -5.1531266E-32
			correct_ans = 32'h71B7FC12;		// 1.8220957E-30
			cnt_test = cnt_test + 1;
		#10 
			if (mpy_ans == correct_ans) begin
				success_case (testInput_a, testInput_b, correct_ans);
			end else begin
				failure_case (testInput_a, testInput_b, correct_ans, mpy_ans);
			end
        
        $display("Total: %d    Success: %d\n", cnt_test, cnt_right);
        $finish;
	end
/*-------------------- End Testing --------------------*/



/*--------------- Standard Output for Success Case ---------------*/
task success_case;
input [31:0] testInput_a, testInput_b, ans;
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
input [31:0] testInput_a, testInput_b, ans, mpy_ans;
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