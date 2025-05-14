module MIPSpipeline(
    input clk, reset
);

    // Internal signals to connect stages
    wire [31:0] IFID_instr, IFID_npc;
    wire [1:0] id_ex_wb;
    wire [2:0] id_ex_mem;
    wire [3:0] id_ex_execute;
    wire [31:0] id_ex_npc, id_ex_readdat1, id_ex_readdat2, id_ex_sign_ext;
    wire [4:0] id_ex_instr_bits_20_16, id_ex_instr_bits_15_11;

    wire [1:0] ex_mem_wb, ex_mem_mem;
    wire [31:0] ex_mem_adder_out, ex_mem_alu_result_out, ex_mem_rdata2_out;
    wire [4:0] ex_mem_muxout_out;
    wire ex_mem_zero;
    
    wire [1:0] mem_wb_wb;
    wire [31:0] mem_wb_read_data, mem_wb_alu_result;
    wire [4:0] mem_wb_write_reg;

    // Stage 1: Instruction Fetch
    I_Fetch fetchIns(
        .clk(clk),
        .reset(reset),
        .EX_MEM_PCSrc(EX_MEM_PCSrc), 
        .EX_MEM_NPC(EX_MEM_NPC),
        .IFID_instr(IFID_instr),
        .IFID_npc(IFID_npc)
    );

    // Stage 2: Instruction Decode
    decode decodeIns (
        .clk(clk),
        .rst(reset),
        .wb_reg_write(mem_wb_wb[0]), // write-back control
        .wb_reg_write_location(mem_wb_write_reg),
        .mem_wb_write_data(mem_wb_read_data),
        .if_id_instr(IFID_instr),
        .if_id_npc(IFID_npc),
        .id_ex_wb(id_ex_wb),
        .id_ex_mem(id_ex_mem),
        .id_ex_execute(id_ex_execute),
        .id_ex_npc(id_ex_npc),
        .id_ex_readdat1(id_ex_readdat1),
        .id_ex_readdat2(id_ex_readdat2),
        .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
    );

    // Stage 3: Execute
    execute executeIns (
        .clk(clk),
        .rst(reset),
        .ctlwb_in(id_ex_wb),
        .ctlm_in(id_ex_mem),
        .npc(id_ex_npc),
        .rdata1(id_ex_readdat1),
        .rdata2(id_ex_readdat2),
        .s_extend(id_ex_sign_ext),
        .instr_2016(id_ex_instr_bits_20_16),
        .instr_1511(id_ex_instr_bits_15_11),
        .alu_op(id_ex_execute[1:0]),
        .funct(id_ex_execute[3:2]),
        .alusrc(id_ex_execute[0]),
        .regdst(id_ex_execute[2]),
        .ctlwb_out(ex_mem_wb),
        .ctlm_out(ex_mem_mem),
        .adder_out(ex_mem_adder_out),
        .alu_result_out(ex_mem_alu_result_out),
        .rdata2_out(ex_mem_rdata2_out),
        .muxout_out(ex_mem_muxout_out),
        .outzero(ex_mem_zero)
    );

    // Stage 4: Memory
    memory memoryIns (
        .clk(clk),
        .ALUResult(ex_mem_alu_result_out),
        .WriteData(ex_mem_rdata2_out),
        .WriteReg(ex_mem_muxout_out),
        .WBControl(ex_mem_wb),
        .MemWrite(ex_mem_mem[0]),
        .MemRead(ex_mem_mem[1]),
        .Branch(ex_mem_mem[2]),
        .Zero(ex_mem_zero),
        .ReadData(mem_wb_read_data),
        .ALUResult_out(mem_wb_alu_result),
        .WriteReg_out(mem_wb_write_reg),
        .WBControl_out(mem_wb_wb),
        .PCSrc(EX_MEM_PCSrc) // PC control for fetch
    );

    // Stage 5: Writeback
        writeback WB_Ins (
        .MemToReg(mem_wb_wb[1]), // WBControl guides selection
        .read_data(mem_wb_read_data),
        .ALU_result(mem_wb_alu_result),
        .write_data(mem_wb_write_data)
    );

endmodule
