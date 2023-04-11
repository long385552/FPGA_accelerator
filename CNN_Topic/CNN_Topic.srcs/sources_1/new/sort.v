`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 00:58:11
// Design Name: 
// Module Name: sort
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sort(
    input signed [15:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9,
    input en,
    output [3:0] out //, out1, out2, out3, out4, out5, out6, out7, out8, out9
    );

wire signed [15:0] a [0:9], b[0:7], c[0:9], d[0:7], e[0:9], f[0:7], g[0:9], h[0:7], i[0:9]; //b[0:2], c[0:3], d[0:2], e[0:5], f[0:3], g[0:1];
wire signed [15:0] max;
//design  
//1
assign a[0] = ( in0 >= in1 ) ? in0 : in1;
assign a[1] = ( in0 > in1 )  ? in1 : in0;
assign a[2] = ( in2 >= in3 ) ? in2 : in3;
assign a[3] = ( in2 > in3 )  ? in3 : in2;
assign a[4] = ( in4 >= in5 ) ? in4 : in5;
assign a[5] = ( in4 > in5 )  ? in5 : in4;
assign a[6] = ( in6 >= in7 ) ? in6 : in7;
assign a[7] = ( in6 > in7 )  ? in7 : in6;
assign a[8] = ( in8 >= in9 ) ? in8 : in9;
assign a[9] = ( in8 > in9 )  ? in9 : in8;
//2
assign b[0] = (a[1] >= a[2]) ? a[1] : a[2];
assign b[1] = (a[1] > a[2])  ? a[2] : a[1];
assign b[2] = (a[3] >= a[4]) ? a[3] : a[4];
assign b[3] = (a[3] > a[4])  ? a[4] : a[3];
assign b[4] = (a[5] >= a[6]) ? a[5] : a[6];
assign b[5] = (a[5] > a[6])  ? a[6] : a[5];
assign b[6] = (a[7] >= a[8]) ? a[7] : a[8];
assign b[7] = (a[7] >  a[8]) ? a[8] : a[7];
//3
assign c[0] = (a[0] >= b[0]) ? a[0] : b[0];
assign c[1] = (a[0] >  b[0]) ? b[0] : a[0];
assign c[2] = (b[1] >= b[2]) ? b[1] : b[2];
assign c[3] = (b[1] >  b[2]) ? b[2] : b[1];
assign c[4] = (b[3] >= b[4]) ? b[3] : b[4];
assign c[5] = (b[3] >  b[4]) ? b[4] : b[3];
assign c[6] = (b[5] >= b[6]) ? b[5] : b[6];
assign c[7] = (b[5] >  b[6]) ? b[6] : b[5];
assign c[8] = (b[7] >= a[9]) ? b[7] : a[9];
assign c[9] = (b[7] >  a[9]) ? a[9] : b[7];
//4
assign d[0] = (c[1] >= c[2]) ? c[1] : c[2];
assign d[1] = (c[1] >  c[2]) ? c[2] : c[1];
assign d[2] = (c[3] >= c[4]) ? c[3] : c[4];
assign d[3] = (c[3] >  c[4]) ? c[4] : c[3];
assign d[4] = (c[5] >= c[6]) ? c[5] : c[6];
assign d[5] = (c[5] >  c[6]) ? c[6] : c[5];
assign d[6] = (c[7] >= c[8]) ? c[7] : c[8];
assign d[7] = (c[7] >  c[8]) ? c[8] : c[7];
//5
assign e[0] = (c[0] >= d[0]) ? c[0] : d[0];
assign e[1] = (c[0] >  d[0]) ? d[0] : c[0];
assign e[2] = (d[1] >= d[2]) ? d[1] : d[2];
assign e[3] = (d[1] >  d[2]) ? d[2] : d[1];
assign e[4] = (d[3] >= d[4]) ? d[3] : d[4];
assign e[5] = (d[3] >  d[4]) ? d[4] : d[3];
assign e[6] = (d[5] >= d[6]) ? d[5] : d[6];
assign e[7] = (d[5] >  d[6]) ? d[6] : d[5];
assign e[8] = (d[7] >= c[9]) ? d[7] : c[9];
assign e[9] = (d[7] >  c[9]) ? c[9] : d[7];
//6
assign f[0] = (e[1] >= e[2]) ? e[1] : e[2];
assign f[1] = (e[1] >  e[2]) ? e[2] : e[1];
assign f[2] = (e[3] >= e[4]) ? e[3] : e[4];
assign f[3] = (e[3] >  e[4]) ? e[4] : e[3];
assign f[4] = (e[5] >= e[6]) ? e[5] : e[6];
assign f[5] = (e[5] >  e[6]) ? e[6] : e[5];
assign f[6] = (e[7] >= e[8]) ? e[7] : e[8];
assign f[7] = (e[7] >  e[8]) ? e[8] : e[7];
//7
assign g[0] = (e[0] >= f[0]) ? e[0] : f[0];
assign g[1] = (e[0] >  f[0]) ? f[0] : e[0];
assign g[2] = (f[1] >= f[2]) ? f[1] : f[2];
assign g[3] = (f[1] >  f[2]) ? f[2] : f[1];
assign g[4] = (f[3] >= f[4]) ? f[3] : f[4];
assign g[5] = (f[3] >  f[4]) ? f[4] : f[3];
assign g[6] = (f[5] >= f[6]) ? f[5] : f[6];
assign g[7] = (f[5] >  f[6]) ? f[6] : f[5];
assign g[8] = (f[7] >= e[9]) ? f[7] : e[9];
assign g[9] = (f[7] >  e[9]) ? e[9] : f[7];
//8
assign h[0] = (g[1] >= g[2]) ? g[1] : g[2];
assign h[1] = (g[1] >  g[2]) ? g[2] : g[1];
assign h[2] = (g[3] >= g[4]) ? g[3] : g[4];
assign h[3] = (g[3] >  g[4]) ? g[4] : g[3];
assign h[4] = (g[5] >= g[6]) ? g[5] : g[6];
assign h[5] = (g[5] >  g[6]) ? g[6] : g[5];
assign h[6] = (g[7] >= g[8]) ? g[7] : g[8];
assign h[7] = (g[7] >  g[8]) ? g[8] : g[7];
//9
assign i[0] = (g[0] >= h[0]) ? g[0] : h[0];
assign i[1] = (g[0] >  h[0]) ? h[0] : g[0];
assign i[2] = (h[1] >= h[2]) ? h[1] : h[2];
assign i[3] = (h[1] >  h[2]) ? h[2] : h[1];
assign i[4] = (h[3] >= h[4]) ? h[3] : h[4];
assign i[5] = (h[3] >  h[4]) ? h[4] : h[3];
assign i[6] = (h[5] >= h[6]) ? h[5] : h[6];
assign i[7] = (h[5] >  h[6]) ? h[6] : h[5];
assign i[8] = (h[7] >= g[9]) ? h[7] : g[9];
assign i[9] = (h[7] >  g[9]) ? g[9] : h[7];

assign max = i[0];

assign out = !en ? 'hz :(in0 == max) ? 'd0 : (in1 == max) ? 'd1 : (in2 == max) ? 'd2 : 
             (in3 == max) ? 'd3 : (in4 == max) ? 'd4 : (in5 == max) ? 'd5 : 
             (in6 == max) ? 'd6 : (in7 == max) ? 'd7 : (in8 == max) ? 'd8 :
             (in9 == max) ? 'd9 : 'hz;
// assign a[0] = ( in0>in1 ) ? in0 : in1 ;
// assign a[1] = ( in0>in1 ) ? in1 : in0 ;
// assign a[2] = ( a[1]>in2 )? a[1] : in2 ;
// assign a[3] = ( a[1]>in2 )? in2 : a[1] ;
// assign b[0] = ( a[0]>a[2] ) ? a[0] : a[2] ;
// assign b[1] = ( a[0]>a[2] ) ? a[2] : a[0] ;
// assign b[2] = a[3] ;
endmodule