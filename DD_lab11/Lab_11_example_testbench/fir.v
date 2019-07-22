`include "accumulator.v"
`include "crom.v"
`include "dbuf.v"
`include "multi.v"
`include "sysctrl.v"

module fir(
    input wire clk,
    input wire rst,
	input wire [1:0] ctrl,
	input wire [15:0] addr,
    input wire [15:0] din,
    output wire [15:0] dout,
	output wire bsy
);
	wire RW1,RW2;
	wire [3:0] cidx;
	wire [5:0]  didx1,didx2;
	wire [15:0] coef, di,douta;
	wire [31:0] prod;
	wire [35:0] acc;
	wire acc_en;
	
	sysctrl ctrl_m(
		.clk(clk), 
		.rst(rst),
		.ctrl(ctrl),
		.acc(acc),
		.RW1(RW1),
		.RW2(RW2),
		.didx1(didx1),
		.didx2(didx2),
		.cidx(cidx),
		.douta(douta),
		.acc_en(acc_en),
		.bsy(bsy)
	);
	
	crom coef_m(
		.clk(clk), 
		.cidx(cidx), 
		.coef(coef)
	);

	// if not bsy -> buff_in stores input
	// if bsy -> buff_in store output after computation
	dbuf buff_in(
		.clk(clk), 
		.din((bsy)?douta:din),
		.didx((bsy)?didx2:addr[7:2]),
		.RW(RW1),
		.di(dout)
	);
	
	dbuf buff_m(	// buff_m use for memory which do computation
		.clk(clk), 
		.din(dout),	// buff_m's din = dout of buff_in
		.didx(didx1),
		.RW(RW2),
		.di(di)
	);
	
	// coefficient * input
	multi mult_m(
		.clk(clk),
		.prod(prod), 
		.coef(coef),		
		.di(di)
	); 
	
	accumulator acc_m(
		.clk(clk), 
		.prod(prod),
		.acc(acc),
		.acc_en(acc_en)
	);

endmodule