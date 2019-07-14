// opcode
`define Most_R_Type_op 6'b000000 // need differ  by funct
/*contains follow
sllv
srlv
srav
sllv
srlv
srav
jr
jalr
addu
subu
and
or
xor
nor
slt
sltu
*/
`define bgez_bltz_op 6'b000001 // need differ by bit16
// can differ by just opcode
`define opcode_addiu 6'b001001
`define opcode_lui 6'b001111
`define opcode_slti 6'b001010
`define opcode_sltiu 6'b001011
`define opcode_andi 6'b001100
`define opcode_ori 6'b001101
`define opcode_xori 6'b001110
`define opcode_beq 6'b000100
`define opcode_bne 6'b000101
`define opcode_bgtz 6'b000111
`define opcode_blez 6'b000110
`define opcode_lw 6'b100011
`define opcode_sw 6'b101011
`define opcode_lb 6'b100000
`define opcode_lbu 6'b100100
`define opcode_sb 6'b101000
`define opcode_j 6'b000010
`define opcode_jal 6'b000011

// bit16
`define bit16_bgez 1
`define bit16_bltz 0

// funct
`define funct_addu 6'b100001
`define funct_subu 6'b100011
`define funct_slt 6'b101010
`define funct_and 6'b100100
`define funct_nor 6'b100111
`define funct_or 6'b100101
`define funct_xor 6'b100110
`define funct_sltu 6'b101011
`define funct_sllv 6'b000100
`define funct_srav 6'b000111
`define funct_srlv 6'b000110
`define funct_sll 6'b000000
`define funct_srl 6'b000010
`define funct_sra 6'b000011
`define funct_jr 6'b001000
`define funct_jalr 6'b001001
// 16条
// RwIdSrc 写入寄存器的编号是由什么字段决定的
`define RwIdSrc_rt 2'b00  // rt字段决定
`define RwIdSrc_rd 2'b01  // rd字段决定
`define RwIdSrc_ra 2'b10  // 固定的ra(31)号寄存器

// RwDataSrc
`define RwDataSrc_alu 2'b00
`define RwDataSrc_dm 2'b01
`define RwDataSrc_pc1 2'b10 // 计算出来的pc+4

// MemOpType
`define MemByWord 1'b1
`define MemByByte 1'b0

// Branch Types 分支类型
`define branch_beq 3'd4
`define branch_bne 3'd5
`define branch_bgez 3'd0
`define branch_bgtz 3'd1
`define branch_blez 3'd2
`define branch_bltz 3'd3
`define no_branch 3'd7
// emmm,this is wrong
//`define branch_jr 3'd6
//`define branch_jalr 3'd6
//`define branch_jal 3'd7


// Jump Types 跳转类型
`define No_Jump 2'b00  // 不跳转
`define OffsetTypeJump 2'b01 // 使用offset计算的地址
`define RegTypeJump 2'b10 // 直接从寄存器读取的数据
`define PseudoTypeJump 2'b11 // 26位直接地址

// ExtType常量
`define SignExt 1'b1
`define ZeroExt 1'b0

// AluCtr信号常量及意义
`define alu_addu 5'd0
`define alu_subu 5'd1
`define alu_slt 5'd2
`define alu_and 5'd3
`define alu_nor 5'd4
`define alu_or 5'd5
`define alu_xor 5'd6
`define alu_sltu 5'd7
`define alu_sllv 5'd8
`define alu_srav 5'd9
`define alu_srlv 5'd10
`define alu_sll 5'd11
`define alu_srl 5'd12
`define alu_sra 5'd13
`define alu_lui 5'd14
//`define alu_add 5'd15 // 虽然指令中没有直接的实现add指令，但是地址的计算需要有符号加
// 不需要，在不考虑溢出抛出异常的情况下，alu的add和addu无差异
`define alu_nop 5'b11111

// AluBSrc Alu运算器B的来源 常量表
`define aluBsrc_rt 2'd0  //  来源于$rt
`define aluBsrc_imm 2'd1  // 立即数经过拓展之后的imm32，具体拓展受ExtOp控制
`define aluBsrc_zero 2'd2  // 指令固定的0
`define aluBsrc_imm00 2'd3 // 立即数后面添16个0的立即数拓展,for lui

`define True 1'b1
`define False 1'b0
`define ra 5'b11111

`define clock_T 30
`define alu_temp_to_alu_res_T 1