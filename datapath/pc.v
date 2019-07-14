module pc(
  input rst,clk,
  input [31:0] NPC,
  output reg [31:0] PC
);
  initial 
  begin 
     PC = 32'h0000_3000;
  end
  always@(posedge clk)
  begin
    PC <= rst ? 32'h0000_3000 : NPC;
  end
endmodule
// ������ģ�36��ֱ�Ӹ���11����