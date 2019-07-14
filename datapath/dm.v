`include "..\\control\\ctrl_signals_def.v"
module dm_4k(
  addr, d_in,
  wr_en, d_out,
  MemOpType, MemDataExtType, 
  ByteOff,
  clk
);
  input [11:2] addr;
  input MemOpType, MemDataExtType;
  input [1:0] ByteOff;
  input [31:0] d_in;
  input wr_en;
  input clk;
  output [31:0]d_out;
  reg [31:0] dm[1023:0];
  wire [7:0] byte, be_to_wr_byte;
  wire [31:0] word_buffer, byte_ext_word;
  integer i;
  initial
  begin
    for(i = 0;i < 1024;i = i + 1)
    dm[i] = 32'b0; // ��ʼ��0
  end
  assign word_buffer = dm[addr[11:2]];
  //��ȥȡ��word������byteOff 4ѡ1 ѡbyte 
  // byte ��չ(���͸��ݿ����źž���)��byte_ext_word
  // 2ѡ1 word or byte_ext_word��Ϊdm�����������dm�ǰ����ֽڻ����ֶ���
  mux4 #(.WIDTH(8)) byte_mux(
    .i00(word_buffer[7:0]),
    .i01(word_buffer[15:8]),
    .i10(word_buffer[23:16]),
    .i11(word_buffer[31:24]),
    .sel(ByteOff),
    .out(byte)
  );
  
  ext #(.WIDTH(8), .BIGWIDTH(32)) ext_byte_ext_word(
    .in(byte),
    .ExtType(MemDataExtType),
    .out(byte_ext_word)
  );
  
  mux sel_memOpType(
    .i0(byte_ext_word), // byte type
    .i1(word_buffer), // word type
    .sel(MemOpType),
    .out(d_out)
  );
  
  assign be_to_wr_byte = d_in[7:0];
  
  always@(posedge clk)
  begin
    if (wr_en)
      if (MemOpType == `MemByByte)
      begin
        // big endian
        case (ByteOff)
         2'b00: dm[addr[11:2]][7:0] <= be_to_wr_byte;
         2'b01: dm[addr[11:2]][15:8] <= be_to_wr_byte;
         2'b10: dm[addr[11:2]][23:16] <= be_to_wr_byte;
         2'b11: dm[addr[11:2]][31:24] <= be_to_wr_byte;
        endcase
      end else 
      begin
        dm[addr[11:2]][31:0] <= d_in;
      end
  end
endmodule
