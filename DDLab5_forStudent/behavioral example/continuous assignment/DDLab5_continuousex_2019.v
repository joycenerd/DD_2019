module lab5(in, out); //模組 lab5(對應的輸入埠與輸出埠)
	
	//宣告區段
	input [2:0]in; //宣告輸入埠 in ,其形態為 3bit wire
	output [3:0]out; //宣告輸出埠 out ,其形態為 4bit wire
	
	//邏輯區段
	assign out[3] = (!in[2] & !in[1] & in[0]) | (in[2] & in[1] & in[0]), 
		out[2] = (!in[2] & in[1]),
		out[1] = (!in[2] & in[1]) | (in[2] & !in[1] & in[0]),
		out[0] = (!in[2] & !in[1]) | (in[2] & in[0]) | (in[1] & !in[0]); 
		//用 assign 敘述描述輸出埠 out 的各個位數值

endmodule //結束模組

