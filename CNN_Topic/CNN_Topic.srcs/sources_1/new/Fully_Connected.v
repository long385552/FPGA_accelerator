`timescale 1ns / 1ps
`define FIXED_POINT 1

module Fully_Connected(
    input clk,
    input global_rst,
    input ce,
    input [15:0] activation_0,
    input [15:0] activation_1,
    input [15:0] activation_2,
    input [15:0] activation_3,
    input [15:0] activation_4,
    input [15:0] activation_5,
    input [15:0] activation_6,
    input [15:0] activation_7,
    input [15:0] weight_0,
    input [15:0] weight_1,
    input [15:0] weight_2,
    input [15:0] weight_3,
    input [15:0] weight_4,
    input [15:0] weight_5,
    input [15:0] weight_6,
    input [15:0] weight_7,
    output [15:0] data_out,
    output reg [4:0] count,
    output end_out
    );
    reg [15:0] halfway_reg_0;
    reg [15:0] halfway_reg_1;
    reg [15:0] halfway_reg_2;
    reg [15:0] halfway_reg_3;
    reg [15:0] halfway_reg_4;
    reg [15:0] halfway_reg_5;
    reg [15:0] halfway_reg_6;
    reg [15:0] halfway_reg_7;

    wire [15:0] mult_result_0;
    wire [15:0] mult_result_1;
    wire [15:0] mult_result_2;
    wire [15:0] mult_result_3;
    wire [15:0] mult_result_4;
    wire [15:0] mult_result_5;
    wire [15:0] mult_result_6;
    wire [15:0] mult_result_7;

    wire [15:0] add_result_0;
    wire [15:0] add_result_1;
    wire [15:0] add_result_2;
    wire [15:0] add_result_3;
    wire [15:0] add_result_4;
    wire [15:0] add_result_5;
    wire [15:0] add_result_6;
    wire [15:0] add_result_7;
//00000000000000000000000000000000000
    qmult mult_0(
                .clk(clk),
                .rst(global_rst),
                .a(activation_0),
                .b(weight_0),
                .q_result(mult_result_0)
                );
    qadd add_0(
                .a(mult_result_0),
                .b(halfway_reg_0),
                .c(add_result_0)
                );
//1111111111111111111111111111111111
    qmult mult_1(
                .clk(clk),
                .rst(global_rst),
                .a(activation_1),
                .b(weight_1),
                .q_result(mult_result_1)
                );
    qadd add_1(
                .a(mult_result_1),
                .b(halfway_reg_1),
                .c(add_result_1)
                );
//22222222222222222222222222222222222
    qmult mult_2(
                .clk(clk),
                .rst(global_rst),
                .a(activation_2),
                .b(weight_2),
                .q_result(mult_result_2)
                );
    qadd add_2(
                .a(mult_result_2),
                .b(halfway_reg_2),
                .c(add_result_2)
                );
//333333333333333333333333333333333333
    qmult mult_3(
                .clk(clk),
                .rst(global_rst),
                .a(activation_3),
                .b(weight_3),
                .q_result(mult_result_3)
                );
    qadd add_3(
                .a(mult_result_3),
                .b(halfway_reg_3),
                .c(add_result_3)
                );
//44444444444444444444444444444444444
    qmult mult_4(
                .clk(clk),
                .rst(global_rst),
                .a(activation_4),
                .b(weight_4),
                .q_result(mult_result_4)
                );
    qadd add_4(
                .a(mult_result_4),
                .b(halfway_reg_4),
                .c(add_result_4)
                );
//55555555555555555555555555555555555
    qmult mult_5(
                .clk(clk),
                .rst(global_rst),
                .a(activation_5),
                .b(weight_5),
                .q_result(mult_result_5)
                );
    qadd add_5(
                .a(mult_result_5),
                .b(halfway_reg_5),
                .c(add_result_5)
                );
//6
    qmult mult_6(
                .clk(clk),
                .rst(global_rst),
                .a(activation_6),
                .b(weight_6),
                .q_result(mult_result_6)
                );
    qadd add_6(
                .a(mult_result_6),
                .b(halfway_reg_6),
                .c(add_result_6)
                );
//7
    qmult mult_7(
                .clk(clk),
                .rst(global_rst),
                .a(activation_7),
                .b(weight_7),
                .q_result(mult_result_7)
                );
    qadd add_7(
                .a(mult_result_7),
                .b(halfway_reg_7),
                .c(add_result_7)
                );  

    always@(posedge clk)begin
        if (global_rst) begin
            halfway_reg_0 <=16'h0000;
            halfway_reg_1 <=16'h0000;
            halfway_reg_2 <=16'h0000;
            halfway_reg_3 <=16'h0000;
            halfway_reg_4 <=16'h0000;
            halfway_reg_5 <=16'h0000;
            halfway_reg_6 <=16'h0000;
            halfway_reg_7 <=16'h0000;
            count         <= 'd0;
        end 
        else if (ce) begin
            halfway_reg_0 <= add_result_0;
            halfway_reg_1 <= add_result_1;
            halfway_reg_2 <= add_result_2;
            halfway_reg_3 <= add_result_3;
            halfway_reg_4 <= add_result_4;
            halfway_reg_5 <= add_result_5;
            halfway_reg_6 <= add_result_6;
            halfway_reg_7 <= add_result_7;
            count         <= count + 1'b1;
        end 
    end
    assign end_out  = (count >= 'd25) ? 1'b1 : 1'b0;
    assign data_out = halfway_reg_0 + halfway_reg_1 + halfway_reg_2 + halfway_reg_3 +
                      halfway_reg_4 + halfway_reg_5 + halfway_reg_6 + halfway_reg_7;
endmodule
