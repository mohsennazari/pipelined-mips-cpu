// UCA 2010
//=========================================================
// Instruction memory (read-only)
//=========================================================

module Instr_Memory(
    addr,
    instr
);

// Interface
input   [31:0]  addr;
output  [31:0]  instr;

// Instruction memory is byte-addressable, instructions are word-aligned
// Instruction memory with 256 32-bit words
// Instruction address range: 0x0000 ~ 0x03FC
parameter MEM_SIZE=256;
reg     [31:0] memory  [0:MEM_SIZE-1];

assign  instr = memory[addr>>2];  

endmodule
