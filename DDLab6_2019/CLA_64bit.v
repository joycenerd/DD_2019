module cla_64bit( a, b, cin, sum);

	input [63:0] a, b;
	input cin;
	output [63:0] sum;
	output cout;
	//write your design below

	wire[63:0] p,g,c;
	wire[15:0] P4,G4;
	wire[3:0] P16,G16;
	
	// pi,gi
	pg_generator pg(a[63:0],b[63:0],p[63:0],g[63:0]);

	// P,G 4 in one group
	PG_generator PGx4_0(p[3:0],g[3:0],P4[0],G4[0]); // 3:0
	PG_generator PGx4_1(p[7:4],g[7:4],P4[1],G4[1]); // 7:4
	PG_generator PGx4_2(p[11:8],g[11:8],P4[2],G4[2]); // 11:8
	PG_generator PGx4_3(p[15:12],g[15:12],P4[3],G4[3]); // 15:12
	PG_generator PGx4_4(p[19:16],g[19:16],P4[4],G4[4]); // 19:16
	PG_generator PGx4_5(p[23:20],g[23:20],P4[5],G4[5]); // 23:20
	PG_generator PGx4_6(p[27:24],g[27:24],P4[6],G4[6]); // 27:20
	PG_generator PGx4_7(p[31:28],g[31:28],P4[7],G4[7]); // 31:28
	PG_generator PGx4_8(p[35:32],g[35:32],P4[8],G4[8]); // 35:32
	PG_generator PGx4_9(p[39:36],g[39:36],P4[9],G4[9]); // 39:36
	PG_generator PGx4_10(p[43:40],g[43:40],P4[10],G4[10]); // 43:40
	PG_generator PGx4_11(p[47:44],g[47:44],P4[11],G4[11]); // 47:44
	PG_generator PGx4_12(p[51:48],g[51:48],P4[12],G4[12]); // 51:48
	PG_generator PGx4_13(p[55:52],g[55:52],P4[13],G4[13]); // 52:55
	PG_generator PGx4_14(p[59:56],g[59:56],P4[14],G4[14]); // 59:56
	PG_generator PGx4_15(p[63:60],g[63:60],P4[15],G4[15]); // 63:60

	// P,G 16 in one group
	PG_generator PGx16_0(P4[3:0],G4[3:0],P16[0],G16[0]); // 15:0
	PG_generator PGx16_1(P4[7:4],G4[7:4],P16[1],G16[1]); // 31:16
	PG_generator PGx16_2(P4[11:8],G4[11:8],P16[2],G16[2]); // 47:32
	PG_generator PGx16_3(P4[15:12],G4[15:12],P16[3],G16[3]); // 63:48

	// generate carry c48,c32,c14
	carry_generator carry_x16(P16[3:0],G16[3:0],cin,{c[48],c[32],c[16]});

	// generate carry with the multiple of 4
	carry_generator carryx4_0(P4[3:0],G4[3:0],cin,{c[12],c[8],c[4]}); // c12,c8,c4
	carry_generator carryx4_1(P4[7:4],G4[7:4],c[16],{c[28],c[24],c[20]}); // c28,c24,c20
	carry_generator carryx4_2(P4[11:8],G4[11:8],c[32],{c[44],c[40],c[36]}); // c44,c40,c36
	carry_generator carryx4_3(P4[15:12],G4[15:12],c[48],{c[60],c[56],c[52]}); // c60,c56,c52


	// generate all the remaining carry out
	carry_generator carry0(p[3:0],g[3:0],cin,{c[3],c[2],c[1]}); // c3,c2,c1
	carry_generator carry1(p[7:4],g[7:4],c[4],{c[7],c[6],c[5]}); // c7,c6,c5
	carry_generator carry2(p[11:8],g[11:8],c[8],{c[11],c[10],c[9]}); // c11,c10,c9
	carry_generator carry3(p[15:12],g[15:12],c[12],{c[15],c[14],c[13]}); // c15,c14,c13
	carry_generator carry4(p[19:16],g[19:16],c[16],{c[19],c[18],c[17]}); // c19,c18,c17
	carry_generator carry5(p[23:20],g[23:20],c[20],{c[23],c[22],c[21]}); // c23,c22,c21
	carry_generator carry6(p[27:24],g[27:24],c[24],{c[27],c[26],c[25]}); // c27,c26,c25
	carry_generator carry7(p[31:28],g[31:28],c[28],{c[31],c[30],c[29]}); // c31,c30,c29
	carry_generator carry8(p[35:32],g[35:32],c[32],{c[35],c[34],c[33]}); // c35,c34,c33
	carry_generator carry9(p[39:36],g[39:36],c[36],{c[39],c[38],c[37]}); // c39,c38,c37
	carry_generator carry10(p[43:40],g[43:40],c[40],{c[43],c[42],c[41]}); // c43,c42,c41
	carry_generator carry11(p[47:44],g[47:44],c[44],{c[47],c[46],c[45]}); // c47,c46,c45
	carry_generator carry12(p[51:48],g[51:48],c[48],{c[51],c[50],c[49]}); // c51,c50,c49
	carry_generator carry13(p[55:52],g[55:52],c[52],{c[55],c[54],c[53]}); // c55,c54,c53
	carry_generator carry14(p[59:56],g[59:56],c[56],{c[59],c[58],c[57]}); // c59,c58,c57
	carry_generator carry15(p[63:60],g[63:60],c[60],{c[63],c[62],c[61]}); // c63,c62,c61

	// generate sum
	sum_generator sum1(a[63:0],b[63:0],cin,c[63:1],sum[63:0]);

endmodule


module pg_generator(a,b,p,g);

	input[63:0] a, b;
	output[63:0] p, g;
	
	assign p = a | b; // a+b
	assign g = a & b;	// a*b

endmodule


module PG_generator(p,g,P,G);

	input[3:0] p,g;
	output P,G;

	assign P = p[3] & p[2] & p[1] & p[0]; // p3*p2*p1*p0
	assign G = g[3]|(p[3] & g[2])|(p[3] & p[2] & g[1])|(p[3] & p[2] & p[1] & g[0]); // g3+p3g2+p3p2g1+p3p2p1g0
	
endmodule


module carry_generator(p,g,cin,c);

	input[3:0] p,g;
	input cin;
	output[3:1] c;

	assign c[1] = g[0] | (p[0]&cin);
	assign c[2] = g[1] | (p[1]&g[0]) | (p[1]&p[0]&cin);
	assign c[3] = g[2] | (p[2]&g[1]) | (p[2]&p[1]&g[0]) | (p[2]&p[1]&p[0]&cin);

endmodule


module sum_generator(a,b,cin,c,sum);

	input[63:0] a,b;
	input [63:1] c;
	input cin;
	output[63:0] sum;

	assign sum=a^b^{c,cin}; // a xor b xor c

endmodule

