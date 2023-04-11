`timescale 1ns / 1ps

module pooler2 #(
    parameter m = 9'h00a,
    parameter p = 9'h002,
    parameter N = 16,
    parameter Q = 8,
    parameter ptype = 1, //0-> average pooling, 1 -> max pooling
    parameter p_sqr_inv = 16'b0000010000000000 //this parameter is needed in average pooling case where the sum is divided by p**2.
                                               //It needs to be supplied manually and should be equal to (1/p)^2 in whatever the
                                               //(Q,N) format is being used.
    )(
    input clk,
    input ce,
    input master_rst,
    input [N-1:0] data_in,
    output reg [N-1:0] data_out,
    output reg [16:0] tm,
    output valid_op,               //output signal to indicate the valid output
    output reg end_op                  //output signal to indicate when all the valid outputs have been  
                                   //produced for that particular input matrix
    );
   
    wire rst_m,load_sr,global_rst;//op_en,pause_ip,
    wire [1:0] sel;
    wire [N-1:0] comp_op;
    wire [N-1:0] sr_op;
    wire [N-1:0] max_reg_op;
    wire [N-1:0] div_op;
    wire ovr;
    wire [N-1:0] mux_out;
    //reg [N-1:0] temp;
    
    reg [15:0] tmax [4:0];
    reg [4:0] counter;
    integer col=0;
    integer row=0;
    integer c=0;
    
 
   
    control_logic2 #(m,p) log(     
	    .clk(clk),
	    .master_rst(master_rst),
	    .ce(ce),
	    .sel(sel),
	    .rst_m(rst_m),
	    .op_en(valid_op),
	    .load_sr(load_sr),
	    .global_rst(global_rst)
      );

    always@(posedge ce) begin
        
        if(col%2==0 && row%2==0) begin
            tmax[col/2]=data_in;
        end
        else begin
            if(data_in>tmax[col>>2]) tmax[col>>2]=data_in;
        end
        tm=tmax[col>>2];
        
        col=col+1;
        if(col>10) begin
            col=0;
            row=row+1;
        end

    end
    
    always@(posedge valid_op ,posedge master_rst)begin
        if(master_rst) begin
            data_out = 0;
            counter = 0;
            c = 0;
            end_op = 0;
        end 
        else begin
            data_out = tmax[c];
            c = c+1;
            
            if(counter == 24) end_op = 1;
            else counter = counter + 1;
            
            if(c > 4) c = 0;
        end
    end

    
    
endmodule
