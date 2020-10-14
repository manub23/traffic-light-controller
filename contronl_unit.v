`timescale 1ns/1ps

module control_unit(timing_enable, inc_road, clear_index, inc_index, load_counter, shift_reg, clear, light_valid, counter_zero, clk, reset, start);
    parameter S_IDLE = 3'b111;
    parameter S_RED_1 = 3'b000;
    parameter S_YELLOW_1 = 3'b001;
    parameter S_GREEN = 3'b010;
    parameter S_YELLOW_2 = 3'b011;
    parameter S_RED_2 = 3'b100;

    parameter states = 6;       // number of states
    parameter roads = 4;        // number of roads
    parameter lights = 5;       // four transitions
    parameter count_max = 15;    // max. value of delay

    localparam states_size = $clog2(states);
    localparam roads_size = $clog2(roads);
    localparam lights_size = $clog2(lights);
    localparam counter_size = $clog2(count_max);

    output reg timing_enable;
    output reg inc_road;
    output reg clear_index;
    output reg inc_index;
    output reg load_counter;
    output reg shift_reg;
    output reg clear;
    output reg light_valid;
    input counter_zero;
    input clk;
    input reset;
    input start;

    reg [states_size-1:0] state, next_state;

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            state <= S_IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(state, start, counter_zero) begin
        clear = 0;
        inc_index = 0;
        clear_index = 0;
        inc_road = 0;
        load_counter = 0;
        timing_enable = 0;
        shift_reg = 0;
        light_valid = 0;
        case(state)
            S_IDLE: begin
                if (start == 1'b1) begin
                    load_counter = 1;
                    timing_enable = 1;
                    next_state = S_RED_1;
                end else begin
                    next_state = S_IDLE;
                end
            end
            S_RED_1: begin
                if (counter_zero == 1'b1) begin
                    load_counter = 1;
                    timing_enable = 1;
                    inc_index = 1;
                    shift_reg = 1;
                    light_valid = 1;
                    next_state = S_YELLOW_1;
                end else begin
                    next_state = S_RED_1;
                end
            end
            S_YELLOW_1: begin
                if (counter_zero == 1'b1) begin
                    load_counter = 1;
                    timing_enable = 1;
                    inc_index = 1;
                    shift_reg = 1;
                    light_valid = 1;
                    next_state = S_GREEN;
                end else begin
                    next_state = S_YELLOW_1;
                end
            end
            S_GREEN: begin
                if (counter_zero == 1'b1) begin
                    load_counter = 1;
                    timing_enable = 1;
                    inc_index = 1;
                    shift_reg = 1;
                    light_valid = 1;
                    next_state = S_YELLOW_2;
                end else begin
                    next_state = S_GREEN;
                end
            end
            S_YELLOW_2: begin
                if (counter_zero == 1'b1) begin
                    load_counter = 1;
                    timing_enable = 1;
                    clear_index = 1;
                    shift_reg = 1;
                    light_valid = 1;
                    next_state = S_RED_2;
                end else begin
                    next_state = S_YELLOW_2;
                end
            end
            S_RED_2: begin
                if (counter_zero == 1'b1) begin
                    load_counter = 1;
                    timing_enable = 1;
                    clear_index = 1;
                    inc_road = 1;
                    shift_reg = 1;
                    light_valid = 1;
                    next_state = S_RED_1;
                end else begin
                    next_state = S_RED_2;
                end
            end
            default: begin
                clear = 1;
                next_state = S_RED_1;
            end
        endcase
    end
endmodule
