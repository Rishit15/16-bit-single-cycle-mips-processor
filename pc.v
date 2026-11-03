// 1. PROGRAM COUNTER (PC) MODULE
module pc (
    input wire clk,
    input wire reset,
    input wire [15:0] next_pc,
    output reg [15:0] curr_pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            curr_pc <= 16'h0000;
        else
            curr_pc <= next_pc;
    end
endmodule
