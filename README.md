# Real-Time Digital Oscilloscope (FPGA & VGA)

**Engineers:** Nahom Solomon & Christopher Ruiz-Guerra  
**Hardware:** Xilinx Artix-7 (Basys 3) | AD7819 8-Bit Parallel ADC  
**Language:** Verilog HDL  

---

## Project Overview
This project implements a fully functional **Digital Oscilloscope** on a Basys 3 FPGA. The system interfaces with an external **AD7819 ADC** to sample analog signals and visualizes them in real-time on a **640x480 @ 60Hz VGA display**. 

The design focuses on precise timing synchronization between the FPGA’s digital logic and the ADC’s analog-to-digital conversion process, utilizing a custom circular buffer for seamless waveform rendering.

## Technical Features
* **SAR ADC Control Logic**: Developed a custom Verilog state machine to manage the **Successive Approximation Register (SAR)** timing, specifically handling `CONVST`, `BUSY`, and `RD` signals.
* **Real-Time VGA Visualization**: Engineered a 25MHz pixel clock and synchronization logic (`hsync`/`vsync`) to map 8-bit digital values to vertical Y-axis pixels across a 640-pixel horizontal buffer.
* **Circular Data Buffer**: Implemented an internal memory buffer that stores 640 samples, allowing for continuous, flicker-free waveform updates at a 60Hz refresh rate.
* **Hardware Verification**: Validated six critical, interdependent timing delays using an external oscilloscope to ensure sampling occurred during the stable "data-ready" window.

## Repository Structure
* **`/src`**: Primary Verilog design file (`vga_oscilloscope.v`).
* **`/sim`**: Simulation testbench (`vga_scope_tb.v`) used for timing verification.
* **`/docs`**: Full technical documentation including the **Digital_Oscilloscope_System_Analysis.pdf**.

## System Performance
The system successfully bridges the gap between analog electrical signals and digital logic. By utilizing the AD7819 8-bit parallel data converter, we achieved real-time visualization of analog waveforms with minimal signal noise and high timing accuracy.

---

## How to Deploy
1.  **Hardware**: Interface the **AD7819 ADC** with the Basys 3 PMOD headers as defined in the source constraints.
2.  **Synthesis**: Open the project in **Xilinx Vivado** and add the source files from `/src`.
3.  **Implementation**: Generate the bitstream and program the **Artix-7 FPGA**.
4.  **Display**: Connect a VGA monitor to the Basys 3 port to view the live analog signal.

---
*This project was developed as a collaborative engineering effort to demonstrate hardware-software integration and signal processing on FPGAs.*
