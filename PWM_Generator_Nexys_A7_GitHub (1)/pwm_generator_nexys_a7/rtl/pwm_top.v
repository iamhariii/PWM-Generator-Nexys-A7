`timescale 1ns / 1ps

// Nexys A7 top-level.
// SW[7:0] sets duty command; BTNC resets the PWM generator.
// LED0 displays the PWM waveform. Connect an oscilloscope/logic analyzer
// to LED0 or route pwm_out to a PMOD pin for external measurement.
module pwm_top (
    input  wire       CLK100MHZ,
    input  wire       BTNC,
    input  wire [7:0] SW,
    output wire [7:0] LED
);

    wire pwm_signal;

    pwm_generator #(
        .CLOCK_HZ    (100_000_000),
        .PWM_FREQ_HZ (1_000)
    ) u_pwm_generator (
        .clk        (CLK100MHZ),
        .rst        (BTNC),
        .duty_cycle (SW),
        .pwm_out    (pwm_signal)
    );

    assign LED[0]   = pwm_signal;
    assign LED[7:1] = SW[7:1];

endmodule
