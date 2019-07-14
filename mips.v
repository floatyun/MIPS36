module mips(
  input clk,
  input rst
);

  wire [5:0] opcode, funct;
  wire bit16;

  wire RegWrite;
  wire [1:0] RwIdSrc, RwDataSrc;

  wire MemRead, MemWrite, MemOpType;

  wire [2:0] BranchType;
  wire [1:0] JumpType;

  wire [4:0] AluCtr;
  wire [1:0] AluBSrc;

  wire ExtType, MemDataExtType;

  ctrl ctrl(
    //input
    .opcode(opcode), .funct(funct), .bit16(bit16),
    //output
    .RegWrite(RegWrite), .RwIdSrc(RwIdSrc),.RwDataSrc(RwDataSrc),
    .MemRead(MemRead), .MemWrite(MemWrite), .MemOpType(MemOpType),
    .BranchType(BranchType), .JumpType(JumpType),
    .AluCtr(AluCtr), .AluBSrc(AluBSrc),
    .ExtType(ExtType), .MemDataExtType(MemDataExtType)
  );
  datapath datapath(
    //input
    .clk(clk), .rst(rst),
    
    .RegWrite(RegWrite), .RwIdSrc(RwIdSrc),.RwDataSrc(RwDataSrc),
    .MemRead(MemRead), .MemWrite(MemWrite), .MemOpType(MemOpType),
    .BranchType(BranchType), .JumpType(JumpType),
    .AluCtr(AluCtr), .AluBSrc(AluBSrc),
    .ExtType(ExtType), .MemDataExtType(MemDataExtType),
    //output
    .opcode(opcode), .funct(funct), .bit16(bit16)
  );

endmodule