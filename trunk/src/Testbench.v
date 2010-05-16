// UCA 2010
//=========================================================
// Simple testbench
//=========================================================
// This testbench does not verify the functionality of MIPS CPU.
// It loads "instruction.txt" into instruction memory,
//    simulates MIPS CPU and prints out the internal states
//    of CPU to "output.txt".
// This information helps you to debug.
//
//=========================================================
// You can modify instruction.txt or this testbench file to 
//    verify yor hardware design :)

`define CYCLE_TIME 50

module TestBench;

reg         clk;
reg         rst_n;
integer     i, outfile, counter;

always #(`CYCLE_TIME/2) clk = ~clk;    

SingleCycle_CPU CPU(
    .clk  (clk),
    .rst_n  (rst_n)
);
  
initial begin
    // Initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instr_Memory.memory[i] = 32'b0;
    end
    
    // Initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 8'b0;
    end    
        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Register_File.register[i] = 32'b0;
    end
    
    // Load instructions into instruction memory
    $readmemb("instruction.txt", CPU.Instr_Memory.memory);
    
    // Open output file
    outfile = $fopen("output.txt") | 1;
    
    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example
    
    counter = 0;
    clk = 0;
    rst_n = 0;
    
    #(`CYCLE_TIME/4) 
    rst_n = 1;
    
end
  
always@(posedge clk) begin
    if(counter == 60)    // stop after 60 cycles
        $stop;
        
    // print PC
    $fdisplay(outfile, "PC = %d", CPU.PC.pc_out);
    
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) =%d, R8 (t0) =%d, R16(s0) =%d, R24(t8) =%d", CPU.Register_File.register[0], CPU.Register_File.register[8] , CPU.Register_File.register[16], CPU.Register_File.register[24]);
    $fdisplay(outfile, "R1(at) =%d, R9 (t1) =%d, R17(s1) =%d, R25(t9) =%d", CPU.Register_File.register[1], CPU.Register_File.register[9] , CPU.Register_File.register[17], CPU.Register_File.register[25]);
    $fdisplay(outfile, "R2(v0) =%d, R10(t2) =%d, R18(s2) =%d, R26(k0) =%d", CPU.Register_File.register[2], CPU.Register_File.register[10], CPU.Register_File.register[18], CPU.Register_File.register[26]);
    $fdisplay(outfile, "R3(v1) =%d, R11(t3) =%d, R19(s3) =%d, R27(k1) =%d", CPU.Register_File.register[3], CPU.Register_File.register[11], CPU.Register_File.register[19], CPU.Register_File.register[27]);
    $fdisplay(outfile, "R4(a0) =%d, R12(t4) =%d, R20(s4) =%d, R28(gp) =%d", CPU.Register_File.register[4], CPU.Register_File.register[12], CPU.Register_File.register[20], CPU.Register_File.register[28]);
    $fdisplay(outfile, "R5(a1) =%d, R13(t5) =%d, R21(s5) =%d, R29(sp) =%d", CPU.Register_File.register[5], CPU.Register_File.register[13], CPU.Register_File.register[21], CPU.Register_File.register[29]);
    $fdisplay(outfile, "R6(a2) =%d, R14(t6) =%d, R22(s6) =%d, R30(s8) =%d", CPU.Register_File.register[6], CPU.Register_File.register[14], CPU.Register_File.register[22], CPU.Register_File.register[30]);
    $fdisplay(outfile, "R7(a3) =%d, R15(t7) =%d, R23(s7) =%d, R31(ra) =%d", CPU.Register_File.register[7], CPU.Register_File.register[15], CPU.Register_File.register[23], CPU.Register_File.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 =%d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 =%d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 =%d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c =%d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 =%d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 =%d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 =%d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c =%d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
	
    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
end

  
endmodule
