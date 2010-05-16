// UCA 2010
//=========================================================
// Pipelined CPU
//=========================================================
// Supported instructions
// R-type: add, sub, and, or, slt
// I-type: addi, andi, ori, lw, sw, beq
// 		   nop: no operation (instruction format: 32b'0)
//=========================================================
// Input/Output Signals:
// positive-edge triggered clock    clk
// active low asynchronous reset    rst_n
//
//=========================================================
// Wire/Reg Specifications:
// control signals                  RegDST, Branch, MemRead,
//                                  MemtoReg, ALUOp, MemWrite,   
//                                  ALUSrc, RegWrite
// MUX output signals               MUX_RegDST, MUX_ALUSrc, 
//                                  MUX_Branch, MUX_MemtoReg
//
//=========================================================

module SingleCycle_CPU(
    clk,
    rst_n
);

// input/output declaration
input   clk, rst_n;

// Wire/Reg declaration
wire RegDST, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, Zero, Branch_Zero, 
	 // --> Pipelined CPU
	 IF_IDWrite, Flush;
wire [2:0] ALUOp, ALUCtrl;
wire [4:0] mux_RegDST;
wire [31:0] mux_ALUSrc, mux_Branch, mux_MemtoReg, Instr, pc, PC_4, Rs_Data, Rt_Data, Immediate, Offset, PC_Offset, ALUResult, MemData,
			// --> Pipelined CPU
			PC_4_ID;

assign Offset = Immediate << 2;
assign Branch_Zero = Branch & Zero;
   

PC PC(
    .clk        (clk),
    .rst_n      (rst_n),
    .pc_in      (mux_Branch),
    .pc_out     (pc)
);


Adder PC_Add_4(
    .data1_in   (pc),
    .data2_in   (32'd4),
    .data_out   (PC_4)
);


Instr_Memory Instr_Memory(
    .addr       (pc), 
    .instr      (Instr)
);

IF_ID IF_ID(
	.clk		(clk),
	.rst		(rst_n),
	.PC_4_in	(PC_4),
	.instr_in	(),
	.hazard_in	(IF_IDWrite),
	.flush_in	(Flush),
	.PC_4_out	(PC_4_ID),
	.instr_out	(),
);


Control Control(
    .opcode     (Instr[31:26]),
    .RegDst     (RegDST),
    .Branch     (Branch),
    .MemRead    (MemRead),
    .MemtoReg   (MemtoReg),
    .ALUOp      (ALUOp),
    .MemWrite   (MemWrite),
    .ALUSrc     (ALUSrc),
    .RegWrite   (RegWrite)
);


MUX_5bit MUX_RegDst(
    .data1_in   (Instr[20:16]),
    .data2_in   (Instr[15:11]),
    .select     (RegDST),
    .data_out   (mux_RegDST)
);


Register_File Register_File(
    .clk        (clk),
    .Rs_addr    (Instr[25:21]),
    .Rt_addr    (Instr[20:16]),
    .Rd_addr    (mux_RegDST), 
    .Rd_data    (mux_MemtoReg),
    .RegWrite   (RegWrite), 
    .Rs_data    (Rs_Data), 
    .Rt_data    (Rt_Data) 
);


Signed_Extend Signed_Extend(
    .data_in    (Instr[15:0]),
    .data_out   (Immediate)
);


Adder PC_Add_Offset(
    .data1_in   (PC_4),
    .data2_in   (Offset),
    .data_out   (PC_Offset)
);



MUX_32bit MUX_ALUSrc(
    .data1_in   (Rt_Data),
    .data2_in   (Immediate),
    .select     (ALUSrc),
    .data_out   (mux_ALUSrc)
);


ALU_Control ALU_Control(
    .funct      (Instr[5:0]),
    .ALUOp      (ALUOp),
    .ALUCtrl    (ALUCtrl)
);

  
ALU ALU(
    .data1_in   (Rs_Data),
    .data2_in   (mux_ALUSrc),
    .ALUCtrl    (ALUCtrl),
    .data       (ALUResult),
    .Zero       (Zero)
);


MUX_32bit MUX_Branch(
    .data1_in   (PC_4),
    .data2_in   (PC_Offset),
    .select     (Branch_Zero),
    .data_out   (mux_Branch)
);


Data_Memory Data_Memory(
    .clk        (clk),
    .addr       (ALUResult),
    .data_in    (Rt_Data),
    .MemRead    (MemRead),
    .MemWrite   (MemWrite),
    .data_out   (MemData)
);


MUX_32bit MUX_MemtoReg(
    .data1_in   (ALUResult),
    .data2_in   (MemData),
    .select     (MemtoReg),
    .data_out   (mux_MemtoReg)
);

endmodule
