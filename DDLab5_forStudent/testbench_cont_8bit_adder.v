`timescale 1ns / 1ps

module testbench_cont_8bit_adder;

reg [7:0] a, b;
reg cin;
wire [7:0] sum;
wire cout;

cont_8bit_adder DUT(sum, cout, a, b, cin);
//proc_8bit_adder DUT(sum, cout, a, b, cin);

initial begin
    $dumpfile("cont_8bit_adder.vcd");
    $dumpvars;
end

initial
begin
    a = 8'b11110000;
    b = 8'b11111111;
    cin = 1'b1;
	//a = 8'b00000000;
    //b = 8'b00000000;
    //cin = 1'b1;
end

always #1
begin
    a = ( a<<1 | cin );/*a左移1bit後再與cin做or*/   
	/*使用$monitor印出所有input、output數值變化*/
    $monitor("%4dns monitor: a=%d b=%d cin=%d sum=%d cout=%d", $stime, a, b, cin, sum, cout);
end

always #2 b = b >>2;/*每經過2ns右移2bit*/
always #3 cin = ~cin;/*每經過3ns反向一次*/
initial #15 $finish;/*經過15ns後結束程式*/
endmodule