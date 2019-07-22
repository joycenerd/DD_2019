module lab(CLK, RST, din,addr, ctrl,Partial_Product, Product_Valid);
input CLK, RST;
input [2:0]ctrl;
input [15:0]addr;
input signed [31:0] din;
output reg [31:0] Partial_Product;
output reg Product_Valid;

reg signed[31:0]	in_a;	// Multiplicand
reg signed[31:0]	in_b;// Multiplier

reg [63:0] Mplicand;
reg signed [63:0] Product;
reg [32:0] Mplier;
reg [6:0]	Counter ;
reg	sign;
//reg Mythicalbit;

//Counter
always@(posedge CLK or negedge RST) // zedboard is negative edge
begin
	if(!RST)	// if reset=0 than actually we need to resuet
		Counter <=6'b0;
	else if(ctrl[0]) // if ctrl==001 than reset
		Counter <=6'b0;
	else if(Counter<=6'd17)
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
		Mplicand <= 64'b0;
		//Mythicalbit <= 1'b0;
		Mplier   <= 33'b0;	
	end 
	
	//輸入乘數??�被乘數
	else if(Counter == 6'd0) begin
		Mplicand <= in_a;
		Mplier <= {in_b,1'b0};
		//Product <={32'b0,in_b};
		//Mythicalbit <= 1'b0;
	end 
	
	//乘�?��?�數?�移�??
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

//?��?��輸出
always @(posedge CLK or negedge RST)
begin
	if(!RST)
		Product_Valid <=1'b0;
	else if(Counter>=6'd16)
		Product_Valid <=1'b1;
	else
		Product_Valid <=1'b0;
end

endmodule
