`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 03:18:14 PM
// Design Name: 
// Module Name: axi_fifo_async_tb
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


module axi_fifo_async_tb();

wire    [31:0]  r_data;
wire            w_ready;
wire            r_valid;



reg    [31:0]   w_data = 32'd0;
reg             w_clk = 0;
reg             r_clk = 0;
reg             reset = 0;
reg             w_valid = 0;
reg             r_ready = 0;


localparam DURATION = 10000;

integer i = 0;

always #5 begin
    w_clk = ~w_clk;
end

always #7 begin
    r_clk = ~r_clk;
end
    
initial begin
    #100
    reset = 1;
    #100
    reset = 0;
    #100
    
    //write and read
    r_ready = 1;
    for(i = 0; i < 10; i = i + 1) begin
        w_data = i;
        w_valid = 1;
        #10;
        w_valid = 0;
        #10;
    end
    
    //write to full
    r_ready = 0;
    for(i = 0; i < 19; i = i + 1) begin
        w_data = i;
        w_valid = 1;
        #10;
        w_valid = 0;
        #10;
    end
    
    //read to empty
    r_ready = 1;
    for(i = 0; i < 19; i = i + 1) begin
        #20;
    end
    
   $finish;
end



axi_fifo_async #(
.DATA_WIDTH(32)
)dut(
    .reset(reset),
    .s_axis_clk(w_clk),
    .s_axis_tvalid(w_valid),
    .s_axis_tdata(w_data),
    .s_axis_tready(w_ready),
    .m_axis_clk(r_clk),
    .m_axis_tvalid(r_valid),
    .m_axis_tdata(r_data),
    .m_axis_tready(r_ready)
);

endmodule
