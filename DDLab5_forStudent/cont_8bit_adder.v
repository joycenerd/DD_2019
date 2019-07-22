`timescale 1ns / 1ps
/*宣告8bit adder module名稱,輸出入名稱*/
module cont_8bit_adder(sum, cout, a, b, cin);
    /*定義port,包含input, output*/
    input [7:0] a, b;
    input cin;
    output [7:0] sum;
    output cout;
    
    /*將a、b、cin相加,而cout為第8bit值,sum則為0~7bit值*/
    assign {cout,sum} = a+b+cin;
    
endmodule	