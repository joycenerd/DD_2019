`timescale 1ns/1ps
module lab(CLK, RST, in_a, in_b, Product, Product_Valid,state);
input CLK, RST;
input signed[31:0]	in_a;	// Multiplicand
input signed[31:0]	in_b;// Multiplier
output reg signed [63:0] Product;
output reg Product_Valid;
input reg[1:0] state;


reg [31:0] Mplicand;
//reg [31:0] Mplier;
reg [6:0]	Counter ;
reg	sign;
reg Mythicalbit;

//Counter
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Counter <=6'b0;
	else
		Counter <= Counter +6'b1;
end

always @(posedge CLK or posedge RST)


//Multiplier
always @(posedge CLK or posedge RST)
begin
	//初始化數值
	if(RST) begin
		Product  <= 64'b0;
		Mplicand <= 32'b0;
		Mythicalbit <= 1'b0;
		//Mplier   <= 32'b0;	
	end 
	
	//輸入乘數與被乘數
	else if(Counter == 6'd0) begin
		if(state==2'b11) begin
			Mplicand <= in_a;
			Product <={32'b0,in_b};
			Mythicalbit <= 1'b0; 	// add 0 to the last bit of multiplier
		end
		else if(state==2'b10) begin
			Mplicand <= in_a;
			Product <={32'b0,in_a};
			Mythicalbit <= 1'b0; 	// add 0 to the last bit of multiplier
		end
		else if(state==2'b01) begin
			Mplicand <= in_b;
			Product <={32'b0,in_b};
			Mythicalbit <= 1'b0; 	// add 0 to the last bit of multiplier
		end
	end 
	
	//乘法與數值移位
	/* write down your design below */
	else if(Counter <=7'd32) 	// 32 bit multiplier will do 32 cycle generate 32 partial product
	begin
		// bi=0, bi-1=1 -> +A
		if(Product[0]==1'b0 && Mythicalbit ==1'b1) //Product 最低位為0 且 Mythicalbit 為1
		begin//做加: 把被乘數與 Product左半相加, 存回 Product左半
			Product = Product + {Mplicand,32'b0};
		end
		// bi=1, bi-1=0 -> -A
		if(Product[0]==1'b1 && Mythicalbit==1'b0)//Product 最低位為1 且 Mythicalbit 為0
		begin//做減: 把被乘數與 Product左半相減, 存回 Product左半
			Product = Product - {Mplicand,32'b0};
		end
		
		Mythicalbit = Product[0];
		
		Product = Product >>> 1;
		
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
