// 2. INSTRUCTION MEMORY (ROM) MODULE
module instruction_mem (
    input wire [15:0] pc,
    output wire [15:0] instruction
);
    reg [15:0] rom [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            rom[i] = 16'h0000;
        end
        // Verified machine code program instructions
        rom[0] = 16'h4045; // ADDI R1, R0, 5  (R1 = 5)
        rom[1] = 16'h4083; // ADDI R2, R0, 3  (R2 = 3)
        rom[2] = 16'h0298; // ADD  R3, R1, R2 (R3 = 5 + 3 = 8)
        rom[3] = 16'h60CA; // SW   R3, 10(R0) (RAM = 8)
        rom[4] = 16'h501A; // LW   R4, 10(R0) (R4 = 8)
        rom[5] = 16'h8000; // J    0x0000     (Loop back)
    end

    assign instruction = rom[pc[5:0]]; 
endmodule
