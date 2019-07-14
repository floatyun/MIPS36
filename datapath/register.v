module regfiles(writeEn, rw, busW, ra, rb, busA, busB, clk);
  input clk, writeEn;
  input [4:0] rw, ra, rb;
  input [31:0] busW;
  output [31:0] busA, busB;
  reg [31:0] reg_file[31:0];
  initial 
	begin
	   reg_file[0] = 0; // set $zero to 0. keep $zero=0
	end
  always@(posedge clk)
  begin 
     if(writeEn && (rw != 0)) // keep $zero=0 确保零寄存器始终为0
      reg_file[rw] = busW;
  end
  assign busA = (ra != 0) ? reg_file[ra] : 0;
  assign busB = (rb != 0) ? reg_file[rb] : 0;
endmodule
