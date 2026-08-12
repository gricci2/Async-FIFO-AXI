`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2026 05:41:50 PM
// Design Name: 
// Module Name: axi_fifo_async
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


module axi_fifo_async #(
        parameter DATA_WIDTH = 32
)(

        input                   reset,
        
        input                   s_axis_clk,
        input                   s_axis_tvalid,
        input [DATA_WIDTH-1:0]  s_axis_tdata,
        output                  s_axis_tready,
        
        input                   m_axis_clk,
        output reg              m_axis_tvalid,
        output [DATA_WIDTH-1:0] m_axis_tdata,
        input                   m_axis_tready
    );
    
        wire                    w_en;
        wire                    r_en;
        wire                    full;
        wire                    empty;
    
        assign s_axis_tready = ~full;
        assign w_en = s_axis_tvalid && s_axis_tready;
        assign r_en = (!m_axis_tvalid && !empty) ||
              (m_axis_tvalid && m_axis_tready && !empty);
        
        always @ (posedge m_axis_clk) begin
            if(reset) begin
                m_axis_tvalid <= 1'b0;
            end
            else begin
                if(!m_axis_tvalid && !empty) begin
                    m_axis_tvalid <= 1'b1;
                end
                else if(m_axis_tvalid && m_axis_tready) begin
                    if(!empty) begin
                        m_axis_tvalid <= 1'b1;
                    end
                    else begin
                        m_axis_tvalid <= 1'b0;
                    end       
                end
            end
        end
        
    
    fifo_async fifo (
        .w_clk(s_axis_clk),
        .r_clk(m_axis_clk),
        .reset(reset),
        .w_en(w_en),
        .w_data(s_axis_tdata),
        .r_en(r_en),
        .r_data(m_axis_tdata),
        .full(full),
        .empty(empty)
    );
    
    
endmodule
