`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2026 04:17:02 PM
// Design Name: 
// Module Name: fifo_async
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


module fifo_async(
        input               w_clk,
        input               r_clk,
        input               reset,
        
        input               w_en,
        input   [31:0]      w_data,     //32 bits each
        
        input               r_en,
        output reg [31:0]   r_data,
        
        output              full,
        output              empty
        
    );
    
        reg     [4:0]       w_ptr = 5'd0;    //16 addresses, MSB is wrap bit
        reg     [4:0]       r_ptr = 5'd0;
        
        reg     [4:0]       sync_w = 5'd0;
        reg     [4:0]       sync_prew = 5'd0;
        reg     [4:0]       gray_w = 5'd0;
        
        reg     [4:0]       sync_r = 5'd0;
        reg     [4:0]       sync_prer = 5'd0;
        reg     [4:0]       gray_r = 5'd0;
        
        reg [31:0]          mem [0:15];
        
        
        assign full = ({~gray_w[4], ~gray_w[3], gray_w[2:0]} == sync_r);
        assign empty = (sync_w == gray_r);
        //write
        always @ (posedge w_clk) begin
            if(reset) begin
                w_ptr <= 5'd0;
                sync_r <= 5'd0;
                sync_prer <= 5'd0;
            end
            else begin
            sync_prer <= gray_r;
            sync_r <= sync_prer;
            
                if(w_en && !full) begin
                    mem[w_ptr[3:0]] <= w_data;
                    w_ptr <= w_ptr + 1;
                end
            end
        end
        
        //read
        always @ (posedge r_clk) begin
            if(reset) begin
                r_ptr <= 5'd0;
                sync_w <= 5'd0;
                sync_prew <= 5'd0;
            end
            else begin
            sync_prew <= gray_w;
            sync_w <= sync_prew;
            
                if (r_en && !empty) begin
                    r_data <= mem[r_ptr[3:0]];
                    r_ptr <= r_ptr + 1;
                end
            end
        end
        
        //gray code pointers
        always @ (*) begin
            gray_w[4] = w_ptr[4];
            gray_w[3] = w_ptr[3] ^ w_ptr[4];
            gray_w[2] = w_ptr[2] ^ w_ptr[3];
            gray_w[1] = w_ptr[1] ^ w_ptr[2];
            gray_w[0] = w_ptr[0] ^ w_ptr[1];
            
            gray_r[4] = r_ptr[4];
            gray_r[3] = r_ptr[3] ^ r_ptr[4];
            gray_r[2] = r_ptr[2] ^ r_ptr[3];
            gray_r[1] = r_ptr[1] ^ r_ptr[2];
            gray_r[0] = r_ptr[0] ^ r_ptr[1];
        end
endmodule
