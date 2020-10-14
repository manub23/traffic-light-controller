`timescale 1ns/1ps

module datapath_unit(index, road, light_out, counter_zero, timing_data, shift_reg, load_counter, inc_index, clear_index, inc_road, clear, clk, reset);
    parameter states = 6;       // number of states
    parameter roads = 4;        // number of roads
    parameter lights = 5;       // four transitions
    parameter count_max = 15;    // max. value of delay

    localparam states_size = $clog2(states);
    localparam roads_size = $clog2(roads);
    localparam lights_size = $clog2(lights);
    localparam counter_size = $clog2(count_max);

    output reg [states_size-1:0] index;
    output [2:0] light_out;
    output reg [roads_size-1:0] road;
    output counter_zero;
    input [counter_size-1:0] timing_data;
    input shift_reg;
    input load_counter;
    input inc_index;
    input clear_index;
    input inc_road;
    input clear;
    input clk;
    input reset;

    reg [counter_size-1:0] counter;
    reg [lights-1:0] light;

    assign counter_zero = ~|counter;

    assign light_out[0] = light[4] || light[0];
    assign light_out[1] = light[3] || light[1];
    assign light_out[2] = light[2];

    always @(posedge clk) begin
        if (reset == 1'b1 || clear == 1'b1) begin
            index <= 0;
        end else begin
            if (clear_index == 1'b1) begin
                index <= 0;
            end
            if (inc_index == 1'b1) begin
                index <= index + 1;
            end
        end
    end

    always @(posedge clk) begin
        if (reset == 1'b1 || clear == 1'b1) begin
            road <= 0;
        end else begin
            if (inc_road == 1'b1) begin
                if (road >= roads) begin
                    road <= 0;
                end else begin
                    road <= road + 1;
                end
            end
        end
    end


    always @(posedge clk) begin
        if (reset == 1'b1 || clear == 1'b1) begin
            light <= {{(lights-1){1'b0}}, 1'b1};
        end else begin
            if (shift_reg == 1'b1) begin
                light <= {light[lights-2:0], light[lights-1]};
            end
        end
    end


    always @(posedge clk) begin
        if (reset == 1'b1 || clear == 1'b1) begin
            counter <= ~0;
        end else begin
            if (load_counter == 1'b1) begin
                counter <= timing_data;
            end else begin
                counter <= counter - 1;
            end
        end
    end
endmodule
