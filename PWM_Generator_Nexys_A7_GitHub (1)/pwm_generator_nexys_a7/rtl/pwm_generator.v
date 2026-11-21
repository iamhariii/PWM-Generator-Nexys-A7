`timescale 1ns / 1ps

// Parameterized, single-channel PWM generator.
// duty_cycle: 0 = always low, 255 = approximately 99.6%, 256 is not representable.
// For an exact 100% output, use duty_cycle == 8'hFF and accept the one-count
// low interval inherent in this 8-bit interface. See README for details.
module pwm_generator #(
    parameter integer CLOCK_HZ    = 100_000_000,
    parameter integer PWM_FREQ_HZ = 1_000
) (
    input  wire       clk,
    input  wire       rst,          // synchronous, active-high reset
    input  wire [7:0] duty_cycle,   // unsigned duty command: 0..255
    output reg        pwm_out
);

    localparam integer PERIOD_CYCLES =
        (PWM_FREQ_HZ > 0) ? (CLOCK_HZ / PWM_FREQ_HZ) : 1;

    // Counter width must be at least one bit.
    localparam integer COUNT_WIDTH =
        (PERIOD_CYCLES <= 2) ? 1 : $clog2(PERIOD_CYCLES);

    reg [COUNT_WIDTH-1:0] counter;
    wire [COUNT_WIDTH+7:0] high_cycles;

    // Scale the 8-bit command to the PWM period.
    // Rounded down: high_cycles = floor(period * duty / 256).
    assign high_cycles = (PERIOD_CYCLES * duty_cycle) >> 8;

    always @(posedge clk) begin
        if (rst) begin
            counter <= {COUNT_WIDTH{1'b0}};
            pwm_out <= 1'b0;
        end else begin
            if (counter == PERIOD_CYCLES - 1)
                counter <= {COUNT_WIDTH{1'b0}};
            else
                counter <= counter + 1'b1;

            pwm_out <= (counter < high_cycles);
        end
    end

    // Elaboration-time configuration checks (visible in simulation logs).
    initial begin
        if (CLOCK_HZ <= 0 || PWM_FREQ_HZ <= 0)
            $error("CLOCK_HZ and PWM_FREQ_HZ must be positive.");
        if (PERIOD_CYCLES < 2)
            $error("PWM period must contain at least 2 clock cycles.");
        if ((CLOCK_HZ % PWM_FREQ_HZ) != 0)
            $display("WARNING: CLOCK_HZ is not an integer multiple of PWM_FREQ_HZ; actual frequency is truncated.");
    end

endmodule
