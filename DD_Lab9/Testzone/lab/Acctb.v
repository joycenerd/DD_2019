
`timescale 1ns/1ps
`include "accelerator.v"
module tb;

reg clk, rst_n;
reg wen, start_run;
wire bsy;
reg [31:0] addr, din;
wire [31:0] dout;

reg [31:0] in [0:63];
reg [31:0] correct_out [0:63];
reg error;
integer i;

initial clk =1;
always #5 clk = ~clk;

initial begin
	$dumpfile("square_wave.fsdb");
	$dumpvars;
//	$fsdbDumpMDA;
end

accelerator accelerator(
  .clk(clk),
  .rst_n(rst_n),
  .wen(wen),
  .start(start_run),
  .addr(addr),
  .din(din),
  .dout(dout),
  .bsy(bsy)//,
  //.mul_output(mul_output),
  //.mul_output3(mul_output3)
);


initial begin //Dump
	// initial values
	for (i=0;i<16;i=i+1) begin
//		in[i] = 32'h3f000000 + i;

		correct_out[0] = 32'h3e000000;
		
		correct_out[1] = 32'h41000000;
		correct_out[2] = 32'h41d80000;
		correct_out[3] = 32'h42800000;
		correct_out[4] = 32'h42fa0000;
		correct_out[5] = 32'h43580000;
		correct_out[6] = 32'h43ab8000;
		correct_out[7] = 32'h44000000;
		correct_out[8] = 32'h44364000;
		correct_out[9] = 32'h447a0000;
		correct_out[10] = 32'h44a66000;
		correct_out[11] = 32'h44d80000;
		correct_out[12] = 32'h45095000;
		correct_out[13] = 32'h452b8000;
		correct_out[14] = 32'h4552f000;
		correct_out[15] = 32'h45800000;
/**/
/*
correct_out[0] = 32'h3e800000;
correct_out[1] = 32'h3db851ec;
correct_out[2] = 32'h3d800000;
correct_out[3] = 32'h3f23d70a;
correct_out[4] = 32'h3eb851ec;
correct_out[5] = 32'h40100000;
correct_out[6] = 32'h3fc80000;
correct_out[7] = 32'h3f100000;
correct_out[8] = 32'h41440000;
correct_out[9] = 32'h41a20000;
correct_out[10] = 32'h42c80000;
correct_out[11] = 32'h40dc8000;
correct_out[12] = 32'h40440000;
correct_out[13] = 32'h42704000;
correct_out[14] = 32'h43f78800;
correct_out[15] = 32'h42992000;
*/
	end
	
	//
    in[0] = 32'h3f000000;
    in[1] = 32'h40000000;
    in[2] = 32'h40400000;
	in[3] = 32'h40800000;
    in[4] = 32'h40a00000;
    in[5] = 32'h40c00000;
	in[6] = 32'h40e00000;
    in[7] = 32'h41000000;
    in[8] = 32'h41100000;
	in[9] = 32'h41200000;
    in[10] = 32'h41300000;
    in[11] = 32'h41400000;
	in[12] = 32'h41500000;
    in[13] = 32'h41600000;
    in[14] = 32'h41700000;
	in[15] = 32'h41800000;
	/**/
	/*
in[0] = 32'h3f000000;
in[1] = 32'h3e99999a;
in[2] = 32'h3e800000;
in[3] = 32'h3f4ccccd;
in[4] = 32'h3f19999a;
in[5] = 32'h3fc00000;
in[6] = 32'h3fa00000;
in[7] = 32'h3f400000;
in[8] = 32'h40600000;
in[9] = 32'h40900000;
in[10] = 32'h41200000;
in[11] = 32'h40280000;
in[12] = 32'h3fe00000;
in[13] = 32'h40f80000;
in[14] = 32'h41b20000;
in[15] = 32'h410c0000;
*/

	error = 0;
	
	// run
	$display("input values");
	addr = 1'b0;
	start_run = 1'b0;
	rst_n = 1'b0;
	wen = 1'b0;
	#12;
	rst_n = 1'b1;
	
	for (i=0;i<16;i=i+1) begin
		@(posedge clk);
		din = in[i];
		addr = i*4;
		wen = 1'b1;
	end
	
	$display("start run");
	@(posedge clk);
	wen = 1'b0;
	start_run = 1'b1;
	@(posedge clk);
	start_run = 1'b0;
	
	$display("polling busy");
	@(posedge clk);
	while (bsy!=1'b0) begin
		@(posedge clk);
	end
	
	$display("get output");
	for (i=0;i<16;i=i+1) begin
	    addr = i<<2; 
		@(posedge clk);
		
		@(posedge clk);
		//@(posedge clk);
		//@(posedge clk);
        $display("output = %h",dout);
		if(dout!=correct_out[i]) begin
			$display("ERROR at address:%d dout:%h correct:%h",addr,dout,correct_out[i]);
			error =1;
		end
		
	end
	if (!error)  begin
		$display("========================");
		$display("=        PASS          =");
		$display("========================");
	end
	$finish;
end
endmodule
