// 7. TOP-LEVEL PROCESSOR WRAPPER MODULE
module processor_top (
    input wire clk,
    input wire reset,
    output wire [15:0] debug_output
);
    wire [15:0] pc_current, pc_next, pc_plus_one, branch_target;
    wire [15:0] instruction;
    wire [15:0] reg_read1, reg_read2, reg_write_data;
    wire [15:0] alu_operand2, alu_result;
    wire [15:0] mem_read_data;
    
    wire reg_write, alu_src, mem_read, mem_write, mem_to_reg, branch, jump;
    wire [2:0] alu_op;
    wire alu_zero;

    // --- Fetch ---
    pc program_counter (
        .clk(clk), .reset(reset), .next_pc(pc_next), .curr_pc(pc_current)
    );

    instruction_mem inst_memory (
        .pc(pc_current), .instruction(instruction)
    );

    assign pc_plus_one = pc_current + 16'h0001;

    // --- Decode ---
    wire [3:0] opcode = instruction[15:12];
    wire [2:0] rs     = instruction[11:9];
    wire [2:0] rt     = instruction[8:6];
    wire [2:0] rd     = instruction[5:3];
    
    wire [15:0] sign_extended_imm = { {10{instruction[5]}}, instruction[5:0] };

    control_unit controller (
        .opcode(opcode), .reg_write(reg_write), .alu_src(alu_src), 
        .mem_read(mem_read), .mem_write(mem_write), .mem_to_reg(mem_to_reg), 
        .branch(branch), .jump(jump), .alu_op(alu_op)
    );

    wire [2:0] final_write_reg = (opcode == 4'b0000 || opcode == 4'b0001 || opcode == 4'b0010 || opcode == 4'b0011) ? rd : rt;

    register_file registers (
        .clk(clk), .reg_write(reg_write), .read_reg1(rs), .read_reg2(rt), 
        .write_reg(final_write_reg), .write_data(reg_write_data), 
        .read_data1(reg_read1), .read_data2(reg_read2)
    );

    // --- Execute ---
    assign alu_operand2 = (alu_src) ? sign_extended_imm : reg_read2;

    alu arithmetic_core (
        .a(reg_read1), .b(alu_operand2), .alu_op(alu_op), 
        .result(alu_result), .zero(alu_zero)
    );

    assign branch_target = pc_plus_one + sign_extended_imm;

    // --- Memory ---
    data_mem main_ram (
        .clk(clk), .mem_write(mem_write), .mem_read(mem_read), 
        .address(alu_result), .write_data(reg_read2), .read_data(mem_read_data)
    );

    assign reg_write_data = (mem_to_reg) ? mem_read_data : alu_result;

    // --- Writeback & Next PC Logic ---
    wire [15:0] pc_branch_choice = (branch && alu_zero) ? branch_target : pc_plus_one;
    wire [15:0] jump_target = { 4'b0000, instruction[11:0] }; 
    assign pc_next = (jump) ? jump_target : pc_branch_choice;

    assign debug_output = reg_write_data;

endmodule
