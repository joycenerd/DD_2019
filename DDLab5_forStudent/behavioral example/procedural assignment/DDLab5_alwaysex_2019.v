module lab5(in, out); //模組 lab5(對應的輸入埠與輸出埠)
	
	//宣告區段
	input [2:0]in; //宣告輸入埠 in ,其形態為 3bit wire
	output  reg [3:0]out; //宣告輸出埠 out ,其形態為 4bit reg
	
	//邏輯區段
	always @(*) 
	//當 always 讀取的變數或線改變時，再次執行 always 內容
	begin //開始描述 always 內容 
		out[3] = (!in[2] & !in[1] & in[0]) | (in[2] & in[1] & in[0]); 
		//計算輸出埠 out 的第3個位數
		out[2] = (!in[2] & in[1]);
		out[1] = (!in[2] & in[1]) | (in[2] & !in[1] & in[0]);
		out[0] = (!in[2] & !in[1]) | (in[2] & in[0]) | (in[1] & !in[0]); 
	end //結束描述 always 內容 

endmodule //結束模組

