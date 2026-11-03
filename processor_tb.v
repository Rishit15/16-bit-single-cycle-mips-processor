// PROCESSOR TESTBENCH
`timescale 1ns / 1ps

module processor_tb;
    reg clk;
    reg reset;
    wire [15:0] debug_output;

    processor_top uut (
        .clk(clk),
        .reset(reset),
        .debug_output(debug_output)
    );

    always begin
        #10 clk = ~clk;
    end

    initial begin
        clk = 0;
        reset = 1;
        #40;
        reset = 0;
        #250;
        $display("Simulation finished. Final output register value: %d", debug_output);
        $dumpflush;
        #10;
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, processor_tb); 
    end
endmodule
