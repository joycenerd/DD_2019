`timescale 1ns / 1ps
/*宣告8bit adder module名稱,輸出入名稱*/
module proc_8bit_adder(sum, cout, a, b, cin);
    /*定義port,包含input, output*/
    input [7:0] a, b;
    input cin;
    output [7:0] sum;
    output cout;
    /*在procedural assignment下，等號的左邊需為reg型態*/
    reg [7:0] sum;
    reg cout;
    
    /*將a、b、cin相加,而cout為第8bit值,sum則為0~7bit值*/
    always@(a or b or cin)
        {cout, sum} = a + b + cin;
        
endmodule	


