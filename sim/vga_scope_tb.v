// -------------------------------------------------------------------------
// Project: FPGA-Based Digital Oscilloscope
// Engineers: Nahom Solomon & Christopher Ruiz-Guerra
// Description: Simulation testbench to verify ADC conversion triggers 
//              and VGA timing alignment for the Artix-7 system.
// -------------------------------------------------------------------------

`timescale 1ns / 1ps

module vga_scope_tb();
    // Inputs to the UUT (Unit Under Test)
    reg clk;
    reg rst;
    reg busy;
    reg [7:0] data;
    reg switch;

    // Outputs from the UUT
    wire pclk;
    wire hsync;
    wire vsync;
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;
    wire convstb;
    wire csb;
    wire rdb;

    // Instantiate the Unit Under Test (UUT)
    vga_oscilloscope uut (
        .clk(clk), 
        .rst(rst), 
        .pclk(pclk), 
        .hsync(hsync), 
        .vsync(vsync), 
        .red(red), 
        .green(green), 
        .blue(blue), 
        .convstb(convstb), 
        .busy(busy), 
        .csb(csb), 
        .rdb(rdb), 
        .data(data), 
        .switch(switch)
    );

    // 100MHz System Clock Generation
    always begin
        #5 clk = ~clk; 
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        busy = 0;
        data = 8'h00;
        switch = 0;

        // Hold reset for 100ns
        #100;
        rst = 1;
        
        // Simulate data input
        #500;
        data = 8'hFF; // Max amplitude signal
        
        #1000;
        data = 8'h7F; // Mid-scale signal

        // Run simulation for enough time to see VGA sync pulses
        #1000000; 
        $display("Simulation Complete.");
        $finish;
    end

    // Monitor ADC Triggering Logic
    always @(negedge convstb) begin
        $display("Time: %t | ADC Conversion Started (convstb low)", $time);
    end

endmodule
