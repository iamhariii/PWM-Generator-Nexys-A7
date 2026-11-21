`timescale 1ns / 1ps

module tb_pwm_generator;

    // Small simulation clock and frequency keep the test fast.
    localparam integer CLOCK_HZ    = 100_000;
    localparam integer PWM_FREQ_HZ = 1_000;
    localparam integer PERIOD      = CLOCK_HZ / PWM_FREQ_HZ;

    reg clk = 1'b0;
    reg rst = 1'b1;
    reg [7:0] duty_cycle = 8'd128;
    wire pwm_out;

    integer i;
    integer high_count;
    integer low_count;
    integer period_count;

    always #5 clk = ~clk; // 100 MHz simulation clock (10 ns period)

    pwm_generator #(
        .CLOCK_HZ    (CLOCK_HZ),
        .PWM_FREQ_HZ (PWM_FREQ_HZ)
    ) dut (
        .clk        (clk),
        .rst        (rst),
        .duty_cycle (duty_cycle),
        .pwm_out    (pwm_out)
    );

    initial begin
        $dumpfile("pwm_generator.vcd");
        $dumpvars(0, tb_pwm_generator);

        // Apply synchronous reset.
        repeat (3) @(negedge clk);
        rst = 1'b0;

        // Allow the output pipeline to settle, then count one complete period.
        @(negedge clk);
        high_count = 0;
        low_count = 0;
        period_count = 0;

        for (i = 0; i < PERIOD; i = i + 1) begin
            @(posedge clk);
            #1;
            period_count = period_count + 1;
            if (pwm_out)
                high_count = high_count + 1;
            else
                low_count = low_count + 1;
        end

        $display("Duty command=%0d, period=%0d cycles, high=%0d, low=%0d",
                 duty_cycle, period_count, high_count, low_count);

        if (period_count != PERIOD)
            $fatal(1, "FAIL: Incorrect period length.");
        // 128/256 of 100 cycles = 50 high cycles, subject to registered output phase.
        if (high_count < 49 || high_count > 50)
            $fatal(1, "FAIL: Duty-cycle result outside expected range.");
        if (low_count < 50 || low_count > 51)
            $fatal(1, "FAIL: Low-time result outside expected range.");

        // Verify zero duty.
        duty_cycle = 8'd0;
        repeat (PERIOD + 2) @(posedge clk);
        #1;
        if (pwm_out !== 1'b0)
            $fatal(1, "FAIL: Output should be low for zero duty.");

        $display("PASS: PWM generator basic checks completed.");
        $finish;
    end

endmodule
