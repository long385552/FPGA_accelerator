`timescale 1ns / 1ps
`define FIXED_POINT 1
module CNN_tb;

	// Inputs
	reg clk;
	reg clk_ram;
	reg ce;
	reg [143:0] weight1_0;
	reg [143:0] weight1_1;
	reg [143:0] weight1_2;
	reg [143:0] weight1_3;
	reg [143:0] weight1_4;
	reg [143:0] weight1_5;
	reg [143:0] weight1_6;
	reg [143:0] weight1_7;
	reg global_rst;
	reg [15:0] activation;
    reg [9:0] addra;
    // reg [4:0] fc_addra;
	// Outputs
	wire [15:0] acclerator_out_0;
	wire [15:0] acclerator_out_1;
	wire [15:0] acclerator_out_2;
	wire [15:0] acclerator_out_3;
	wire [15:0] acclerator_out_4;
	wire [15:0] acclerator_out_5;
	wire [15:0] acclerator_out_6;
	wire [15:0] acclerator_out_7;
	wire [15:0] conv_out_0;
	wire [15:0] conv_out_1;
	wire [15:0] conv_out_2;
	wire [15:0] conv_out_3;
	wire [15:0] conv_out_4;
	wire [15:0] conv_out_5;
	wire [15:0] conv_out_6;
	wire [15:0] conv_out_7;
	wire [15:0] relu_out;
	
	wire [15:0] acclerator_1_out_0;
	wire [15:0] acclerator_1_out_1;
	wire [15:0] acclerator_1_out_2;
	wire [15:0] acclerator_1_out_3;
	wire [15:0] acclerator_1_out_4;
	wire [15:0] acclerator_1_out_5;
	wire [15:0] acclerator_1_out_6;
	wire [15:0] acclerator_1_out_7;
	wire acclerator_1_valid_op;
    wire acclerator_1_valid_end;
	
	wire [15:0] acclerator_1_conv_op_0;
    wire [15:0] acclerator_1_conv_op_1;
    wire [15:0] acclerator_1_conv_op_2;
    wire [15:0] acclerator_1_conv_op_3;
    wire [15:0] acclerator_1_conv_op_4;
    wire [15:0] acclerator_1_conv_op_5;
    wire [15:0] acclerator_1_conv_op_6;
    wire [15:0] acclerator_1_conv_op_7;
    wire [15:0] acclerator_1_conv_op_final;
    wire acclerator_1_conv_valid;
    wire acclerator_1_valid_pooler_ip;
    wire [15:0]tm;
	/*
	wire [15:0] fc_weight_0_0, fc_weight_0_1, fc_weight_0_2, fc_weight_0_3,
 				fc_weight_0_4, fc_weight_0_5, fc_weight_0_6, fc_weight_0_7;
 	wire [15:0] fc_weight_1_0, fc_weight_1_1, fc_weight_1_2, fc_weight_1_3,
 				fc_weight_1_4, fc_weight_1_5, fc_weight_1_6, fc_weight_1_7;
	wire [15:0] fc_weight_2_0, fc_weight_2_1, fc_weight_2_2, fc_weight_2_3,
 				fc_weight_2_4, fc_weight_2_5, fc_weight_2_6, fc_weight_2_7;
	wire [15:0] fc_weight_3_0, fc_weight_3_1, fc_weight_3_2, fc_weight_3_3,
 				fc_weight_3_4, fc_weight_3_5, fc_weight_3_6, fc_weight_3_7;
	wire [15:0] fc_weight_4_0, fc_weight_4_1, fc_weight_4_2, fc_weight_4_3,
 				fc_weight_4_4, fc_weight_4_5, fc_weight_4_6, fc_weight_4_7;
	wire [15:0] fc_weight_5_0, fc_weight_5_1, fc_weight_5_2, fc_weight_5_3,
 				fc_weight_5_4, fc_weight_5_5, fc_weight_5_6, fc_weight_5_7;
	wire [15:0] fc_weight_6_0, fc_weight_6_1, fc_weight_6_2, fc_weight_6_3,
 				fc_weight_6_4, fc_weight_6_5, fc_weight_6_6, fc_weight_6_7;
	wire [15:0] fc_weight_7_0, fc_weight_7_1, fc_weight_7_2, fc_weight_7_3,
 				fc_weight_7_4, fc_weight_7_5, fc_weight_7_6, fc_weight_7_7;
	wire [15:0] fc_weight_8_0, fc_weight_8_1, fc_weight_8_2, fc_weight_8_3,
 				fc_weight_8_4, fc_weight_8_5, fc_weight_8_6, fc_weight_8_7;
	wire [15:0] fc_weight_9_0, fc_weight_9_1, fc_weight_9_2, fc_weight_9_3,
 				fc_weight_9_4, fc_weight_9_5, fc_weight_9_6, fc_weight_9_7;
*/
	wire [15:0] fc_out_0;
	wire [15:0] fc_out_1;
	wire [15:0] fc_out_2;
	wire [15:0] fc_out_3;
	wire [15:0] fc_out_4;
	wire [15:0] fc_out_5;
	wire [15:0] fc_out_6;
	wire [15:0] fc_out_7;
	wire [15:0] fc_out_8;
	wire [15:0] fc_out_9;
	wire [4:0]  fc_count;
	wire fc_end_out;
	wire conv_valid,conv_end;
	wire end_op;
	wire valid_op;
	wire [15:0] douta;
	integer i;
	integer j;
    parameter clkp = 20;

	// Instantiate the Unit Under Test (UUT)
	CNN #(.n('d28),.p('d2),.k('d3),.N('d16),.Q('d8),.ptype('d1),.s('d1),.p_sqr_inv(16'b0000010000000000)) uut (
		.clk(clk), 
		.clk_ram(clk_ram), 
		.ce(ce), 
		.weight1_0(weight1_0), 
		.weight1_1(weight1_1), 
		.weight1_2(weight1_2), 
		.weight1_3(weight1_3), 
		.weight1_4(weight1_4), 
		.weight1_5(weight1_5), 
		.weight1_6(weight1_6), 
		.weight1_7(weight1_7), 
		.global_rst(global_rst), 
		.activation(activation), 
		.acclerator_out_0(acclerator_out_0), 
		.acclerator_out_1(acclerator_out_1), 
		.acclerator_out_2(acclerator_out_2), 
		.acclerator_out_3(acclerator_out_3), 
		.acclerator_out_4(acclerator_out_4), 
		.acclerator_out_5(acclerator_out_5), 
		.acclerator_out_6(acclerator_out_6), 
		.acclerator_out_7(acclerator_out_7), 
		.valid_op(valid_op), 
		.end_op(end_op),
		.conv_out_0(conv_out_0),
		.conv_out_1(conv_out_1),
		.conv_out_2(conv_out_2),
		.conv_out_3(conv_out_3),
		.conv_out_4(conv_out_4),
		.conv_out_5(conv_out_5),
		.conv_out_6(conv_out_6),
		.conv_out_7(conv_out_7),
		.conv_valid(conv_valid),
		.conv_end(conv_end),
		.relu_out(relu_out),
		
		.acclerator_1_out_0(acclerator_1_out_0), 
		.acclerator_1_out_1(acclerator_1_out_1), 
		.acclerator_1_out_2(acclerator_1_out_2), 
		.acclerator_1_out_3(acclerator_1_out_3), 
		.acclerator_1_out_4(acclerator_1_out_4), 
		.acclerator_1_out_5(acclerator_1_out_5), 
		.acclerator_1_out_6(acclerator_1_out_6), 
		.acclerator_1_out_7(acclerator_1_out_7), 
		.acclerator_1_valid_op(acclerator_1_valid_op),
        .acclerator_1_valid_end(acclerator_1_valid_end),
        
        .acclerator_1_conv_op_0(acclerator_1_conv_op_0),
		.acclerator_1_conv_op_1(acclerator_1_conv_op_1),
		.acclerator_1_conv_op_2(acclerator_1_conv_op_2),
		.acclerator_1_conv_op_3(acclerator_1_conv_op_3),
		.acclerator_1_conv_op_4(acclerator_1_conv_op_4),
		.acclerator_1_conv_op_5(acclerator_1_conv_op_5),
		.acclerator_1_conv_op_6(acclerator_1_conv_op_6),
		.acclerator_1_conv_op_7(acclerator_1_conv_op_7),
		.acclerator_1_conv_op_final(acclerator_1_conv_op_final),
		.acclerator_1_conv_valid(acclerator_1_conv_valid),
        .acclerator_1_valid_pooler_ip(acclerator_1_valid_pooler_ip),
        .tm(tm),
        /*
		.fc_weight_0_0(fc_weight_0_0),
        .fc_weight_0_1(fc_weight_0_1),
        .fc_weight_0_2(fc_weight_0_2),
        .fc_weight_0_3(fc_weight_0_3),
        .fc_weight_0_4(fc_weight_0_4),
        .fc_weight_0_5(fc_weight_0_5),
		.fc_weight_0_6(fc_weight_0_6),
        .fc_weight_0_7(fc_weight_0_7),
		*/
		.fc_out_0(fc_out_0),
		/*
		.fc_weight_1_0(fc_weight_1_0),
        .fc_weight_1_1(fc_weight_1_1),
        .fc_weight_1_2(fc_weight_1_2),
		.fc_weight_1_3(fc_weight_1_3),
		.fc_weight_1_4(fc_weight_1_4),
		.fc_weight_1_5(fc_weight_1_5),
		.fc_weight_1_6(fc_weight_1_6),
		.fc_weight_1_7(fc_weight_1_7),
		.fc_weight_2_0(fc_weight_2_0),
        .fc_weight_2_1(fc_weight_2_1),
        .fc_weight_2_2(fc_weight_2_2),
		.fc_weight_2_3(fc_weight_2_3),
		.fc_weight_2_4(fc_weight_2_4),
		.fc_weight_2_5(fc_weight_2_5),
		.fc_weight_2_6(fc_weight_2_6),
		.fc_weight_2_7(fc_weight_2_7),
		.fc_weight_3_0(fc_weight_3_0),
        .fc_weight_3_1(fc_weight_3_1),
        .fc_weight_3_2(fc_weight_3_2),
		.fc_weight_3_3(fc_weight_3_3),
		.fc_weight_3_4(fc_weight_3_4),
		.fc_weight_3_5(fc_weight_3_5),
		.fc_weight_3_6(fc_weight_3_6),
		.fc_weight_3_7(fc_weight_3_7),
		.fc_weight_4_0(fc_weight_4_0),
        .fc_weight_4_1(fc_weight_4_1),
        .fc_weight_4_2(fc_weight_4_2),
		.fc_weight_4_3(fc_weight_4_3),
		.fc_weight_4_4(fc_weight_4_4),
		.fc_weight_4_5(fc_weight_4_5),
		.fc_weight_4_6(fc_weight_4_6),
		.fc_weight_4_7(fc_weight_4_7),
		.fc_weight_5_0(fc_weight_5_0),
        .fc_weight_5_1(fc_weight_5_1),
        .fc_weight_5_2(fc_weight_5_2),
		.fc_weight_5_3(fc_weight_5_3),
		.fc_weight_5_4(fc_weight_5_4),
		.fc_weight_5_5(fc_weight_5_5),
		.fc_weight_5_6(fc_weight_5_6),
		.fc_weight_5_7(fc_weight_5_7),
		.fc_weight_6_0(fc_weight_6_0),
        .fc_weight_6_1(fc_weight_6_1),
        .fc_weight_6_2(fc_weight_6_2),
		.fc_weight_6_3(fc_weight_6_3),
		.fc_weight_6_4(fc_weight_6_4),
		.fc_weight_6_5(fc_weight_6_5),
		.fc_weight_6_6(fc_weight_6_6),
		.fc_weight_6_7(fc_weight_6_7),
		.fc_weight_7_0(fc_weight_7_0),
        .fc_weight_7_1(fc_weight_7_1),
        .fc_weight_7_2(fc_weight_7_2),
		.fc_weight_7_3(fc_weight_7_3),
		.fc_weight_7_4(fc_weight_7_4),
		.fc_weight_7_5(fc_weight_7_5),
		.fc_weight_7_6(fc_weight_7_6),
		.fc_weight_7_7(fc_weight_7_7),
		.fc_weight_8_0(fc_weight_8_0),
        .fc_weight_8_1(fc_weight_8_1),
        .fc_weight_8_2(fc_weight_8_2),
		.fc_weight_8_3(fc_weight_8_3),
		.fc_weight_8_4(fc_weight_8_4),
		.fc_weight_8_5(fc_weight_8_5),
		.fc_weight_8_6(fc_weight_8_6),
		.fc_weight_8_7(fc_weight_8_7),
		.fc_weight_9_0(fc_weight_9_0),
        .fc_weight_9_1(fc_weight_9_1),
        .fc_weight_9_2(fc_weight_9_2),
		.fc_weight_9_3(fc_weight_9_3),
		.fc_weight_9_4(fc_weight_9_4),
		.fc_weight_9_5(fc_weight_9_5),
		.fc_weight_9_6(fc_weight_9_6),
		.fc_weight_9_7(fc_weight_9_7),
		*/
		.fc_end_out(fc_end_out),
		.fc_count(fc_count),
		.fc_out_1(fc_out_1),
		.fc_out_2(fc_out_2),
		.fc_out_3(fc_out_3),
		.fc_out_4(fc_out_4),
		.fc_out_5(fc_out_5),
		.fc_out_6(fc_out_6),
		.fc_out_7(fc_out_7),
		.fc_out_8(fc_out_8),
		.fc_out_9(fc_out_9)

	);

    image_bram mem(
       .clka(clk_ram),
	   .addra(addra),
	   .douta(douta));
	  
	initial begin
		// Initialize Inputs
		clk = 0;
		clk_ram = 0;
		ce = 0;
		weight1_0 = 0;
		weight1_1 = 0;
		weight1_2 = 0;
		weight1_3 = 0;
		weight1_4 = 0;
		weight1_5 = 0;
		weight1_6 = 0;
		weight1_7 = 0;
		global_rst = 0;
		activation = 0;
		j=0;
        addra = 0;
		// Wait 100 ns for global reset to finish
		
		#100;
		
        clk = 0;
		ce = 0;
		weight1_0 = 0;
		weight1_1 = 0;
		weight1_2 = 0;
		weight1_3 = 0;
		weight1_4 = 0;
		weight1_5 = 0;
		weight1_6 = 0;
		weight1_7 = 0;
        global_rst =1;
        
        i=0;
        addra = i;
		activation = douta;
        
        #60;
        
        global_rst =0;	
		ce=1;
        weight1_0 = 144'h000E_0060_0087_0062_003D_0080_0011_0041_0035;
        weight1_1 = 144'h001F_007A_0047_FFE8_003A_0099_FF6E_FF60_0004;
        weight1_2 = 144'h0036_007B_006E_0013_FFFE_0048_FFA4_FF88_FF55;
        weight1_3 = 144'h0033_003E_0013_0089_002C_002F_FFE1_003E_006C;
        weight1_4 = 144'h0087_001A_FFE3_0074_0007_0003_002A_0013_001E;
        weight1_5 = 144'h0078_0076_0061_007D_0037_0021_0008_0009_FFFD;
        weight1_6 = 144'h001C_FFFE_FFCF_0078_008B_003A_006E_0087_001B;
        weight1_7 = 144'hFFEE_0089_0041_0033_008C_FF9D_0046_FFDC_FF6E;

		#(clkp-10); 
		for(i=1;i<28*28;i=i+1) begin
		  addra = i;
		  #10;
		  activation = douta;
		  #(clkp-10); 
		 end

	end 

	// integer k;
	// initial begin
	//    fc_addra=0;
	//    #5500;
	// 	   for(k=0;k<25;k=k+1) begin
	//        if(fc_addra<24)begin
	//            fc_addra = fc_addra + 1;
	// 	   end
	// 	    #80;
	// end
	// end


/*	
	initial begin
	   clk_ram = 0;
	   #100;
	   forever #10 clk_ram = ~clk_ram;
	end
*/	
    always #(clkp/2) clk = ~clk;
    always #(clkp/2) clk_ram = ~clk_ram;  
endmodule
