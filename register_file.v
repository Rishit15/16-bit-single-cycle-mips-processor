// 4. REGISTER FILE MODULE
module register_file (
    input wire clk,
    input wire reg_write,
    input wire [2:0] read_reg1,
    input wire [2:0] read_reg2,
    input wire [2:0] write_reg,
    input wire [15:0] write_data,
    output wire [15:0] read_data1,
    output wire [15:0] read_data2
);
    reg [15:0] registers [0:7];
    integer j;

    initial begin
        for (j = 0; j < 8; j = j + 1) begin
            registers[j] = 16'h0000;
        end
    end

    assign read_data1 = (read_reg1 == 3'b000) ? 16'h0000 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 3'b000) ? 16'h0000 : registers[read_reg2];

    always @(posedge clk) begin
        if (reg_write && (write_reg != 3'b000)) begin
            registers[write_reg] <= write_data;
        end
    end
endmodule
