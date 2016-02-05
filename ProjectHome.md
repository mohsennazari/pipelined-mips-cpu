This project aims to implement a 5-stage pipelined MIPS CPU with data and control hazard detections in Verilog. For the beginning, the supported instructions would be:

```
R-type: add, sub, and, or, slt
I-type: addi, andi, ori, lw, sw, beq

nop: no operation (instruction format: 32b'0)
```

Hardware Specs:

---


  * Register File：32 × 32-bit Registers
  * Instruction Memory：1KB (256 × 32-bit )
  * Data Memory：32 Bytes (Memories are modeled in Verilog simply as an array of registers, so we did not care about the memory latency)
  * Address space: Text segment and data segment both begin at address 0x0000 for convenience, different from the real MIPS machine