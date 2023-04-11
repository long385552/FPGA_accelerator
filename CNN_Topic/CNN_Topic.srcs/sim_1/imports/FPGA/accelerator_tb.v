`timescale 1ns / 1ps
`define FIXED_POINT 1
module accelerator_tb;

	// Inputs
	reg clk;
	reg clk_ram;
	reg ce;
	reg [143:0] weight1;
	reg global_rst;
	reg [15:0] activation;
    reg [9:0] addra;
	// Outputs
	wire [15:0] acc_op,conv_out,relu_out;
	wire conv_valid,conv_end;
	wire end_op;
	wire valid_op;
	wire [15:0]	douta;
	integer i;
	integer j;
    parameter clkp = 20;
    integer ip_file,r3;
	// Instantiate the Unit Under Test (UUT)
	acclerator #(.n('d28),.p('d2),.k('d3),.N('d16),.Q('d12),.ptype('d1),.s('d1),.psqr_inv(16'b0000010000000000)) uut (
		.clk(clk), 
		.ce(ce), 
		.weight1(weight1), 
		.global_rst(global_rst), 
		.activation(activation), 
		.data_out(acc_op), 
		.valid_op(valid_op), 
		.end_op(end_op),
		.conv_out(conv_out),
		.conv_valid(conv_valid),
		.conv_end(conv_end),
		.relu_out(relu_out)
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
		weight1 = 0;
		global_rst = 0;
		activation = 0;
		j=0;
        addra = 0;
		// Wait 100 ns for global reset to finish
		
		#100;
		
        clk = 0;
		ce = 0;
		weight1 = 0;
        global_rst =1;
        
        i=0;
        addra = i;
		activation = douta;
        
        #60;
        
        global_rst =0;	
		ce=1;
        weight1 = 144'hD730_F0A5_10F2_E2F8_1709_16E2_038D_18D0_FDA0;
/*
		ip_file = $fopen("activations.txt","r");
		for(i=0;i<28*28;i=i+1) begin
		  r3 = $fscanf(ip_file,"%h\n",activation);
		  #clkp; 
		end
*/

		#(clkp-10); 
		for(i=1;i<28*28;i=i+1) begin
		  addra = i;
		  #10;
		  activation = douta;
		  #(clkp-10); 
		 end

	end 
	
	initial begin
	#1940;
	j=1;
	end
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