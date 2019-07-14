`include "..\\control\\ctrl_signals_def.v"
module npc(
  PC,
  PseudoAddr,
  offset,
  RegTypeNPC,
  BranchType,
  JumpType,
  //zf, sf, of,
  zero, pos, neg,
  NPC, NormalNPC
);

  input [31:0] PC;
  input [25:0] PseudoAddr;
  input [15:0] offset;
  input [31:0] RegTypeNPC;
  input [2:0] BranchType;
  input [1:0] JumpType;
  //input zf, sf, of;
  input zero, pos, neg;
  output [31:0] NPC;
  output [31:0] NormalNPC;
  
  wire cmp_flag;
  wire should_go_to_branch;
  
  mux8 #(.WIDTH(1)) mux_jump(
    .i000(zero | pos), // bgez
    .i001(pos), // bgtz
    .i010(neg | zero), // blez
    .i011(neg), // bltz
    
    .i100(zero), // beq
    .i101(zero^1'b1), // bne
    .i110(`False), // 
    .i111(`False), // no_branch
    
    .sel(BranchType),
    .out(cmp_flag)
  );
  assign should_go_to_branch = (JumpType == `OffsetTypeJump) ? cmp_flag : `False;
  wire [29:0]offset_30;
  wire [31:0]offset_32;
  ext #(.WIDTH(16),.BIGWIDTH(30)) pc_offset_ext(
    .in(offset),
    .ExtType(`SignExt),
    .out(offset_30)
  );
  assign offset_32 = {offset_30, 2'b00};

  wire [31:0] PseudoTypeNPC = {PC[31:28], PseudoAddr, 2'b00};
  assign NormalNPC = PC + 4;
  
  wire [31:0] BranchOffsetNPC = PC + offset_32;
  wire [31:0] shouldGotoBranchNPC = (should_go_to_branch) ? BranchOffsetNPC : NormalNPC;
  mux4 mux_jump_npc(
    .i00(NormalNPC), // No_Jump
    .i01(shouldGotoBranchNPC), // OffsetTypeJum  for branch
    
    .i10(RegTypeNPC), // RegTypeJump
    .i11(PseudoTypeNPC), // PseudoTypeJump
    
    .sel(JumpType),
    
    .out(NPC)
  );
endmodule
