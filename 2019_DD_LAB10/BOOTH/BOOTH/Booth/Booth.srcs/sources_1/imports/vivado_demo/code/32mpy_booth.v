module lab(CLK, RST, din,addr, ctrl,Partial_Product, Product_Valid);
input CLK, RST;
input [2:0]ctrl;
input [15:0]addr;
input signed [31:0] din;
output reg [31:0] Partial_Product;
output reg Product_Valid;

reg signed[31:0]	in_a;	// Multiplicand
reg signed[31:0]	in_b;// Multiplier

reg [31:0] Mplicand;
reg signed [63:0] Product;
//reg [31:0] Mplier;
reg [6:0]	Counter ;
reg	sign;
reg Mythicalbit;

//Counter
always@(posedge CLK or negedge RST) // zedboard is negative edge
begin
	if(!RST)	// if reset=0 than actually we need to resuet
		Counter <=6'b0;
	else if(ctrl[0]) // if ctrl==001 than reset
		Counter <=6'b0;
	else if(Counter<=6'd33)
		Counter <= Counter +6'b1; // if no need to reset counter++
end

always@(posedge CLK or negedge RST)
begin
	if(!RST) begin
		in_a <=32'd0;
		in_b <=32'd0;
	end
	else if(addr[15:8]==8'h00)begin
		in_a <=din;
		in_b <=din;
	end
end

always@(posedge CLK or negedge RST)
begin
	if(!RST)begin
		Partial_Product<=32'd0;
	end
	else if(ctrl[2])begin	// if ctrl=100 send lower 32 bits
		Partial_Product<=Product[31:0];
	end
	else if(ctrl[1])begin	// if ctrl=010 send higher 32 bits
		Partial_Product<=Product[63:32];
	end
end

//Multiplier
always @(posedge CLK or negedge RST)
begin
	//??��?��?�數??
	if(!RST) begin
		Product  <= 64'b0;
		Mplicand <= 32'b0;
		Mythicalbit <= 1'b0;
		//Mplier   <= 32'b0;	
	end 
	
	//輸入乘數??�被乘數
	else if(Counter == 6'd0) begin
		Mplicand <= in_a;
		Product <={32'b0,in_b};
		Mythicalbit <= 1'b0;
	end 
	
	//乘�?��?�數?�移�?
	/* write down your design below */
	else if(Counter <=7'd32) 
	begin
	
		if(Product[0]==1'b0 && Mythicalbit ==1'b1) //Product ??低�?�為0 �? Mythicalbit ?��1
		begin//??��??: ??�被乘數??? Product左�?�相???, 存�?? Product左�??
			Product = Product + {Mplicand,32'b0};
		end
		
		if(Product[0]==1'b1 && Mythicalbit==1'b0)//Product ??低�?�為1 �? Mythicalbit ?��0
		begin//??��??: ??�被乘數??? Product左�?�相�?, 存�?? Product左�??
			Product = Product - {Mplicand,32'b0};
		end
		
		Mythicalbit = Product[0];
		
		Product = Product >>> 1;
	
	end 
	/* write down your design upon */
end

//?��?��輸出
always @(posedge CLK or negedge RST)
begin
	if(!RST)
		Product_Valid <=1'b0;
	else if(Counter>=6'd32)
		Product_Valid <=1'b1;
	else
		Product_Valid <=1'b0;
end

endmodule
