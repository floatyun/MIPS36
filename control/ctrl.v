`include "ctrl_signals_def.v"
module ctrl(
  input [5:0] opcode, funct,
  input bit16,

  output reg RegWrite,
  output reg [1:0] RwIdSrc, RwDataSrc,

  output reg MemRead, MemWrite, MemOpType,

  output reg [2:0] BranchType,
  output reg [1:0] JumpType,

  output reg [4:0] AluCtr,
  output reg [1:0] AluBSrc,
  
  output reg ExtType, MemDataExtType
);

// MemDataExtType 仅仅当MemRead或者MemWrite有效时方有效

always@(opcode or funct or bit16)
begin
  if (opcode == `Most_R_Type_op) begin
    // differ by funct
    RegWrite = `True;
     // 对于jalr和jr而言，下面的设置也是正确的。
     // 对于jr的rd是0号寄存器，始终为0，写入操作被忽略
     // 对于jalr而言，rd是11111，恰好是ra寄存器，因此设为rd是正确的。
    RwIdSrc = `RwIdSrc_rd;
    //RwDataSrc = (funct == `funct_jalr) ? `RwDataSrc_pc1 : `RwDataSrc_alu;
    MemRead = `False; MemWrite = `False; //MemOpType = `MemByWord; MemOpType no need to set
    // branch and jump
    BranchType = `no_branch;
    // 因为只有jr，jalr JumpType才有效
    if (funct == `funct_jr || funct == `funct_jalr) begin
      JumpType = `RegTypeJump; RwDataSrc = `RwDataSrc_pc1;
    end else begin
      JumpType = `No_Jump; RwDataSrc =`RwDataSrc_alu;
    end

    // for alu
    AluBSrc = `aluBsrc_rt;
    case (funct)
      `funct_addu : AluCtr = `alu_addu;
      `funct_subu : AluCtr = `alu_subu;
      `funct_slt : AluCtr = `alu_slt;
      `funct_and : AluCtr = `alu_and;
      `funct_nor : AluCtr = `alu_nor;
      `funct_or : AluCtr = `alu_or;
      `funct_xor : AluCtr = `alu_xor;
      `funct_sltu : AluCtr = `alu_sltu;
      `funct_sllv : AluCtr = `alu_sllv;
      `funct_srav : AluCtr = `alu_srav;
      `funct_srlv : AluCtr = `alu_srlv;
      `funct_sll : AluCtr = `alu_sll;
      `funct_srl : AluCtr = `alu_srl;
      `funct_sra : AluCtr = `alu_sra;
      `funct_jr : AluCtr = `alu_nop;
      `funct_jalr : AluCtr = `alu_nop;
      default: AluCtr = `alu_nop;
      // 16条
    endcase

    ExtType = `ZeroExt; // not important,0 and 1 is both ok.

  end else if (opcode == `bgez_bltz_op) begin
    // differ by bit16；
    // bgez,bltz
    RegWrite = `False;
    MemRead = `False; MemWrite = `False;
    BranchType = (bit16 == `bit16_bgez) ? `branch_bgez : `branch_bltz;
    JumpType = `OffsetTypeJump;
    AluBSrc = `aluBsrc_zero; AluCtr = `alu_subu; // 通过减法作比较
    ExtType = `SignExt;
  end else begin
    // differ by opcodes
    case (opcode)
      `opcode_addiu:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt; RwDataSrc = `RwDataSrc_alu;
          MemWrite = `False; MemRead = `False;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_addu;
          AluBSrc = `aluBsrc_imm;
          ExtType = `SignExt;
        end
      `opcode_lui:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt; RwDataSrc = `RwDataSrc_alu;
          MemWrite = `False; MemRead = `False;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_lui;
          AluBSrc = `aluBsrc_imm00;
          ExtType = `ZeroExt;
        end
      `opcode_slti:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt;  RwDataSrc = `RwDataSrc_alu;
          MemWrite = `False; MemRead = `False;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_slt;
          AluBSrc = `aluBsrc_imm;
          ExtType = `SignExt;
        end
      `opcode_sltiu:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt;  RwDataSrc = `RwDataSrc_alu;
          MemWrite = `False; MemRead = `False;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_sltu;
          AluBSrc = `aluBsrc_imm;
          ExtType = `SignExt;
        end
      `opcode_andi:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt; RwDataSrc = `RwDataSrc_alu;
          MemWrite = `False; MemRead = `False;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_and;
          AluBSrc = `aluBsrc_imm;
          ExtType = `ZeroExt;
        end
      `opcode_ori:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt; RwDataSrc = `RwDataSrc_alu;
          MemWrite = `False; MemRead = `False;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_or;
          AluBSrc = `aluBsrc_imm;
          ExtType = `ZeroExt;
        end
      `opcode_xori:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt; RwDataSrc = `RwDataSrc_alu;
          MemWrite = `False; MemRead = `False;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_xor;
          AluBSrc = `aluBsrc_imm;
          ExtType = `ZeroExt;
        end
      `opcode_beq:
        begin
          RegWrite = `False; // no need to set RwIdSrc,RwDataSrc
          MemWrite = `False; MemRead = `False;
          JumpType = `OffsetTypeJump;
          BranchType = `branch_beq;
          AluCtr = `alu_subu; AluBSrc = `aluBsrc_rt;
          ExtType = `SignExt;
        end
      `opcode_bne:
        begin
          RegWrite = `False; // no need to set RwIdSrc,RwDataSrc
          MemWrite = `False; MemRead = `False;
          JumpType = `OffsetTypeJump;
          BranchType = `branch_bne;
          AluCtr = `alu_subu; AluBSrc = `aluBsrc_rt;
          ExtType = `SignExt;
        end
      `opcode_bgtz:
        begin
          RegWrite = `False; // no need to set RwIdSrc,RwDataSrc
          MemWrite = `False; MemRead = `False;
          JumpType = `OffsetTypeJump;
          BranchType = `branch_bgtz;
          AluCtr = `alu_subu; AluBSrc = `aluBsrc_zero;
          ExtType = `SignExt;
        end
      `opcode_blez:
        begin
          RegWrite = `False; // no need to set RwIdSrc,RwDataSrc
          MemWrite = `False; MemRead = `False;
          JumpType = `OffsetTypeJump;
          BranchType = `branch_blez;
          AluCtr = `alu_subu; AluBSrc = `aluBsrc_zero;
          ExtType = `SignExt;
        end
      `opcode_lw:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt; RwDataSrc = `RwDataSrc_dm;
          MemRead = `True; MemWrite = `False; MemOpType = `MemByWord;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_addu; AluBSrc = `aluBsrc_imm;
          ExtType = `SignExt; // no need to set MemDataExtType
        end
      `opcode_lb:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt; RwDataSrc = `RwDataSrc_dm;
          MemRead = `True; MemWrite = `False; MemOpType = `MemByByte;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_addu; AluBSrc = `aluBsrc_imm;
          ExtType = `SignExt; MemDataExtType = `SignExt;
        end
      `opcode_lbu:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_rt; RwDataSrc = `RwDataSrc_dm;
          MemRead = `True; MemWrite = `False; MemOpType = `MemByByte;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_addu; AluBSrc = `aluBsrc_imm;
          ExtType = `SignExt; MemDataExtType = `ZeroExt;
        end
      `opcode_sw:
        begin
          RegWrite = `False; // no need to set RwIdSrc RwDataSrc
          MemRead = `False; MemWrite = `True; MemOpType = `MemByWord;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_addu; AluBSrc = `aluBsrc_imm;
          ExtType = `SignExt; // no need to set MemDataExtType
        end
      `opcode_sb:
        begin
          RegWrite = `False; // no need to set RwIdSrc RwDataSrc
          MemRead = `False; MemWrite = `True; MemOpType = `MemByByte;
          JumpType = `No_Jump; BranchType = `no_branch;
          AluCtr = `alu_addu; AluBSrc = `aluBsrc_imm;
          ExtType = `SignExt; // no need to set MemDataExtType
          // emmm, how to only write a byte in dm? maybe need change dm,
          // add a MemOpType signal to dm
          // yes, that's ok!
        end
      `opcode_j:
        begin
          RegWrite = `False; // no need to set RwIdSrc RwDataSrc
          MemRead = `False; MemWrite = `False; // no need to set MemOpType
          JumpType = `PseudoTypeJump; BranchType = `no_branch;
          AluCtr = `alu_nop; // no need to set AluBSrc
          //use another special ext-module, no need to set ExtType signal
        end
      `opcode_jal:
        begin
          RegWrite = `True; RwIdSrc = `RwIdSrc_ra; RwDataSrc = `RwDataSrc_pc1;
          MemRead = `False; MemWrite = `False; // no need to set MemOpType
          JumpType = `PseudoTypeJump; BranchType = `no_branch;
          AluCtr = `alu_nop; // no need to set AluBSrc
          //use another special ext-module, no need to set ExtType signal
        end
    endcase
  end
end
endmodule