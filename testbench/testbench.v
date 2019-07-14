module test_mips();
reg clk,rst;
mips mips(clk,rst);
initial 
begin
    clk = 0;
    rst = 0;
end
always #30 clk = ~clk;
always
   begin
     #9000 rst = ~rst;
     #20 rst = ~rst;
   end

mips lly_mips(.clk(clk), .rst(rst));
endmodule