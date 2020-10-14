`timescale 1ns/1ps

module light_latch(reset, light_out, road, light_valid);
    parameter states = 6;       // number of states
    parameter roads = 4;        // number of roads
    parameter lights = 5;       // four transitions
    parameter count_max = 15;    // max. value of delay

    localparam states_size = $clog2(states);
    localparam roads_size = $clog2(roads);
    localparam lights_size = $clog2(lights);
    localparam counter_size = $clog2(count_max);

    input reset;
    input [2:0] light_out;
    input [roads_size-1:0] road;
    input light_valid;

    integer i;
    reg [2:0] light_mem [0:roads-1];

    initial begin
        for (i = 0; i < roads; i = i + 1) begin
            light_mem[i] <= 1;
        end
    end

    always @(light_valid) begin
        if (light_valid == 1'b0) begin
            light_mem[road] <= light_out;
        end
    end
endmodule
