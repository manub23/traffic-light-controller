`timescale 1ns/1ps

module timing_memory(timing_data, road_address, light_address, timing_enable, clk);
    parameter states = 6;       // number of states
    parameter roads = 4;        // number of roads
    parameter lights = 5;       // number of transitions
    parameter count_max = 15;   // max. value of delay

    localparam states_size = $clog2(states);
    localparam roads_size = $clog2(roads);
    localparam lights_size = $clog2(lights);
    localparam counter_size = $clog2(count_max);

    output reg [counter_size-1:0] timing_data;
    input timing_enable;
    input [roads_size-1:0] road_address;
    input [states_size-1:0] light_address;
    input clk;

    reg [counter_size-1:0] timing [0:roads-1][0:lights-1];

    always @(posedge clk) begin
        case(road_address)
            0, 2: begin
                case(light_address)
                    0: timing_data = 2;
                    1: timing_data = 13;
                    2: timing_data = 2;
                    3: timing_data = 1;
                    4: timing_data = 1;
                    default: timing_data = ~0;
                endcase
            end
            1, 3: begin
                case(light_address)
                    0: timing_data = 2;
                    1: timing_data = 5;
                    2: timing_data = 2;
                    3: timing_data = 1;
                    4: timing_data = 1;
                default: timing_data = ~0;
            endcase
            end
            default: begin
                timing_data = ~0;
            end
        endcase
    end
endmodule
