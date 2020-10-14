`timescale 1ns/1ps

`ifdef ICARUS
    `include "control_unit.v"
    `include "datapath_unit.v"
    `include "timing_memory.v"
    `include "light_latch.v"
`endif

module controller(light_out, road, light_valid, clk, reset, start);
    parameter states = 6;       // number of states
    parameter roads = 4;        // number of roads
    parameter lights = 5;       // four transitions
    parameter count_max = 15;    // max. value of delay

    localparam states_size = $clog2(states);
    localparam roads_size = $clog2(roads);
    localparam lights_size = $clog2(lights);
    localparam counter_size = $clog2(count_max);

    output [2:0] light_out;
    output [roads_size-1:0] road;
    output light_valid;
    input clk;
    input reset;
    input start;

    wire counter_zero;
    wire timing_enable;
    wire inc_road;
    wire clear_index;
    wire inc_index;
    wire load_counter;
    wire shift_reg;
    wire clear;

    wire [states_size-1:0] index;

    wire [counter_size-1:0] timing_data;

    control_unit #(
        .states(states),
        .roads(roads),
        .lights(lights),
        .count_max(count_max)
    ) control (
        .timing_enable(timing_enable),
        .inc_road(inc_road),
        .clear_index(clear_index),
        .inc_index(inc_index),
        .load_counter(load_counter),
        .shift_reg(shift_reg),
        .light_valid(light_valid),
        .clear(clear),
        .counter_zero(counter_zero),
        .clk(clk),
        .reset(reset),
        .start(start)
    );

    datapath_unit #(
        .states(states),
        .roads(roads),
        .lights(lights),
        .count_max(count_max)
    ) data (
        .index(index),
        .road(road),
        .light_out(light_out),
        .counter_zero(counter_zero),
        .timing_data(timing_data),
        .shift_reg(shift_reg),
        .load_counter(load_counter),
        .inc_index(inc_index),
        .clear_index(clear_index),
        .inc_road(inc_road),
        .clear(clear),
        .clk(clk),
        .reset(reset)
    );

    timing_memory #(
        .states(states),
        .roads(roads),
        .lights(lights),
        .count_max(count_max)
    ) timing (
        .timing_data(timing_data),
        .timing_enable(timing_enable),
        .road_address(road),
        .light_address(index),
        .clk(clk)
    );

    light_latch #(
        .states(states),
        .roads(roads),
        .lights(lights),
        .count_max(count_max)
    ) latch (
        .reset(reset),
        .light_out(light_out),
        .road(road),
        .light_valid(light_valid)
    );
endmodule
