module ext #(parameter WIDTH = 16,BIGWIDTH = 32)(in, out, ExtType);
  input [WIDTH - 1:0]in;
  input ExtType;
  output [BIGWIDTH - 1:0]out;
  assign out = ExtType ? 
                  {{BIGWIDTH-WIDTH{in[WIDTH - 1]}},in} :
                    {{BIGWIDTH-WIDTH{1'b0}},in};
endmodule
