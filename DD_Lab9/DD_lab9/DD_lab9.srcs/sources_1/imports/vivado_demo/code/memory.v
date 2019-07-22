`timescale 1ns / 1ps

module mem(addra, clka, dina, douta, ena, wea);
	
	input clka, ena, wea;
	input [5:0] addra;
	input [31:0] dina;
	output [31:0] douta;

	reg [31:0] mem[0:63];
	reg [31:0] addr_reg;
	
	assign douta = mem[addr_reg];
	
	always @(posedge clka)
	begin
		if(wea)		mem[addra] <= dina;
		if(ena)		addr_reg <= addra;
	end

endmodule