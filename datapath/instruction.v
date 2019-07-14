module instruction(
  input [31:0] Instruction,
  output [5:0]  op,
  output [4:0]  rs,rt,rd,
  output [4:0]  shamt,
  output [5:0]  funct,
  output [15:0] imm16_or_offset,
  output [25:0] PseudoAddr,
  output bit16
);

  assign op = Instruction[31:26];
  assign rs = Instruction[25:21];
  assign rt = Instruction[20:16];
  assign rd = Instruction[15:11];
  assign shamt = Instruction[10:6];
  assign funct = Instruction[5:0];
  assign imm16_or_offset = Instruction[15:0];
  assign PseudoAddr = Instruction[25:0];
  assign bit16 = Instruction[16];
endmodule