// 6. DATA MEMORY (RAM) MODULE
module data_mem (
    input wire clk,
    input wire mem_write,
    input wire mem_read,
    input wire [15:0] address,
    input wire [15:0] write_data,
    output wire [15:0] read_data
);
    reg [15:0] ram [0:63];
    integer k;

    initial begin
        for (k = 0; k < 64; k = k + 1) ram[k] = 16'h0000;
    end

    always @(posedge clk) begin
        if (mem_write) begin
            ram[address[5:0]] <= write_data;
        end
    end

    assign read_data = (mem_read) ? ram[address[5:0]] : 16'h0000;
endmodule
