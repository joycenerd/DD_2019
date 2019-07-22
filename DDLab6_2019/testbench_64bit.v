`timescale 1ns/1ps
`include "CLA_64bit.v"
module testbench;

	reg  [63:0] in_a, in_b;
	reg CLK;
	reg reset;
	reg  [64:0] correct_ans;
	wire  [63:0] sum;
	reg [5:0] counter;
	reg [5:0] ct;
	reg error;
	reg cin;	
	wire cout;

	initial cin = 0;
	initial ct = 0;
	initial in_a = 0;
	initial in_b = 0;

	cla_64bit DDLab6(in_a, in_b, cin, sum);
	
	/////// initial ///////
	initial begin

	$dumpfile("lab6_64bit.fsdb");
	$dumpvars;
	CLK = 1'b0;
	#10 reset = 1;
	#20 reset = 0;
	
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;	
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	#500 reset = 1;
	#20 reset = 0;
	
	#500    $finish;
	
	end
	

	always #10 CLK = ~CLK;

	always @(posedge CLK or posedge reset)
	begin
	       
		if(reset)
		begin
			counter <= 0;
			in_a <= {$random}*{$random}*{$random}*{$random};
			in_b <= {$random}*{$random}*{$random}*{$random};
			//in_b <= 64'd9223372036854775808+{$random};
			cin <= {$random}%2;
			correct_ans <= 0;
			error <= 0;
			ct <= ct + 1'b1;
		end
		else
		begin
			correct_ans <= in_a + in_b + cin;
			counter <= counter + 1;
			if(counter == 4)
				if(sum == correct_ans[63:0])
				begin
					$display ("  Test %d ", ct);
					$display ("  ////////////////");
					$display ("  // Successful //");
					$display ("  ////////////////");
					$display ("  %d + %d + %d = ?", in_a, in_b ,cin);
					$display ("  sum = %d\n", sum);
					$display ();
				end
				else
				begin
					$display ();
					$display ("Test %d ", ct);
					$display ("//////////");
					$display ("// Fail //");
					$display ("//////////");
					$display ("%d + %d + %d = ?", in_a, in_b ,cin);
					$display ("your sum = %d", sum);
					$display ("correct:");
					$display ("     sum=%d", correct_ans[63:0]);
	
					$display ();
				end
		end


	end


endmodule
