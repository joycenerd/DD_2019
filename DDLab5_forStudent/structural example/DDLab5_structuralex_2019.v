module lab5(in, out);//模組 lab6(對應的輸入埠與輸出埠)

	//宣告區段
	input [2:0]in; //宣告輸入埠 in ,其形態為 3bit wire
	output  [3:0]out; //宣告輸出埠 out ,其形態為 4bit wire
	wire nin2, nin1, nin0; //宣告線 
	wire w0, w1, w2, w3, w4, w5, w6;
	
	//邏輯區段	
	//使用 not 將 in[2] 的補數訂為線 nin2
	not n2(nin2, in[2]), 
		n1(nin1, in[1]), 
		n0(nin0, in[0]);
		
	//使用 and 描述電路圖上的 and gate 與線的關係
	and a0(w0, nin2, nin1, in[0]), 
		a1(w1, in[2], in[1], in[0]), 
		a2(out[2] , nin2, in[1]), 
		a3(w2, nin2, in[1]), 
		a4(w3, in[2], nin1, in[0]), 
		a5(w4 , nin2, nin1), 
		a6(w5, in[2], in[0]),
		a7(w6, in[1], nin0);
	
	//使用 or 描述電路圖上的 or gate 與線的關係
	or o0(out[3], w0, w1),
		o1(out[1], w2, w3),
		o2(out[0], w4, w5, w6);

endmodule //結束模組






