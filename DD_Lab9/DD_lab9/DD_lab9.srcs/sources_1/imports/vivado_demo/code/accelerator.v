`timescale 1ns / 1ps

module accelerator (
    clk,
    rst_n,
    wen,
    start,
    addr,
    din,
    dout,
    bsy
);

input clk;
input rst_n;
input wen;
input start;
input [32-1:0] addr;
input [32-1:0] din;

output [32-1:0] dout;
output bsy;

reg [8:0] cnt;
reg bsy;
wire [31:0] mul_output;

wire [5:0] addr_in;
wire [31:0] din_in;
wire wen_in;
//---------------------------------------//
//---------------------------------------//
always @(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		bsy <= 1'b0;
	else if(start == 1'b1 && bsy == 1'b0)
		bsy <= 1'b1;
	else if (cnt == 8'd127 && bsy ==1'b1)
		bsy <= 1'b0;
	else
		bsy <= bsy;
end
always @(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		cnt <= 8'b0;
	else if(bsy == 1'b1 && (cnt <=8'd127))
		cnt <= cnt + 8'b1;
	else
		cnt <= 8'b0;
end

//cnt[0] = 
//		0: memory read (wen=0)
//		1: memory write (wen=1)
assign wen_in = (bsy)?cnt[0]:wen;
assign addr_in = (bsy)?cnt[6:1]:addr[7:2];
assign din_in = (bsy)?mul_output:din;

//assign mul_output = dout*dout;

fpu mpy(.clk(clk),.opcode(2'b11), .A(dout), .B(dout), .dout(mul_output));


mem memory(
    .addra(addr_in),
    .clka(clk),
    .dina(din_in),
    .douta(dout),
    .ena(1'b1),
    .wea(wen_in)
);

endmodule

