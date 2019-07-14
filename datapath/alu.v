`include "..\\control\\ctrl_signals_def.v"
module alu (
  A, B, ALUctr, result,
  zero, pos, neg,
  shamt
);
  parameter WIDTH = 32;
  
  input [4:0] ALUctr;
  input [WIDTH-1:0] A, B;
  input [4:0] shamt;
  output reg [WIDTH-1:0] result;
  output zero, pos, neg;
  
  always@(A or B or ALUctr or shamt)
  begin
    case(ALUctr)
      `alu_addu: result <= A + B;
      `alu_subu: result <= (A - B);
      `alu_slt:  result <= ($signed(A) < $signed(B));
      `alu_and:  result <= (A & B);
      `alu_nor:  result <= (~(A | B));
      `alu_or:   result <= (A | B);
      `alu_xor:  result <= (A ^ B);
      `alu_sltu: result <=  (A < B);
      `alu_sllv: result <= (B << A);
      `alu_srav: result <= (($signed(B)) >>> A);
      `alu_srlv: result <= (B >> A);
      `alu_sll:  result <= (B << shamt);
      `alu_srl:  result <= (B >> shamt);
      `alu_sra:  result <= (($signed(B)) >>> shamt);
      `alu_lui:  result <= B;
      `alu_nop:  result <= 32'h0000_0000;
      default:   result <= 32'h0000_0000;
    endcase
  end
  assign zero = (result == 0);
  assign pos = ($signed(result) > 0);
  assign neg = ($signed(result) < 0);
endmodule
