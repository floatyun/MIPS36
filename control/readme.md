## 思路
大致需要考虑以下几个问题
- 是否需要写入寄存器 1bit RegWrite
- 写入的寄存器地址（编号）RwSrc 来源——指令固定的rt、rd、ra(31) 2bits
- 写入寄存器的数据流来源 RwDataSrc ALU 运算结果、存储器读出来的、计算的B_PC+4？

- 是否需要读主存 MemRead
- 读取类型 按照字、字节 MemOpType

- 是否需要往dm写入 MemWrite
- 写入dm的类型  字、字节  MemOpType

- 跳转类型——8种，其中jr和jalr的Branch信号是一致，它们行为的差异靠RegWrite控制信号来区分；其余7个跳转有关的指令各自占一个branch信号段  但是 3bits Branch
- 跳转目标地址类型 offset有符号拓展计算而来（01）、寄存器直接读取（10），PseudoAddr增加相关位（11），不跳 （00）2bits 

- AluSrc  Alu的第二个参数B的来源 寄存器，立即数拓展，固定0

**ctrl的输入opcode，funct，bit16(用于区分bgez,gltz),这三个东西是datapath的输出
ctrl输出各种控制信号，作为datapath的输入**
另外，datapath还需要clk,rst作为输入

---

write by  lly(稻云麦花)
冲呀，知世就是力量
