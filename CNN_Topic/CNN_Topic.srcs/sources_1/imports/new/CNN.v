`timescale 1ns / 1ps
`define FIXED_POINT 1
module CNN#(
    parameter n = 9'd28,  //size of the input image/activation map
    parameter k = 9'h003,  //size of the convolution window
    parameter p = 9'h002,  //size of the pooling window
    parameter s = 1,       //stride value during convolution
    parameter ptype = 1,  //0 => average pooling , 1 => max_pooling
    parameter act_type = 0,//0 => ReLu activation function, 1=> Hyperbolic tangent activation function
    parameter N = 16,     //Bit width of activations and weights (total datapath width)
    parameter Q = 8,     //Number of fractional bits in case of fixed point representation
    parameter AW = 10,    //Needed in case of tanh activation function to set the size or ROM
    parameter DW = 16,    //Datapath width = N 
    parameter p_sqr_inv = 16'b0000010000000000 // = 1/p**2 in the (N,Q) format being used currently
    )(
    input clk,
    input clk_ram,
    input global_rst,
    input ce,
    input [15:0] activation,
    input [(k*k)*16-1:0] weight1_0,
    input [(k*k)*16-1:0] weight1_1,
    input [(k*k)*16-1:0] weight1_2,
    input [(k*k)*16-1:0] weight1_3,
    input [(k*k)*16-1:0] weight1_4,
    input [(k*k)*16-1:0] weight1_5,
    input [(k*k)*16-1:0] weight1_6,
    input [(k*k)*16-1:0] weight1_7,
    output [15:0] acclerator_out_0,
    output [15:0] acclerator_out_1,
    output [15:0] acclerator_out_2,
    output [15:0] acclerator_out_3,
    output [15:0] acclerator_out_4,
    output [15:0] acclerator_out_5,
    output [15:0] acclerator_out_6,
    output [15:0] acclerator_out_7,
    output valid_op,
    output end_op,
    output [15:0] conv_out_0,
    output [15:0] conv_out_1,
    output [15:0] conv_out_2,
    output [15:0] conv_out_3,
    output [15:0] conv_out_4,
    output [15:0] conv_out_5,
    output [15:0] conv_out_6,
    output [15:0] conv_out_7,
    output conv_valid,
    output conv_end,
    output [15:0] relu_out,
    
    output [15:0] acclerator_1_out_0,
    output [15:0] acclerator_1_out_1,
    output [15:0] acclerator_1_out_2,
    output [15:0] acclerator_1_out_3,
    output [15:0] acclerator_1_out_4,
    output [15:0] acclerator_1_out_5,
    output [15:0] acclerator_1_out_6,
    output [15:0] acclerator_1_out_7,
    output acclerator_1_valid_op,
    output acclerator_1_valid_end,
    output [16:0] tm,
    output [15:0] fc_out_0,
    output [15:0] fc_out_1,
    output [15:0] fc_out_2,
    output [15:0] fc_out_3,
    output [15:0] fc_out_4,
    output [15:0] fc_out_5,
    output [15:0] fc_out_6,
    output [15:0] fc_out_7,
    output [15:0] fc_out_8,
    output [15:0] fc_out_9,
    output fc_end_out,
    output [4:0] fc_count,
    
    
    output [N-1:0] acclerator_1_conv_op_0,
    output [N-1:0] acclerator_1_conv_op_1,
    output [N-1:0] acclerator_1_conv_op_2,
    output [N-1:0] acclerator_1_conv_op_3,
    output [N-1:0] acclerator_1_conv_op_4,
    output [N-1:0] acclerator_1_conv_op_5,
    output [N-1:0] acclerator_1_conv_op_6,
    output [N-1:0] acclerator_1_conv_op_7,
    output [N-1:0] acclerator_1_conv_op_final,
    output acclerator_1_conv_valid,
    output acclerator_1_valid_pooler_ip,
    output [3:0] number_1st,
    output [3:0] number_2st,
    output [3:0] number_3st
    );
    /*
    wire [N-1:0] fc_weight_0_0, fc_weight_0_1, fc_weight_0_2, fc_weight_0_3, fc_weight_0_4, fc_weight_0_5, fc_weight_0_6, fc_weight_0_7, 
                 fc_weight_1_0, fc_weight_1_1, fc_weight_1_2, fc_weight_1_3, fc_weight_1_4, fc_weight_1_5, fc_weight_1_6, fc_weight_1_7, 
                 fc_weight_2_0, fc_weight_2_1, fc_weight_0_2, fc_weight_0_3, fc_weight_0_4, fc_weight_0_5, fc_weight_0_6, fc_weight_0_7, 
                 fc_weight_3_0, fc_weight_3_1, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, 
                 fc_weight_4_0, fc_weight_4_1, fc_weight_0_2, fc_weight_0_3, fc_weight_0_4, fc_weight_0_5, fc_weight_0_6, fc_weight_0_7, 
                 fc_weight_5_0, fc_weight_5_1, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, 
                 fc_weight_6_0, fc_weight_6_1, fc_weight_0_2, fc_weight_0_3, fc_weight_0_4, fc_weight_0_5, fc_weight_0_6, fc_weight_0_7, 
                 fc_weight_7_0, fc_weight_7_1, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, 
                 fc_weight_8_0, fc_weight_8_1, fc_weight_0_2, fc_weight_0_3, fc_weight_0_4, fc_weight_0_5, fc_weight_0_6, fc_weight_0_7, 
                 fc_weight_9_0, fc_weight_9_1, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0, fc_weight_1_0;
     */
    acclerator #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) acclerator_0_0 (
		.clk(clk), 
		.ce(ce), 
		.weight1(weight1_0),
		.global_rst(global_rst), 
		.activation(activation), 
		.data_out(acclerator_out_0),
		.valid_op(valid_op), 
		.end_op(end_op),
		.conv_out(conv_out_0),
		.conv_valid(conv_valid),
		.conv_end(conv_end),
		.relu_out(relu_out)
	);
	
	acclerator #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) acclerator_0_1 (
		.clk(clk), 
		.ce(ce), 
		.weight1(weight1_1),
		.global_rst(global_rst), 
		.activation(activation), 
		.data_out(acclerator_out_1),
		.conv_out(conv_out_1)
	);
	acclerator #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) acclerator_0_2 (
		.clk(clk),
		.ce(ce),
		.weight1(weight1_2),
		.global_rst(global_rst),
		.activation(activation),
		.data_out(acclerator_out_2),
		.conv_out(conv_out_2)
	);
	acclerator #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) acclerator_0_3 (
		.clk(clk),
		.ce(ce),
		.weight1(weight1_3),
		.global_rst(global_rst), 
		.activation(activation), 
		.data_out(acclerator_out_3),
		.conv_out(conv_out_3)
	);
	acclerator #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) acclerator_0_4 (
		.clk(clk), 
		.ce(ce), 
		.weight1(weight1_4),
		.global_rst(global_rst), 
		.activation(activation), 
		.data_out(acclerator_out_4),
		.conv_out(conv_out_4)
	);
	acclerator #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) acclerator_0_5 (
		.clk(clk), 
		.ce(ce), 
		.weight1(weight1_5),
		.global_rst(global_rst), 
		.activation(activation), 
		.data_out(acclerator_out_5),
		.conv_out(conv_out_5)
	);
	acclerator #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) acclerator_0_6 (
		.clk(clk), 
		.ce(ce), 
		.weight1(weight1_6),
		.global_rst(global_rst), 
		.activation(activation), 
		.data_out(acclerator_out_6),
		.conv_out(conv_out_6)
	);
	acclerator #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) acclerator_0_7 (
		.clk(clk), 
		.ce(ce), 
		.weight1(weight1_7),
		.global_rst(global_rst), 
		.activation(activation), 
		.data_out(acclerator_out_7),
		.conv_out(conv_out_7)
	);
	
	acclerator_1 #(.n(9'd13),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(valid_op), 
		.activation_0(acclerator_out_0), 
		.activation_1(acclerator_out_1), 
		.activation_2(acclerator_out_2), 
		.activation_3(acclerator_out_3), 
		.activation_4(acclerator_out_4), 
		.activation_5(acclerator_out_5), 
		.activation_6(acclerator_out_6), 
		.activation_7(acclerator_out_7), 
		
		.conv_op_0(acclerator_1_conv_op_0),
		.conv_op_1(acclerator_1_conv_op_1),
		.conv_op_2(acclerator_1_conv_op_2),
		.conv_op_3(acclerator_1_conv_op_3),
		.conv_op_4(acclerator_1_conv_op_4),
		.conv_op_5(acclerator_1_conv_op_5),
		.conv_op_6(acclerator_1_conv_op_6),
		.conv_op_7(acclerator_1_conv_op_7),
		.conv_op_final(acclerator_1_conv_op_final),
		.conv_valid(acclerator_1_conv_valid),
		
		.data_out_0(acclerator_1_out_0),
		.data_out_1(acclerator_1_out_1),
		.data_out_2(acclerator_1_out_2),
		.data_out_3(acclerator_1_out_3),
		.data_out_4(acclerator_1_out_4),
		.data_out_5(acclerator_1_out_5),
		.data_out_6(acclerator_1_out_6),
		.data_out_7(acclerator_1_out_7),
		.valid_pooler_ip(acclerator_1_valid_pooler_ip),
		.tm(tm),
		.valid_op(acclerator_1_valid_op), 
		.end_op(acclerator_1_valid_end)
	);

        reg [4:0] fc_addra;
        always @(posedge clk) begin
                if(global_rst) fc_addra <= 'd0;
                else if(acclerator_1_valid_op) fc_addra <= fc_addra + 1'b1;
                else fc_addra <= fc_addra;
        end

        wire [1279:0] dout_a;
	Fully_Connected_bram fc_weight(.clka(clk_ram), .addra(fc_addra), .douta(dout_a)); //douta = 1280 bits
	wire [15:0]     fc_weight_0_0 = dout_a[1279:1264],
                        fc_weight_0_1 = dout_a[1263:1248],
                        fc_weight_0_2 = dout_a[1247:1232],
                        fc_weight_0_3 = dout_a[1231:1216],
                        fc_weight_0_4 = dout_a[1215:1200],
                        fc_weight_0_5 = dout_a[1199:1184],
                        fc_weight_0_6 = dout_a[1183:1168],
                        fc_weight_0_7 = dout_a[1167:1152];  
	Fully_Connected Fully_Connected_0(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_0_0),
        .weight_1(fc_weight_0_1),
        .weight_2(fc_weight_0_2),
        .weight_3(fc_weight_0_3),
        .weight_4(fc_weight_0_4),
        .weight_5(fc_weight_0_5),
        .weight_6(fc_weight_0_6),
        .weight_7(fc_weight_0_7),
        .data_out(fc_out_0),
        .end_out(fc_end_out),
        .count(fc_count)
	   );

        wire [15:0]     fc_weight_1_0 = dout_a[1151:1136],
                        fc_weight_1_1 = dout_a[1135:1120],
                        fc_weight_1_2 = dout_a[1119:1104],
                        fc_weight_1_3 = dout_a[1103:1088],
                        fc_weight_1_4 = dout_a[1087:1072],
                        fc_weight_1_5 = dout_a[1071:1056],
                        fc_weight_1_6 = dout_a[1055:1040],
                        fc_weight_1_7 = dout_a[1039:1024];  
	Fully_Connected Fully_Connected_1(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_1_0),
        .weight_1(fc_weight_1_1),
        .weight_2(fc_weight_1_2),
        .weight_3(fc_weight_1_3),
        .weight_4(fc_weight_1_4),
        .weight_5(fc_weight_1_5),
        .weight_6(fc_weight_1_6),
        .weight_7(fc_weight_1_7),
        .data_out(fc_out_1)
	   );

        wire [15:0]     fc_weight_2_0 = dout_a[1023:1008],
                        fc_weight_2_1 = dout_a[1007:992],
                        fc_weight_2_2 = dout_a[991:976],
                        fc_weight_2_3 = dout_a[975:960],
                        fc_weight_2_4 = dout_a[959:944],
                        fc_weight_2_5 = dout_a[943:928],
                        fc_weight_2_6 = dout_a[927:912],
                        fc_weight_2_7 = dout_a[911:896];
	Fully_Connected Fully_Connected_2(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_2_0),
        .weight_1(fc_weight_2_1),
        .weight_2(fc_weight_2_2),
        .weight_3(fc_weight_2_3),
        .weight_4(fc_weight_2_4),
        .weight_5(fc_weight_2_5),
        .weight_6(fc_weight_2_6),
        .weight_7(fc_weight_2_7),
        .data_out(fc_out_2)
	   );

        wire [15:0]     fc_weight_3_0 = dout_a[895:880],
                        fc_weight_3_1 = dout_a[879:864],
                        fc_weight_3_2 = dout_a[863:848],
                        fc_weight_3_3 = dout_a[847:832],
                        fc_weight_3_4 = dout_a[831:816],
                        fc_weight_3_5 = dout_a[815:800],
                        fc_weight_3_6 = dout_a[799:784],
                        fc_weight_3_7 = dout_a[783:768];  
	Fully_Connected Fully_Connected_3(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_3_0),
        .weight_1(fc_weight_3_1),
        .weight_2(fc_weight_3_2),
        .weight_3(fc_weight_3_3),
        .weight_4(fc_weight_3_4),
        .weight_5(fc_weight_3_5),
        .weight_6(fc_weight_3_6),
        .weight_7(fc_weight_3_7),
        .data_out(fc_out_3)
	   );

        wire [15:0]     fc_weight_4_0 = dout_a[767:752],
                        fc_weight_4_1 = dout_a[751:736],
                        fc_weight_4_2 = dout_a[735:720],
                        fc_weight_4_3 = dout_a[719:704],
                        fc_weight_4_4 = dout_a[703:688],
                        fc_weight_4_5 = dout_a[687:672],
                        fc_weight_4_6 = dout_a[671:656],
                        fc_weight_4_7 = dout_a[655:640]; 
	Fully_Connected Fully_Connected_4(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_4_0),
        .weight_1(fc_weight_4_1),
        .weight_2(fc_weight_4_2),
        .weight_3(fc_weight_4_3),
        .weight_4(fc_weight_4_4),
        .weight_5(fc_weight_4_5),
        .weight_6(fc_weight_4_6),
        .weight_7(fc_weight_4_7),
        .data_out(fc_out_4)
	   );

        wire [15:0]     fc_weight_5_0 = dout_a[639:624],
                        fc_weight_5_1 = dout_a[623:608],
                        fc_weight_5_2 = dout_a[607:592],
                        fc_weight_5_3 = dout_a[591:576],
                        fc_weight_5_4 = dout_a[575:560],
                        fc_weight_5_5 = dout_a[559:544],
                        fc_weight_5_6 = dout_a[543:528],
                        fc_weight_5_7 = dout_a[527:512];  
	Fully_Connected Fully_Connected_5(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_5_0),
        .weight_1(fc_weight_5_1),
        .weight_2(fc_weight_5_2),
        .weight_3(fc_weight_5_3),
        .weight_4(fc_weight_5_4),
        .weight_5(fc_weight_5_5),
        .weight_6(fc_weight_5_6),
        .weight_7(fc_weight_5_7),
        .data_out(fc_out_5)
	   );

        wire [15:0]     fc_weight_6_0 = dout_a[511:496],
                        fc_weight_6_1 = dout_a[495:480],
                        fc_weight_6_2 = dout_a[479:464],
                        fc_weight_6_3 = dout_a[463:448],
                        fc_weight_6_4 = dout_a[447:432],
                        fc_weight_6_5 = dout_a[431:416],
                        fc_weight_6_6 = dout_a[415:400],
                        fc_weight_6_7 = dout_a[399:384];
	Fully_Connected Fully_Connected_6(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_6_0),
        .weight_1(fc_weight_6_1),
        .weight_2(fc_weight_6_2),
        .weight_3(fc_weight_6_3),
        .weight_4(fc_weight_6_4),
        .weight_5(fc_weight_6_5),
        .weight_6(fc_weight_6_6),
        .weight_7(fc_weight_6_7),
        .data_out(fc_out_6)
	   );

        wire [15:0]     fc_weight_7_0 = dout_a[383:368],
                        fc_weight_7_1 = dout_a[367:352],
                        fc_weight_7_2 = dout_a[351:336],
                        fc_weight_7_3 = dout_a[335:320],
                        fc_weight_7_4 = dout_a[319:304],
                        fc_weight_7_5 = dout_a[303:288],
                        fc_weight_7_6 = dout_a[287:272],
                        fc_weight_7_7 = dout_a[271:256];  
	Fully_Connected Fully_Connected_7(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_7_0),
        .weight_1(fc_weight_7_1),
        .weight_2(fc_weight_7_2),
        .weight_3(fc_weight_7_3),
        .weight_4(fc_weight_7_4),
        .weight_5(fc_weight_7_5),
        .weight_6(fc_weight_7_6),
        .weight_7(fc_weight_7_7),
        .data_out(fc_out_7)
	   );

        wire [15:0]     fc_weight_8_0 = dout_a[255:240],
                        fc_weight_8_1 = dout_a[239:224],
                        fc_weight_8_2 = dout_a[223:208],
                        fc_weight_8_3 = dout_a[207:192],
                        fc_weight_8_4 = dout_a[191:176],
                        fc_weight_8_5 = dout_a[175:160],
                        fc_weight_8_6 = dout_a[159:144],
                        fc_weight_8_7 = dout_a[143:128];  
	Fully_Connected Fully_Connected_8(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_8_0),
        .weight_1(fc_weight_8_1),
        .weight_2(fc_weight_8_2),
        .weight_3(fc_weight_8_3),
        .weight_4(fc_weight_8_4),
        .weight_5(fc_weight_8_5),
        .weight_6(fc_weight_8_6),
        .weight_7(fc_weight_8_7),
        .data_out(fc_out_8)

	   );

        wire [15:0]     fc_weight_9_0 = dout_a[127:112],
                        fc_weight_9_1 = dout_a[111:96],
                        fc_weight_9_2 = dout_a[95:80],
                        fc_weight_9_3 = dout_a[79:64],
                        fc_weight_9_4 = dout_a[63:48],
                        fc_weight_9_5 = dout_a[47:32],
                        fc_weight_9_6 = dout_a[31:16],
                        fc_weight_9_7 = dout_a[15:0];  
	Fully_Connected Fully_Connected_9(
        .clk(clk), 
        .global_rst(global_rst),
        .ce(acclerator_1_valid_op), 
        .activation_0(acclerator_1_out_0),
        .activation_1(acclerator_1_out_1),
        .activation_2(acclerator_1_out_2),
        .activation_3(acclerator_1_out_3),
        .activation_4(acclerator_1_out_4),
        .activation_5(acclerator_1_out_5),
        .activation_6(acclerator_1_out_6),
        .activation_7(acclerator_1_out_7),
        .weight_0(fc_weight_9_0),
        .weight_1(fc_weight_9_1),
        .weight_2(fc_weight_9_2),
        .weight_3(fc_weight_9_3),
        .weight_4(fc_weight_9_4),
        .weight_5(fc_weight_9_5),
        .weight_6(fc_weight_9_6),
        .weight_7(fc_weight_9_7),
        .data_out(fc_out_9)
	   );

        sort u1(.in0(fc_out_0),
                .in1(fc_out_1),
                .in2(fc_out_2),
                .in3(fc_out_3),
                .in4(fc_out_4),
                .in5(fc_out_5),
                .in6(fc_out_6),
                .in7(fc_out_7),
                .in8(fc_out_8),
                .in9(fc_out_9),
                .en(fc_end_out),
                .number_1st(number_1st),
                .number_2st(number_2st),
                .number_3st(number_3st)
                );
endmodule
