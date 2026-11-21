# PWM Generator — Nexys A7 (Artix-7) FPGA

A parameterized Verilog PWM generator intended for the Digilent Nexys A7 FPGA board and Xilinx Vivado.

## Features

- 100 MHz Nexys A7 system clock
- Default PWM frequency: 1 kHz
- 8-bit duty-cycle input using slide switches SW[7:0]
- Synchronous active-high reset using center button BTNC
- PWM waveform displayed on LED0
- Behavioral testbench with basic period and duty-cycle checks
- Vivado Tcl project-creation script

## Hardware mapping

| Signal | Nexys A7 resource | Function |
|---|---|---|
| `CLK100MHZ` | 100 MHz oscillator | System clock |
| `BTNC` | Center pushbutton | Synchronous reset |
| `SW[7:0]` | Switches 0–7 | Duty-cycle command |
| `LED[0]` | LED0 | PWM output |
| `LED[7:1]` | LEDs 7–1 | Display switch bits 7–1 |

The PWM signal is visible on LED0, but an LED is not suitable for accurately measuring PWM frequency or duty cycle. Use an oscilloscope or logic analyzer on an appropriate accessible output when precise measurement is required.

## Duty-cycle encoding

The input is an unsigned 8-bit value from 0 to 255. The implementation computes:

`high_cycles = floor(PERIOD_CYCLES × duty_cycle / 256)`

Examples:
- `SW = 8'h00`: 0% duty cycle (always low)
- `SW = 8'h80`: approximately 50%
- `SW = 8'hFF`: approximately 99.6%

An 8-bit fraction cannot encode exactly 100%; use a 9-bit command or add a special full-scale case if exact 100% is required.

## Repository structure

```text
PWM_Generator_Nexys_A7/
├── rtl/
│   ├── pwm_generator.v
│   └── pwm_top.v
├── sim/
│   └── tb_pwm_generator.v
├── constraints/
│   └── nexys_a7_master_subset.xdc
├── scripts/
│   └── create_project.tcl
├── docs/
│   ├── BLOCK_DIAGRAM.md
│   └── PROJECT_REPORT.md
├── .gitignore
├── LICENSE
└── README.md
```

## Open and run in Vivado

1. Install Xilinx Vivado with support for the Artix-7 device family.
2. Open Vivado.
3. In the Tcl Console, change directory to this repository.
4. Run:

   ```tcl
   source scripts/create_project.tcl
   ```

5. In **Flow Navigator → Simulation**, run **Run Behavioral Simulation**.
6. Check the transcript for `PASS: PWM generator basic checks completed.`
7. Run **Run Synthesis**, then **Run Implementation**.
8. Generate the bitstream.
9. Connect the Nexys A7 board, open Hardware Manager, and program the FPGA.

## Important board note

The supplied XDC is a project-specific subset of the Nexys A7 master constraints. It targets the Nexys A7-100T pinout. Check your board model/revision and the official Digilent master XDC before programming. For a Nexys A7-50T, change the FPGA part in `scripts/create_project.tcl` to `xc7a50ticsg324-1` and confirm the board-part setting available in your Vivado installation.

## Change PWM frequency

In `rtl/pwm_top.v`, change `.PWM_FREQ_HZ(1_000)` to the desired frequency. The clock frequency is set to 100,000,000 Hz for the Nexys A7 onboard oscillator. Ensure the requested frequency is positive and the period contains at least two clock cycles.

## Simulation outside Vivado (optional)

With Icarus Verilog installed:

```bash
iverilog -g2012 -o pwm_tb rtl/pwm_generator.v sim/tb_pwm_generator.v
vvp pwm_tb
```

## GitHub

Create an empty GitHub repository, then from this folder run:

```bash
git init
git add .
git commit -m "Add PWM generator for Nexys A7 FPGA"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```

Replace the remote URL with your own repository URL.
