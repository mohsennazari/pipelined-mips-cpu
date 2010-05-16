/* =============================================================================
 *
 * Name           : IF_ID.v
 * Author         : Hakki Caner Kirmizi
 * Date           : 2010-5-16
 * Description    : A module that implements the so-called IF-ID (instruction
 *					fetch - instruction decode) pipelined register.
 *
 * =============================================================================
*/

module IF_ID(
	clk,
	rst,
	PC_4_in,
	instr_in,
	hazard_in,
	flush_in,
	PC_4_out,
	instr_out,
);

// Input - Output Ports
input			clk;
input			rst;
input			hazard_in;
input			flush_in;
input	[31:0]	PC_4_in;
input	[31:0]	instr_in
output	[31:0]	PC_4_out;
output	[31:0]	instr_out;

// Registers
reg		[31:0]	PC_4_out;
reg		[31:0]	instr_out;

// Procedure
always @(posedge clk or negedge rst_n) begin
	// Stage2 Data <= 0
	// ----------------
	if (~rst_n) begin
		PC_4_out <= 32b'0;
		instr_out <= 32b'0;
	end
	// Stage2 Data <= Stage1 Data
	// --------------------------
	else begin
		if (~hazard_in) begin
			PC_4_out <= PC_4_out;
			instr_out <= instr_out;
		end
		else begin
			if (flush_in) begin
				PC_4_out <= 32b'0;
				instr_out <= 32b'0;
			end
			else begin
				PC_4_out <= PC_4_out;
				instr_out <= instr_out;
			end
		end
	end
end

endmodule