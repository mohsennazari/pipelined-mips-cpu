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
	 IF_IDWrite, Flush, RegWrite_EX;
wire [2:0] ALUOp, ALUCtrl;
wire [4:0] mux_RegDST,
			// --> Pipelined CPU
			RS_to_FW, RT_to_FW, RT_to_mux_5bit_ID_EX, RD_to_mux_5bit_ID_EX;
// --> Pipelined CPU
wire [7:0] mux_8bit_ID_EX_out;
wire [31:0] mux_ALUSrc, mux_Branch, mux_MemtoReg, Instr, pc, PC_4, Rs_Data, Rt_Data, Immediate, Offset, PC_Offset, ALUResult, MemData,
			// --> Pipelined CPU
			PC_4_ID, Rs_Data_EX, Rt_Data_EX, Immediate_EX;

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
	// TODO: Fill above.
);

ID_EX ID_EX(
	.clk				(clk),
	.rst				(rst_n),
	.RegWrite_in		(mux_8bit_ID_EX_out[7]),		// WB
	.MemtoReg_in		(mux_8bit_ID_EX_out[6]),		// WB
	.MemRead_in			(mux_8bit_ID_EX_out[5]),		// M
	.MemWrite_in		(mux_8bit_ID_EX_out[4]),		// M
	.ALUSrc_in			(mux_8bit_ID_EX_out[3]),		// EX
	.ALUOp_in			(mux_8bit_ID_EX_out[2:1]),		// EX
	.RegDst_in			(mux_8bit_ID_EX_out[0]),		// EX
	.RegRsData_in		(Rs_Data),
	.RegRtData_in		(Rt_Data),
	.Immediate_in		(Immediate),
	.instr_Rs_addr_in 	(Instr[25:21]),
	.instr_Rt_addr_a_in (Instr[20:16]),
	.instr_Rt_addr_b_in (Instr[20:16]),
	.instr_Rd_addr_in	(Instr[15:11]),
	.RegWrite_out		(RegWrite_EX),		// WB
	.MemtoReg_out		(MemtoReg_EX),		// WB
	.MemRead_out		(MemRead_EX),		// M
	.MemWrite_out		(MemWrite_EX),		// M
	.ALUSrc_out			(ALUSrc),			// EX
	.ALUOp_out			(ALUOp),			// EX
	.RegDst_out			(RegDST),			// EX
	.RegRsData_out		(Rs_Data_EX),
	.RegRtData_out		(Rt_Data_EX),
	.Immediate_out		(Immediate_EX),
	.instr_Rs_addr_out	(RS_to_FW),
	.instr_Rt_addr_a_out(RT_to_FW),
	.instr_Rt_addr_b_out(RT_to_mux_5bit_ID_EX),
	.instr_Rd_addr_out	(RD_to_mux_5bit_ID_EX)
);

MUX_8bit mux_8bit_ID_EX(
	.data1_in	(),
	.data2_in	(8'b0),
	.select_in	(),
	.data_out	(mux_8bit_ID_EX_out),
	// TODO: Fill the above. 
	// Possibly we need a control signal for one of the data_in.
);

MUX_5bit mux_5bit_ID_EX(
    .data1_in	(RT_to_mux_5bit_ID_EX),
    .data2_in	(RD_to_mux_5bit_ID_EX),
    .select_in	(RegDST),
    .data_out	(mux_ID_EX_out)
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
