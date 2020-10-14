`timescale 1ns/1ps

`ifdef ICARUS
    `include "controller.v"
`endif

module controller_tb();
    parameter states = 6;       // number of states
    parameter roads = 4;        // number of roads
    parameter lights = 5;       // four transitions
    parameter count_max = 15;    // max. value of delay

    localparam states_size = $clog2(states);
    localparam roads_size = $clog2(roads);
    localparam lights_size = $clog2(lights);
    localparam counter_size = $clog2(count_max);

    reg clk;
    reg reset;
    reg start;
    wire [2:0] light_out;
    wire [roads_size-1:0] road;
    wire light_valid;

    controller DUT(
        .clk(clk),
        .reset(reset),
        .start(start),
        .light_out(light_out),
        .road(road),
        .light_valid(light_valid)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 0;
        start = 0;
        #5 reset = 1;
        #5 reset = 0;
        #5 start = 1;
        #5000 $finish;
    end
endmodule
