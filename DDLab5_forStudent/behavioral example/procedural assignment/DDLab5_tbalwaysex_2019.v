`timescale 1ns/1ps	//告訴模擬軟體，前者(1ns)為時間單位，後者(1ps)為最小時間精度。
`include "DDLab5_alwaysex_2019.v" //加入生日顯示器

module testbench;	// 模組名稱
	reg CLK;		// 暫存器與線宣告
	reg [3:0]count;	
	wire [3:0]out;

	lab5 l5(count[2:0], out); //生日顯示器
	
	always	#10 CLK=~CLK;	//每10個單位時間，CLK的值反相一次

	always @ (posedge CLK) //當CLK正緣觸發時執行下述內容
	begin
		count=count+1; 
		if(count[3]==1'b1)	count<=4'b0; 
	end
	
	always @ (posedge CLK)
	begin
		#5	$display ("count = %d, out = %d",count, out); //5個單位時間後顯示敘述
	end
	
	initial begin	//僅執行一次
		$dumpfile("lab5.fsdb");  //產生波形檔
		$dumpvars; //產生波形檔
		CLK=1;
		count=4'b111;
		#160.7777777 $finish; //模擬於160.778ns結束
	end
endmodule