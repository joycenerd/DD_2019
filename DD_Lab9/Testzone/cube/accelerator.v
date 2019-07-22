`timescale 1ns / 1ps
`include "FP_MPY.v"
`include "memory.v"

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

reg [7:0] cnt1,cnt2;
reg bsy;
wire [31:0] mul_output,mul_output_2;

wire [5:0] addr_in;
wire [31:0] din_in;
wire wen_in;
wire cntx4;
/*
wire [1:0] opcode;
assign opcode = 2'b11;
*/
always @(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		bsy <= 1'b0;
	else if(start == 1'b1 && bsy == 1'b0)
		bsy <= 1'b1;
	else if (cnt1 == 8'd127 && bsy ==1'b1)
		bsy <= 1'b0;
	else
		bsy <= bsy;
end
always @(posedge clk or negedge rst_n)
begin
	if(~rst_n) begin
		cnt1 <= 8'b0;
		//cntx4<=8'b0; 
		cnt2 <= 8'b0;
	end
	else if(bsy == 1'b1 && (cnt1 <=8'd127))begin
		cnt1 <= cnt1 + 8'b1;
		cnt2 <= ((cnt1+8'd3)%8);
	end
	else begin
		cnt1 <= 8'b0;
        cnt2 <= 8'b0;
	end
end

//cnt[0] =
//		0: memory read (wen=0)
//		1: memory write (wen=1)
assign wen_in = (bsy)?(cnt2[0]&&cnt2[1]&&cnt2[2]):wen;
assign cntx4 = (bsy)?((!cnt1[0]&&!cnt1[1]&&cnt1[2]) ||!cnt1[0]&&!cnt1[1]&&!cnt1[2] ):wen;
assign addr_in = (bsy)?cnt1[7:3]:addr[7:2];
assign din_in = (bsy)?mul_output_2:din;
//assign addr_in=addr_in+1'd0;

//assign mul_output = dout*dout;

fpu mpy1(.clk(clk),.opcode(2'b11), .A(dout), .B(dout), .dout(mul_output));
fpu mpy2(.clk(clk),.opcode(2'b11), .A(dout), .B(mul_output), .dout(mul_output_2));

mem memory(
    .addra(addr_in),
    .clka(clk),
    .dina(din_in),
    .douta(dout),
    .ena(1'b1),
    .wea(wen_in)
);

endmodule