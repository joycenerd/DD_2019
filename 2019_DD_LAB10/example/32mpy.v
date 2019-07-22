`timescale 1ns/1ps
module lab(CLK, RST, in_a, in_b, Product, Product_Valid);
input CLK, RST;
input [31:0]	in_a;	// Multiplicand
input [31:0]	in_b;// Multiplier
output reg [63:0] Product;
output reg Product_Valid;

reg [63:0] Mplicand;
reg [31:0] Mplier;
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
		Mplier   <= 32'b0;	
	end 
	
	//輸入乘數與被乘數
	else if(Counter == 7'd0) begin
		Mplicand <= {32'b0,in_a};
		Mplier <= in_b;
	end 
	
	//乘法與數值移位
	/* write down your design below */
	else if(Counter <=7'd32) 	// when counter is smaller than 32 
	begin
		if(Mplier[0] == 1'b1)	// if LSB of multimplier is 1 than add product from multiplicand and product
			Product <= Mplicand + Product;
			
		Mplicand <= Mplicand << 1'b1; // multiplicand left shift 1 bit
		Mplier <= Mplier >> 1'b1;	// multiplier right shift 1 bit
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
