# Project Report: PWM Generator Using Artix-7 FPGA

## 1. Abstract

This project implements a parameterized Pulse Width Modulation (PWM) generator using Verilog HDL on a Xilinx Artix-7 FPGA platform. The design uses the Nexys A7 100 MHz clock and provides an 8-bit switch-controlled duty-cycle command. A counter and comparator generate a 1 kHz PWM waveform, which is routed to LED0 for visual demonstration. A Verilog testbench is included to verify basic period and duty-cycle behavior in simulation.

## 2. Objectives

- Design a reusable PWM generator using Verilog HDL.
- Configure the PWM frequency through parameters.
- Control duty cycle using FPGA slide switches.
- Verify functionality using behavioral simulation.
- Synthesize and implement the design using Xilinx Vivado.

## 3. Hardware and Software Requirements

**Hardware**
- Digilent Nexys A7 FPGA development board
- USB programming cable
- Optional oscilloscope or logic analyzer for waveform measurement

**Software**
- Xilinx Vivado Design Suite with Artix-7 support
- Optional Icarus Verilog for command-line simulation

## 4. Design Methodology

The design consists of a period counter, duty threshold calculation, and comparator. The counter increments on each rising clock edge and resets at the configured period. The duty threshold is calculated by scaling the 8-bit input against the period length. The comparator controls the output state.

## 5. Design Parameters

| Parameter | Default value |
|---|---:|
| Clock frequency | 100 MHz |
| PWM frequency | 1 kHz |
| PWM period | 100,000 clock cycles |
| Duty input | 8 bits |
| Reset | Synchronous, active-high |

## 6. Expected Results

The output frequency is nominally 1 kHz. Changing SW[7:0] changes the high-time proportion. A value near 0 produces a mostly-low waveform; a value near 128 produces approximately 50% duty; a value near 255 produces approximately 99.6% duty. The testbench checks a reduced simulation configuration to complete quickly.

## 7. Applications

- LED brightness control
- DC motor speed control (with an appropriate driver circuit)
- Power-control demonstrations
- Signal generation and FPGA learning exercises

## 8. Conclusion

The project demonstrates a simple, parameterized PWM generator on an Artix-7 FPGA. The RTL, constraints, and testbench provide a starting point for further work such as multiple PWM channels, exact 100% duty support, adjustable frequency, and PMOD output routing.

## 9. Future Enhancements

- Add exact 100% duty-cycle support.
- Add a frequency-selection interface.
- Add multiple independent PWM channels.
- Add a PMOD output pin for direct waveform measurement.
- Add automated timing and utilization report capture.
