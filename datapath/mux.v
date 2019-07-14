module mux #(parameter WIDTH = 32) (i0, i1, sel,out);
  input [WIDTH - 1:0] i0,i1;
  input sel;
  output [WIDTH - 1:0] out;
  assign out = sel ? i1 : i0;
endmodule

// 本来是4选1复用mux的，然而发生了奇怪的错误

module mux4 #(parameter WIDTH = 32) (
  i00, i01,
  i10, i11,
  sel,
  out
);
  input [WIDTH - 1:0] i00, i01, i10, i11;
  output [WIDTH - 1:0] out;
  input [1:0] sel;
  assign out = (sel[1]) ?
          ( (sel[0]) ? i11 : i10 ) :
          ( ((sel[0]) ? i01 : i00 ) );
endmodule

module mux8 #(parameter WIDTH = 32) (
  i000, i001, i010, i011,
  i100, i101, i110, i111,
  sel,
  out
);
  input [WIDTH - 1:0] i000, i001, i010, i011, i100, i101, i110, i111;
  output [WIDTH - 1:0] out;
  input [2:0] sel;
  assign out = (sel[2]) ?
          ( (sel[1]) ?
          ( (sel[0]) ? i111 : i110 ) :
          ( ((sel[0]) ? i101 : i100 ) ) ) 
              :
            ( (sel[1]) ?
          ( (sel[0]) ? i011 : i010 ) :
          ( ((sel[0]) ? i001 : i000 ) ) );
endmodule


/*module mux4 #(parameter WIDTH = 32) (
  i00, i01,
  i10, i11,
  sel,
  out
);
  input [WIDTH - 1:0] i00, i01, i10, i11;
  output [WIDTH - 1:0] out;
  input [1:0] sel;
  wire [WIDTH - 1:0] out0, out1;
  mux #(.WIDTH(WIDTH)) mux_lowpart0(
    .i0(i00), .i1(i01), .sel(sel[0]), .out(out0)
  );
  mux #(.WIDTH(WIDTH)) mux_lowpart1(
    .i0(i10), .i1(i11), .sel(sel[0]), .out(out1)
  );
  mux #(.WIDTH(WIDTH)) mux(
    .i0(out0), .i1(out1), .sel(sel[1]), .out(out)
  );
endmodule

module mux8 #(parameter WIDTH = 32) (
  i000, i001, i010, i011,
  i100, i101, i110, i111,
  sel, out
);
  input [WIDTH - 1:0] i000, i001, i010, i011, i100, i101, i110, i111;
  output [WIDTH - 1:0] out;
  input [2:0] sel;
  wire [WIDTH - 1:0] out0, out1;
  mux4 #(.WIDTH(WIDTH)) mux_lowpart0(
    .i00(i000), .i01(i001),
    .i10(i010), .i11(i011),
    .sel(sel[1:0]), .out(out0)
  );
  mux4 #(.WIDTH(WIDTH)) mux_lowpart1(
    .i00(i100), .i01(i101),
    .i10(i110), .i11(i111),
    .sel(sel[1:0]), .out(out0)
  );
  mux #(.WIDTH(WIDTH)) mux(
    .i0(out0), .i1(out1), .sel(sel[2]), .out(out)
  );
endmodule*/
