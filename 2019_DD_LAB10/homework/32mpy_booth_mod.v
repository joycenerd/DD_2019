`timescale 1ns/1ps
module lab(CLK, RST, in_a, in_b, Product, Product_Valid);
input CLK, RST;
input  signed[31:0]	in_a;	// Multiplicand
input  signed[31:0]	in_b;// Multiplier
output reg  [63:0] Product;
output reg Product_Valid;

reg signed[63:0] Mplicand;
reg signed[32:0] Mplier;
reg [6:0]	Counter ;
reg	sign;

//Counter
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Counter <=6'b0;
	else
		Counter <= Counter +6'b1;
end

//Multiplier
always @(posedge CLK or posedge RST)
begin
	//初始化數值
	if(RST) begin
		Product  <= 64'b0;
		Mplicand <= 64'b0;
		Mplier   <= 33'b0;
	end

	//輸入乘數與被乘數
	else if(Counter == 6'd0) begin
		Mplicand <= in_a;
		Mplier <= {in_b,1'b0};
	end

	//乘法與數值移位
	/* write down your design below */
	else if(Counter <=6'd16)
	begin
		if(Mplier[2:0] == 3'b001||Mplier[2:0] == 3'b010)
		Product <= Mplicand + Product;
		else if(Mplier[2:0] == 3'b011)
		Product <= 2 * Mplicand + Product;
		else if(Mplier[2:0] == 3'b100)
		Product <= Product - 2 * Mplicand;
		else if(Mplier[2:0] == 3'b101||Mplier[2:0] == 3'b110)
		Product <= Product - Mplicand;
		Mplicand <= Mplicand << 2'b10;
		Mplier <= Mplier >> 2'b10;
	end
	/* write down your design upon */
end

//判斷輸出
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Product_Valid <=1'b0;
	else if(Counter==6'd32)
		Product_Valid <=1'b1;
	else
		Product_Valid <=1'b0;
end

endmodule