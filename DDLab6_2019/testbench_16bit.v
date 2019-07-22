	`timescale 1ns/1ps
`include "RCA_16bit.v"
module testbench;

	reg  [15:0] in_a, in_b;
	reg CLK;
	reg reset;

	reg  [15:0] correct_ans;
	wire  [15:0] s;
	reg [5:0] counter;
	reg [5:0] ct;
	reg error;
	reg cin;	
	reg [4:0]successful_count;
	wire cout;

	initial cin = 0;
	initial ct = 0;
	initial in_a = 0;
	initial in_b = 0;
	initial successful_count = 0;

	cla_16bit DDLab6(in_a, in_b, cin, s);
	

	
	/////// initial ///////
	initial begin

	$dumpfile("lab6_16bit.fsdb");  
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
			in_a <= {$random};
			in_b <= {$random} % 32767;
			cin <= {$random} % 2;
			correct_ans <= 0;
			error <= 0;
			ct <= ct + 1'b1;
		end
		else
		begin
			correct_ans <= in_a + in_b +cin ;
			counter <= counter + 1;
			if(counter == 4)
				//if({cout,s} == correct_ans)
				if(s == correct_ans)
				begin
					successful_count = successful_count+1;
					$display ("Test %d ", ct);
					$display ("//////////////////");
					$display ("// Successful %d//",successful_count);
					$display ("//////////////////");
					$display ("%d + %d + %d= ?", in_a, in_b , cin);
					$display ("sum = %d\n", s);
					$display ();
				end
				else
begin
					$display ();
					$display ("Test %d ", ct);
					$display ("//////////");
					$display ("// Fail //");
					$display ("//////////");
					$display ("%d + %d + %d= ?", in_a, in_b , cin);
					$display ("your  s=%d", s);
					$display ("correct:");
					$display ("sum =%d", correct_ans[15:0]);
					$display ();
				end
		end


	end


endmodule
