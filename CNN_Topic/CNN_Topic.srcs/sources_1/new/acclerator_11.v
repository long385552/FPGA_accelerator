`timescale 1ns / 1ps
`define FIXED_POINT 1
module acclerator_11 #(
    parameter n = 9'd13,  //size of the input image/activation map
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
    input [(k*k)*16-1:0] weight_0,
    input [(k*k)*16-1:0] weight_1,
    input [(k*k)*16-1:0] weight_2,
    input [(k*k)*16-1:0] weight_3,
    input [(k*k)*16-1:0] weight_4,
    input [(k*k)*16-1:0] weight_5,
    input [(k*k)*16-1:0] weight_6,
    input [(k*k)*16-1:0] weight_7,
    
    output [N-1:0] conv_op_0,
    output [N-1:0] conv_op_1,
    output [N-1:0] conv_op_2,
    output [N-1:0] conv_op_3,
    output [N-1:0] conv_op_4,
    output [N-1:0] conv_op_5,
    output [N-1:0] conv_op_6,
    output [N-1:0] conv_op_7,
    output [N-1:0] conv_op_final,
    output conv_valid,
    output valid_pooler_ip,
    output [15:0] data_out,
    output valid_op,
    output [15:0] tm,
    output end_op,
    output conv_end,
    output relu_out
    );
    /*
    wire [N-1:0] conv_op_0;
    wire [N-1:0] conv_op_1;
    wire [N-1:0] conv_op_2;
    wire [N-1:0] conv_op_3;
    wire [N-1:0] conv_op_4;
    wire [N-1:0] conv_op_5;
    wire [N-1:0] conv_op_6;
    wire [N-1:0] conv_op_7;
    wire [N-1:0] conv_op_final;
    */
    wire valid_conv,end_conv;
    wire valid_ip;
    wire [N-1:0] relu_op;
    //wire [N-1:0] tanh_op;
    //wire [N-1:0] pooler_ip;
    wire [N-1:0] pooler_op;
    reg [N-1:0] pooler_op_reg;
    reg conv_ce;
    reg conv_ce_reg;
    /*
    always@(posedge clk)begin
        if(global_rst)begin
            conv_ce = 0;
            conv_ce_reg = 0;
        end
        else if()
    end
    */
    convolver #(.n(n),.k(k),.s(s),.N(N),.Q(Q)) conv_0(//Convolution engine
            .clk(clk), 
            .ce(ce), 
            .weight1(weight_0), 
            .global_rst(global_rst), 
            .activation(activation_0), 
            .conv_op(conv_op_0), 
            .end_conv(end_conv), 
            .valid_conv(valid_conv)
        );
        
    convolver #(.n(n),.k(k),.s(s),.N(N),.Q(Q)) conv_1(//Convolution engine
            .clk(clk), 
            .ce(ce), 
            .weight1(weight_1), 
            .global_rst(global_rst), 
            .activation(activation_1), 
            .conv_op(conv_op_1)
        );
        
    convolver #(.n(n),.k(k),.s(s),.N(N),.Q(Q)) conv_2(//Convolution engine
            .clk(clk), 
            .ce(ce), 
            .weight1(weight_2), 
            .global_rst(global_rst), 
            .activation(activation_2), 
            .conv_op(conv_op_2)
        );
        
    convolver #(.n(n),.k(k),.s(s),.N(N),.Q(Q)) conv_3(//Convolution engine
            .clk(clk), 
            .ce(ce), 
            .weight1(weight_3), 
            .global_rst(global_rst), 
            .activation(activation_3), 
            .conv_op(conv_op_3)
        );
        
    convolver #(.n(n),.k(k),.s(s),.N(N),.Q(Q)) conv_4(//Convolution engine
            .clk(clk), 
            .ce(ce), 
            .weight1(weight_4), 
            .global_rst(global_rst), 
            .activation(activation_4), 
            .conv_op(conv_op_4)
        );
        
    convolver #(.n(n),.k(k),.s(s),.N(N),.Q(Q)) conv_5(//Convolution engine
            .clk(clk), 
            .ce(ce), 
            .weight1(weight_5), 
            .global_rst(global_rst), 
            .activation(activation_5), 
            .conv_op(conv_op_5)
        );
        
    convolver #(.n(n),.k(k),.s(s),.N(N),.Q(Q)) conv_6(//Convolution engine
            .clk(clk), 
            .ce(ce), 
            .weight1(weight_6), 
            .global_rst(global_rst), 
            .activation(activation_6), 
            .conv_op(conv_op_6)
        );
        
    convolver #(.n(n),.k(k),.s(s),.N(N),.Q(Q)) conv_7(//Convolution engine
            .clk(clk), 
            .ce(ce), 
            .weight1(weight_7), 
            .global_rst(global_rst), 
            .activation(activation_7), 
            .conv_op(conv_op_7)
        );
        
    assign conv_op_final = conv_op_0 + conv_op_1 + conv_op_2 + conv_op_3 + conv_op_4 + conv_op_5 + conv_op_6 + conv_op_7;
    assign conv_valid = valid_conv;
    assign conv_end = end_conv;
    //assign conv_out = conv_op;
    
    assign valid_ip = valid_conv && (!end_conv);
    
    relu #(.N(N)) act(                             // ReLu Activation function
            .din_relu(conv_op_final),
            .dout_relu(relu_op)
        );
        
     assign relu_out = relu_op;
       /* 
    tanh_lut #(.AW(AW),.DW(DW),.N(N),.Q(Q)) tanh(  //Hyperbolic Tangent Activation function
            .clk(clk),
            .rst(global_rst),
            .phase(conv_op_final),
            .tanh(tanh_op)
        );
    
    assign pooler_ip = act_type ? tanh_op : relu_out; //alternatively you could use macros to save resources when using ReLu
    */
    reg [3:0] counter_r;
    reg [3:0] counter_c;
    
    always@(posedge clk)
    begin
        if(global_rst == 1) begin
            counter_c = 0;
            counter_r = 0;
        end
        else if(counter_c == 4'b1010 && valid_ip == 1) begin
            counter_c = 0;
            counter_r = counter_r + 1;
        end
        else if(valid_ip == 1) counter_c = counter_c + 1;
    end
    
    assign valid_pooler_ip = (counter_c == 4'b1010 || counter_r >= 4'b1010) ? 0 : valid_ip;
    
    pooler2 #(.N(N),.Q(Q),.m('d10),.p(p),.ptype(ptype),.p_sqr_inv(p_sqr_inv)) pool( //Pooling Unit pooler_KAI
            .clk(clk),
            .ce(valid_pooler_ip),
            .master_rst(global_rst),
            .data_in(relu_op),
            .data_out(pooler_op),
            .valid_op(valid_op),
            .tm(tm),
            .end_op(end_op)
        );

    assign data_out = pooler_op;
    
endmodule