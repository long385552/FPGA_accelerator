`timescale 1ns / 1ps
`define FIXED_POINT 1
module acclerator_1 #(
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
    output [15:0] data_out_0,
    output [15:0] data_out_1,
    output [15:0] data_out_2,
    output [15:0] data_out_3,
    output [15:0] data_out_4,
    output [15:0] data_out_5,
    output [15:0] data_out_6,
    output [15:0] data_out_7,
    
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
    output [16:0] tm,
    output valid_op,
    output end_op
    );
    //0
    parameter [143:0] weight0_0 = 144'hFFF3_0003_0030_0005_FFA3_FF8C_004A_005F_0006;
    parameter [143:0] weight0_1 = 144'h001C_0036_0081_FFF2_FFE7_008B_0059_0059_FFED;
    parameter [143:0] weight0_2 = 144'h005B_0092_00A4_0012_0015_00AE_0038_0013_003D;
    parameter [143:0] weight0_3 = 144'hFFC1_FFD8_FFF3_0004_FFDB_FFBF_001A_0053_FFF3;
    parameter [143:0] weight0_4 = 144'h0010_FFFC_0008_001D_FFAA_FFC2_002B_0033_0006;
    parameter [143:0] weight0_5 = 144'h002B_0015_0040_FFE2_FFD4_FFAB_FFD9_0004_FFC0;
    parameter [143:0] weight0_6 = 144'hFFF7_FFE2_0009_0013_FFE1_FFAE_002E_0064_0067;
    parameter [143:0] weight0_7 = 144'h000B_003D_003B_FFD6_FFF9_FFBD_FF9F_FFAA_FFE2;
    
    parameter [143:0] weight1_0 = 144'h003B_FFFD_FFE0_FFE5_002E_003C_FFD0_FFED_FFEC;
    parameter [143:0] weight1_1 = 144'h0071_0058_0048_0041_0061_0036_002D_FFBE_FFF7;
    parameter [143:0] weight1_2 = 144'h0046_001D_FFF0_FFBA_0000_0034_FF7E_FFC2_FFEF;
    parameter [143:0] weight1_3 = 144'h004F_FFF2_005B_FFE2_FFEA_0013_FFEA_0011_FFD4;
    parameter [143:0] weight1_4 = 144'h0058_002C_002F_FFE6_001F_0019_FFC3_003C_0038;
    parameter [143:0] weight1_5 = 144'h003D_0021_0023_0006_0024_002E_FFD8_FFF3_FFCA;
    parameter [143:0] weight1_6 = 144'h0036_0038_0004_FFEF_004C_000B_FFEF_FFF8_FFDC;
    parameter [143:0] weight1_7 = 144'hFFFB_FFA4_FFAA_FFFC_0038_001F_FFCF_0062_FFF6;
    
    parameter [143:0] weight2_0 = 144'h000A_0015_0038_0001_001A_0018_FF94_FFA1_FF73;
    parameter [143:0] weight2_1 = 144'h0047_FFD9_0015_006F_FFEE_FFFB_0006_001E_FFFB;
    parameter [143:0] weight2_2 = 144'h0061_0036_0049_008A_0060_008D_001D_00AA_005D;
    parameter [143:0] weight2_3 = 144'h006B_0039_0019_FFD0_0000_FFD1_FFAF_FFC6_FFC1;
    parameter [143:0] weight2_4 = 144'h005E_0016_0017_0015_FFFA_FFF9_FF92_FFA6_FFBA;
    parameter [143:0] weight2_5 = 144'h0033_0035_0008_0000_003C_0056_FFA3_FFBC_FFA8;
    parameter [143:0] weight2_6 = 144'h0061_000F_002A_FF8C_FFB6_FFB1_0013_FFE3_FF93;
    parameter [143:0] weight2_7 = 144'hFFF6_FFE2_0012_FFDE_0015_0025_FF78_FFBE_FF77;
    
    parameter [143:0] weight3_0 = 144'h002C_0016_001A_0033_003B_003C_004F_FFEE_FFBC;
    parameter [143:0] weight3_1 = 144'hFF94_FF65_FFB6_FFC7_FFFF_FFEE_FFD2_002A_FF86;
    parameter [143:0] weight3_2 = 144'hFFAD_FFD7_FFAE_FF5E_FFA4_0008_FFE2_007C_0008;
    parameter [143:0] weight3_3 = 144'h0006_0014_FFF0_FFD8_FFEA_FFD1_001F_FFCC_FF97;
    parameter [143:0] weight3_4 = 144'h003C_002E_FFF9_0000_0049_0040_002A_0000_FFE6;
    parameter [143:0] weight3_5 = 144'hFFE0_0010_FFFB_0004_FFF0_0056_0050_0003_001A;
    parameter [143:0] weight3_6 = 144'h0031_FFEC_0031_0043_0002_FFFA_002F_FFA9_FFA6;
    parameter [143:0] weight3_7 = 144'h0002_0004_0000_003E_001D_0050_0026_0041_FFE1;
    
    parameter [143:0] weight4_0 = 144'h0019_0052_FFFF_0060_0004_FFBB_001E_0006_FFF6;
    parameter [143:0] weight4_1 = 144'h0030_FFEB_FFA6_0026_FF95_FFF8_004D_FFE2_FFFF;
    parameter [143:0] weight4_2 = 144'hFF72_FF82_0010_FF7A_FF65_0004_FFC4_FF6C_0008;
    parameter [143:0] weight4_3 = 144'h0051_0004_FFBA_0014_0006_FF81_0046_0001_FFC1;
    parameter [143:0] weight4_4 = 144'h0025_0083_FFFA_002E_0058_FF78_0003_0069_FFEB;
    parameter [143:0] weight4_5 = 144'h002E_003F_FFCD_FFEC_0045_FFA0_0040_FFFD_FFA3;
    parameter [143:0] weight4_6 = 144'h0040_0006_FF9D_002A_FFF9_FF7B_0057_FFF6_FFD6;
    parameter [143:0] weight4_7 = 144'h002F_0029_FFCF_003D_001D_FFB6_0032_0005_FFBA;
    
    parameter [143:0] weight5_0 = 144'hFFD6_FFAF_FFFC_0040_005D_0045_FFF8_0006_003C;
    parameter [143:0] weight5_1 = 144'hFF2C_FF56_FF65_FFF2_FFF7_FFE4_0033_000A_0007;
    parameter [143:0] weight5_2 = 144'h0034_FFBD_FFB6_0004_0015_000A_FFFB_FFDD_001D;
    parameter [143:0] weight5_3 = 144'hFFEA_0004_002E_002B_0064_004E_FFDB_0023_0034;
    parameter [143:0] weight5_4 = 144'hFFC6_FFE3_FFBC_FFE2_FFFB_FFF2_0029_0000_FFE0;
    parameter [143:0] weight5_5 = 144'hFF98_FFCE_FFA3_FFFE_0039_0033_0039_0000_0018;
    parameter [143:0] weight5_6 = 144'hFFB4_0024_0010_0034_0036_FFF2_000E_001A_0015;
    parameter [143:0] weight5_7 = 144'hFF91_FF78_FF8F_0021_FFEB_0003_0006_FFDC_001A;
    
    parameter [143:0] weight6_0 = 144'hFFEA_FFB8_0006_004A_FFEB_FFC6_000C_0048_000B;
    parameter [143:0] weight6_1 = 144'hFFE3_FFFF_002A_FFD3_FFC7_FFAE_007F_003B_FFF7;
    parameter [143:0] weight6_2 = 144'h0095_008B_0001_FFFE_FFD8_FF31_0082_0015_FF8E;
    parameter [143:0] weight6_3 = 144'hFFC3_FFB7_FFF6_001A_001E_FFC9_0068_0043_0047;
    parameter [143:0] weight6_4 = 144'hFFE8_FFCD_FF8C_0054_FFD2_FFE9_0051_0025_0010;
    parameter [143:0] weight6_5 = 144'hFFDC_FFEA_FFEF_FFE3_FFC6_FFC6_0018_000C_0014;
    parameter [143:0] weight6_6 = 144'hFFB5_FFC9_FFC2_0054_002A_FFF5_0020_000B_003F;
    parameter [143:0] weight6_7 = 144'hFFE8_FFDA_FFAB_0001_FFDC_FFB2_0010_001E_FFF0;
    
    parameter [143:0] weight7_0 = 144'hFFF6_000F_002E_001D_0005_0039_0017_FFCA_FFDA;
    parameter [143:0] weight7_1 = 144'hFFBD_FFF3_0046_FF91_FFC9_FFDD_FFEA_002C_0001;
    parameter [143:0] weight7_2 = 144'hFFC5_FFD8_0069_0015_001B_FFFF_FFE1_FFF2_FFDA;
    parameter [143:0] weight7_3 = 144'hFFFA_0016_002A_0018_FFD1_FFF2_0002_FFF5_000A;
    parameter [143:0] weight7_4 = 144'hFFDC_0005_FFF8_0026_003B_FFFC_0031_FFF1_FFDE;
    parameter [143:0] weight7_5 = 144'h0012_FFF4_0053_000C_0040_0044_0025_FFC9_0001;
    parameter [143:0] weight7_6 = 144'hFFD3_0029_0015_0003_004F_FFD3_FFF8_FFF5_FFF3;
    parameter [143:0] weight7_7 = 144'h0039_0060_0080_009B_007B_001A_0070_FFF0_0000;
    
    acclerator_11 #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1_0 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(ce), 
		.activation_0(activation_0), 
		.activation_1(activation_1), 
		.activation_2(activation_2), 
		.activation_3(activation_3), 
		.activation_4(activation_4), 
		.activation_5(activation_5), 
		.activation_6(activation_6), 
		.activation_7(activation_7), 
		.weight_0(weight0_0),
		.weight_1(weight0_1),
		.weight_2(weight0_2),
		.weight_3(weight0_3),
		.weight_4(weight0_4),
		.weight_5(weight0_5),
		.weight_6(weight0_6),
		.weight_7(weight0_7),
		.data_out(data_out_0),
		
		.conv_op_0(conv_op_0),
		.conv_op_1(conv_op_1),
		.conv_op_2(conv_op_2),
		.conv_op_3(conv_op_3),
		.conv_op_4(conv_op_4),
		.conv_op_5(conv_op_5),
		.conv_op_6(conv_op_6),
		.conv_op_7(conv_op_7),
		.conv_op_final(conv_op_final),
		.conv_valid(conv_valid),
		.valid_pooler_ip(valid_pooler_ip),
		.tm(tm),
		.valid_op(valid_op), 
		.end_op(end_op)
	);
    
    acclerator_11 #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1_1 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(ce), 
		.activation_0(activation_0), 
		.activation_1(activation_1), 
		.activation_2(activation_2), 
		.activation_3(activation_3), 
		.activation_4(activation_4), 
		.activation_5(activation_5), 
		.activation_6(activation_6), 
		.activation_7(activation_7), 
		.weight_0(weight1_0),
		.weight_1(weight1_1),
		.weight_2(weight1_2),
		.weight_3(weight1_3),
		.weight_4(weight1_4),
		.weight_5(weight1_5),
		.weight_6(weight1_6),
		.weight_7(weight1_7),
		.data_out(data_out_1)
	);
        
    acclerator_11 #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1_2 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(ce), 
		.activation_0(activation_0), 
		.activation_1(activation_1), 
		.activation_2(activation_2), 
		.activation_3(activation_3), 
		.activation_4(activation_4), 
		.activation_5(activation_5), 
		.activation_6(activation_6), 
		.activation_7(activation_7), 
		.weight_0(weight2_0),
		.weight_1(weight2_1),
		.weight_2(weight2_2),
		.weight_3(weight2_3),
		.weight_4(weight2_4),
		.weight_5(weight2_5),
		.weight_6(weight2_6),
		.weight_7(weight2_7),
		.data_out(data_out_2)
	);
	   
    acclerator_11 #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1_3 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(ce), 
		.activation_0(activation_0), 
		.activation_1(activation_1), 
		.activation_2(activation_2), 
		.activation_3(activation_3), 
		.activation_4(activation_4), 
		.activation_5(activation_5), 
		.activation_6(activation_6), 
		.activation_7(activation_7), 
		.weight_0(weight3_0),
		.weight_1(weight3_1),
		.weight_2(weight3_2),
		.weight_3(weight3_3),
		.weight_4(weight3_4),
		.weight_5(weight3_5),
		.weight_6(weight3_6),
		.weight_7(weight3_7),
		.data_out(data_out_3)
	);
	    
    acclerator_11 #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1_4 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(ce), 
		.activation_0(activation_0), 
		.activation_1(activation_1), 
		.activation_2(activation_2), 
		.activation_3(activation_3), 
		.activation_4(activation_4), 
		.activation_5(activation_5), 
		.activation_6(activation_6), 
		.activation_7(activation_7), 
		.weight_0(weight4_0),
		.weight_1(weight4_1),
		.weight_2(weight4_2),
		.weight_3(weight4_3),
		.weight_4(weight4_4),
		.weight_5(weight4_5),
		.weight_6(weight4_6),
		.weight_7(weight4_7),
		.data_out(data_out_4)
	);
        
    acclerator_11 #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1_5 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(ce), 
		.activation_0(activation_0), 
		.activation_1(activation_1), 
		.activation_2(activation_2), 
		.activation_3(activation_3), 
		.activation_4(activation_4), 
		.activation_5(activation_5), 
		.activation_6(activation_6), 
		.activation_7(activation_7), 
		.weight_0(weight5_0),
		.weight_1(weight5_1),
		.weight_2(weight5_2),
		.weight_3(weight5_3),
		.weight_4(weight5_4),
		.weight_5(weight5_5),
		.weight_6(weight5_6),
		.weight_7(weight5_7),
		.data_out(data_out_5)
	);
	   
    acclerator_11 #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1_6 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(ce), 
		.activation_0(activation_0), 
		.activation_1(activation_1), 
		.activation_2(activation_2), 
		.activation_3(activation_3), 
		.activation_4(activation_4), 
		.activation_5(activation_5), 
		.activation_6(activation_6), 
		.activation_7(activation_7), 
		.weight_0(weight6_0),
		.weight_1(weight6_1),
		.weight_2(weight6_2),
		.weight_3(weight6_3),
		.weight_4(weight6_4),
		.weight_5(weight6_5),
		.weight_6(weight6_6),
		.weight_7(weight6_7),
		.data_out(data_out_6)
	);
		   
    acclerator_11 #(.n(n),.p(p),.k(k),.N(N),.Q(Q),.ptype(ptype),.s(s),.p_sqr_inv(p_sqr_inv),.act_type(act_type)) Acclerator_1_7 (
		.clk(clk), 
		.global_rst(global_rst), 
		.ce(ce), 
		.activation_0(activation_0), 
		.activation_1(activation_1), 
		.activation_2(activation_2), 
		.activation_3(activation_3), 
		.activation_4(activation_4), 
		.activation_5(activation_5), 
		.activation_6(activation_6), 
		.activation_7(activation_7), 
		.weight_0(weight7_0),
		.weight_1(weight7_1),
		.weight_2(weight7_2),
		.weight_3(weight7_3),
		.weight_4(weight7_4),
		.weight_5(weight7_5),
		.weight_6(weight7_6),
		.weight_7(weight7_7),
		.data_out(data_out_7)
	);
endmodule