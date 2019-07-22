module accumulator(
	input wire clk, 
	input wire [31:0] prod,
    input wire acc_en,
	output reg [35:0] acc // acc is 32 bit + 4 extra bit to cope with overflow
);
	
    always @(posedge clk) begin
		// the first value acc_en will be in than add 0 to acc
		// afraid of overflow so we expand MSB 4 bit
		acc <= {{4{prod[31]}},prod[31:0]} + ((acc_en)?acc:0);
	end


endmodule
