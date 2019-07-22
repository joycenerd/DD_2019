`timescale 1ns / 1ps
`include "fir.v"

module tb;

    // Inputs
	reg   clk,rst;
	reg   [1:0 ] ctrl;
	reg   [15:0]  din;
	reg   [15:0]  addr; 
	reg   rst_n;
	reg [15:0] in_a[0:63];
	reg [15:0] in_b[0:63];
	reg [15:0] ans [0:63];
	wire   [15:0] dout;
	wire   bsy;
    integer i;
	// define clock
    initial begin
    clk = 0;
    forever #10 clk <= ~clk; 
    end  
	
	initial begin
		$dumpfile("square_wave.fsdb");
		$dumpvars;
	end
	
	fir fir(
    .clk(clk),
	.rst(rst),
    .din(din),
    .ctrl(ctrl),
    .addr(addr),
    .dout(dout),
    .bsy(bsy)
    );
	
	// define a ram store input signal
    reg [15:0] mem1[0:35];
	reg [15:0] mem2[0:35];
	
    // read data from disk
    initial begin
        $readmemb("./databin3.mem" , mem1);
		$readmemb("./ans.mem" , mem2);
    end
	
    initial begin

	    addr <= 0;
	    rst <= 1'b0;
	    #12;
	    rst <= 1'b1;
		#12;
		
	    ctrl <= 2'b10;
		@(posedge clk);
		ctrl <= 2'b00;
		@(posedge clk);
		


	    for (i=1;i<37;i=i+1) begin
		    @(posedge clk);
		    din <= mem1[i-1];
		    addr <= (i*4);
	    end
		
		@(posedge clk);
		din <= mem1[0];
	    addr <= 0;
			
		$display("start run");
		
		@(posedge clk);
		ctrl <= 2'b01;
		@(posedge clk);
		ctrl <= 2'b00;
		
		$display("polling busy");
		@(posedge clk);
		
	    while(bsy!=1'b0) begin
		    @(posedge clk);
	    end
		
		$display("operation finish");
		@(posedge clk);
		for (i=1;i<37;i=i+1) begin
		    addr <= (i*4);
		    @(posedge clk);
			@(posedge clk);
			ans[i-1]<=dout;
	    end
		
		@(posedge clk);
		
		for(i=0;i<36;i=i+1) begin
			if(mem2[i]===16'dx && ans[i]===16'dx) begin
				$display("========================");
				$display("=      Correct[%02d]   =",i);
				$display("========================");
				$display("your answer:%d\nreal answer:%d",ans[i],mem2[i]);
			end
			else begin
				casez({|(mem2[i]^ans[i])})
					1'b1: begin
						$display("========================");
						$display("=        Wrong[%02d]   =",i);
						$display("========================");
						$display("your answer:%d\nreal answer:%d",ans[i],mem2[i]);
					end
					1'b0: begin
						$display("========================");
						$display("=      Correct[%02d]   =",i);
						$display("========================");
						$display("your answer:%d\nreal answer:%d",ans[i],mem2[i]);
					end
					1'bx: begin
						$display("========================");
						$display("=        Wrong[%02d]   =",i);
						$display("========================");
						$display("your answer:%d\nreal answer:%d",ans[i],mem2[i]);
					end
				endcase
			end
		end
		
		$finish;
    end

endmodule
