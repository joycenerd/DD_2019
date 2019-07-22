module dbuf(
	input wire clk, 
	input wire [15:0] din, //input
	input wire [5:0] didx, //address
	input wire RW,
	output reg [15:0] di
);
	reg [15:0] mem [0:63];

	// dbuf
	// RW=1 (write mode)
	// RW=0 (read mode)
	always @(posedge clk) begin 
		if(RW) // write mode: write din into memory
			mem[didx] <= din; 
		// if read mode -> don't write din to memory
		
		di <= RW ? din:mem[didx]; // if write mode -> write out din to di(dout)
		// if read mode -> write out what's in memory to di(dout)
	end

endmodule




