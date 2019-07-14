`include "..\\control\\ctrl_signals_def.v"
module datapath(
  input clk, rst,
  
  input RegWrite,
  input [1:0] RwIdSrc, RwDataSrc,

  input MemRead, MemWrite, MemOpType,

  input [2:0] BranchType,
  input [1:0] JumpType,

  input [4:0] AluCtr,
  input [1:0] AluBSrc,
  
  input ExtType, MemDataExtType,
  
  output [5:0] opcode, funct,
  output bit16
);
  wire [31:0] PC, NPC, NormalNPC;
  // 根据npc和clk,rst设置pc
  // 无需变动，直接复用11条的
  pc pc(.NPC(NPC), .PC(PC), .rst(rst), .clk(clk));

  wire [31:0] Instruction;
  // 根据pc 从im中读取指令，取指令，直接复用
  im_4k im(.addr(PC[11:2]), .dout(Instruction));
  
  wire [4:0] rs, rt, rd;
  wire [4:0] shamt;
  wire [15:0] imm16_or_offset;
  wire [25:0] PseudoAddr;
  // 译码部分，分离指令各个字段
  // 直接复用
  instruction instruction(
    Instruction,
    opcode,
    rs, rt, rd, 
    shamt,
    funct,
    imm16_or_offset, 
    PseudoAddr,
    bit16
  );

  // 数据通路寄存器存取部分
  wire [4:0]rw;
  wire [31:0]rsVal, rtVal, regWriteData;
  assign rw = (RwIdSrc == `RwIdSrc_ra) ? `ra : 
              ((RwIdSrc == `RwIdSrc_rd) ? rd : rt);
  regfiles regfiles(
    .writeEn(RegWrite), .rw(rw), .busW(regWriteData),
    .ra(rs), .rb(rt), .busA(rsVal), .busB(rtVal),
    .clk(clk)
  );
  
  wire [31:0] imm32_or_offset, lui_imm;
  wire [31:0] AluB; // AluA is always rsVal
  
  ext imm_ext(
    .in(imm16_or_offset),
    .out(imm32_or_offset),
    .ExtType(ExtType)
   ); // prepare extend im16_or_offset to imm32_or_offset_or_offset
  assign lui_imm = { imm16_or_offset, 16'b0 }; // prepare lui_imm
  
  // 与AluBSrc的信号常量对应书写代码
  mux4 alub_mux(
    .i00(rtVal),
    .i01(imm32_or_offset), // Done: to prepare imm32_or_offset by ext module
    .i10(32'd0),
    .i11(lui_imm), // Done: to prepare lui_imm by special extend
    .sel(AluBSrc),
    .out(AluB)
  );
  
  //wire co, cf, zf, sf, of;
  wire zero, pos, neg;
  wire [31:0] alu_res;
  alu alu(
    .A(rsVal), .B(AluB), // DONE:  to prepare AluB
    .ALUctr(AluCtr), 
    .result(alu_res),
    //.co(co), .cf(cf), .zf(zf), .sf(sf), .of(of),
    .zero(zero), .pos(pos), .neg(neg),
    .shamt(shamt)
  );
  
  wire [31:0] dm_read_data;
  dm_4k dm(
    .addr(alu_res[11:2]), .ByteOff(alu_res[1:0]),
    .wr_en(MemWrite), .d_in(rtVal),
    .d_out(dm_read_data),
    .MemOpType(MemOpType), .MemDataExtType(MemDataExtType),
    .clk(clk)
  );
  
  // set regWriteData
  mux4 sel_regWriteData(
    .i00(alu_res),
    .i01(dm_read_data), // dm
    .i10(NormalNPC), // calulate pc
    .i11(32'hxxxx_xxxx),
    .sel(RwDataSrc),
    .out(regWriteData)
  );
  
  // not imm32, imm32 is for load/store type instructions calculate memory addr
  npc npc(
    .PC(PC),
    .PseudoAddr(PseudoAddr),
    .offset(imm16_or_offset), 
    .RegTypeNPC(rsVal),
    .BranchType(BranchType),
    .JumpType(JumpType),
    //.zf(zf), .sf(sf), .of(of),
    .zero(zero), .pos(pos), .neg(neg),
    .NPC(NPC),
    .NormalNPC(NormalNPC)
  );
endmodule
  
  
