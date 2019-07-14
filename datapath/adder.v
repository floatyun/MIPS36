module adder(a, b, ci, 
  sum, co, cf, zf, sf, of
);
  parameter WIDTH = 32;
  
  input [WIDTH-1:0] a,b;
  input ci;

  output [WIDTH-1:0] sum;
  output co;
  output cf,zf,sf,of;

  assign {co,sum}=a+b+ci;
  assign sf = sum[WIDTH-1];
  assign of = (sf^a[WIDTH-1])&(sf^b[WIDTH-1]);
  assign zf = sum==0 ? 1 : 0;
  assign cf = co^ci;
endmodule