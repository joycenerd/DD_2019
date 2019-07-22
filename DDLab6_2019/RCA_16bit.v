module cla_16bit( a, b, cin, sum);

    input [15:0] a, b;
	input cin;
	output [15:0] sum;
	output cout;
    wire c[16:0];

    ripple_carry_adder rca0(a[0],b[0],cin,c[1],sum[0]);
    ripple_carry_adder rca1(a[1],b[1],c[1],c[2],sum[1]);
    ripple_carry_adder rca2(a[2],b[2],c[2],c[3],sum[2]);
    ripple_carry_adder rca3(a[3],b[3],c[3],c[4],sum[3]);
    ripple_carry_adder rca4(a[4],b[4],c[4],c[5],sum[4]);
    ripple_carry_adder rca5(a[5],b[5],c[5],c[6],sum[5]);
    ripple_carry_adder rca6(a[6],b[6],c[6],c[7],sum[6]);
    ripple_carry_adder rca7(a[7],b[7],c[7],c[8],sum[7]);
    ripple_carry_adder rca8(a[8],b[8],c[8],c[9],sum[8]);
    ripple_carry_adder rca9(a[9],b[9],c[9],c[10],sum[9]);
    ripple_carry_adder rca10(a[10],b[10],c[10],c[11],sum[10]);
    ripple_carry_adder rca11(a[11],b[11],c[11],c[12],sum[11]);
    ripple_carry_adder rca12(a[12],b[12],c[12],c[13],sum[12]);
    ripple_carry_adder rca13(a[13],b[13],c[13],c[14],sum[13]);
    ripple_carry_adder rca14(a[14],b[14],c[14],c[15],sum[14]);
    ripple_carry_adder rca15(a[15],b[15],c[15],c[16],sum[15]);
    
endmodule

module ripple_carry_adder(a,b,cin,c,sum);
    input a,b,cin;
    output c,sum;
    
    //assign c = (a&b) | (b&cin) | (a&cin);
    //assign sum= a ^ b ^cin;

    assign {c,sum}= a + b + cin;

endmodule



