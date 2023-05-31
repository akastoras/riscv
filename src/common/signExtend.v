`include "constants.v"
`include "config.vh"

module signExtend(	input [24:0] instr,
					output [31:0] imm_i,
					output [31:0] imm_s,
					output [31:0] imm_b,
					output [31:0] imm_u,
					output [31:0] imm_j);

assign imm_i = { {20{{instr[24]}}}, instr[24:13]};
assign imm_s = { {20{instr[24]}}, instr[24:18], instr[4:0]};
assign imm_b = { {20{instr[24]}}, instr[0], instr[23:18], instr[4:1], 1'b0};
assign imm_u = { instr[24:5], {12{1'b0}}};
assign imm_j = { {12{instr[24]}}, instr[12:5], instr[13], instr[23:18], instr[17:14], 1'b0};

endmodule