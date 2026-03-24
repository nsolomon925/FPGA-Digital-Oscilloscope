// -------------------------------------------------------------------------
// Project: FPGA-Based Digital Oscilloscope
// Engineer: Nahom Solomon & Christopher Ruiz-Guerra
// Hardware: Xilinx Artix-7 (Basys 3), AD7819 ADC
// Description: Implements a 640x480 VGA display that visualizes analog 
//              signals sampled from an 8-bit parallel ADC.
// -------------------------------------------------------------------------

`timescale 1ns / 1ps

module vga_oscilloscope(
    input clk,              // System Clock (W5: 100MHz) [cite: 2]
    input rst,              // Reset (L2) [cite: 4]
    output pclk,            // Pixel Clock (J1) [cite: 2]
    output hsync,           // Hsync (H1) [cite: 4]
    output vsync,           // Vsync (K2) [cite: 5]
    output [3:0] red, 
    output [3:0] green, 
    output [3:0] blue,
    output convstb,         // ADC Convert Start (H2) [cite: 7, 17]
    input busy,             // ADC Busy Signal (G3) [cite: 7]
    output csb,             // ADC Chip Select (H1) [cite: 6, 18]
    output rdb,             // ADC Read (K2) [cite: 6, 19]
    input [7:0] data,       // 8-bit Parallel Data [cite: 8]
    input switch            // User Toggle [cite: 8]
);

    // Internal Registers and Timing [cite: 9, 10, 11, 12, 21]
    reg [13:0] ctrP, ctrH;
    reg [18:0] ctrV;
    reg [8:0] timing_counter;
    reg [9:0] buffercounter;
    reg [7:0] buffer[639:0]; 

    // VGA Timing Assignments [cite: 22, 23, 24]
    assign pclk = (ctrP < 14'd2) ? 1'b1 : 1'b0;
    assign hsync = (ctrH < 14'd96) ? 1'b0 : 1'b1;
    assign vsync = (ctrV < 19'd2) ? 1'b0 : 1'b1;

    // ADC Interface Timing [cite: 26, 27, 28]
    assign convstb = (timing_counter <= 9'd2) ? 1'b0 : 1'b1;
    assign csb = (timing_counter > 9'd449 && timing_counter <= 9'd489) ? 1'b0 : 1'b1;
    assign rdb = (timing_counter > 9'd449 && timing_counter <= 9'd479) ? 1'b0 : 1'b1;

    // Pixel Clock Generation (25MHz from 100MHz) [cite: 29, 31, 33]
    always @(posedge clk or negedge rst) begin      
        if (~rst) ctrP <= 14'd0;
        else if (ctrP < 14'd3) ctrP <= ctrP + 14'd1;
        else ctrP <= 14'd0;
    end

    // Horizontal and Vertical Sync Generation [cite: 36, 39, 42, 44]
    always @(posedge pclk or negedge rst) begin      
        if (~rst) begin
            ctrH <= 14'd0;
            ctrV <= 19'd0;
        end else begin
            if (ctrH < 14'd799) ctrH <= ctrH + 14'd1;
            else begin 
                ctrH <= 14'd0;
                if (ctrV >= 19'd520) ctrV <= 19'd0;
                else ctrV <= ctrV + 19'd1;
            end
        end
    end    
    
    // ADC Sampling and Buffer Logic [cite: 46, 49, 51, 52, 53]
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            timing_counter <= 9'd0;
            buffercounter <= 10'd0;
        end else begin
            if (timing_counter < 9'd499) begin
                if (busy == 1'd0 && timing_counter == 9'd470 && switch == 1'd0) begin
                    buffer[buffercounter] = data;
                end
                timing_counter <= timing_counter + 9'd1;
            end else begin
                timing_counter <= 9'd0;
                if (buffercounter < 10'd639) buffercounter <= buffercounter + 10'd1;
                else buffercounter <= 10'd0;
            end
        end
    end

    // Waveform Visualization (Green Pixels) [cite: 54]
    assign green = (((buffer[ctrH - 14'd144] + 10'd31) == ctrV) && (ctrH >= 14'd144 && ctrH <= 14'd784)) ? 4'b1111 : 4'b0000;
    assign red = 4'b0000;
    assign blue = 4'b0000;

endmodule
