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
	instr_out
);

// Input - Output Ports
input			clk, rst, hazard_in, flush_in;
input	[31:0]	PC_4_in, instr_in;
output	[31:0]	PC_4_out, instr_out;

// Registers
reg		[31:0]	PC_4_out;
reg		[31:0]	instr_out;

// Procedure
always @(posedge clk or negedge rst) begin
	// Stage2 Data <= 0
	// ----------------
	if (~rst) begin
		PC_4_out <=  32'b0;
		instr_out <= 32'b0;
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
				PC_4_out <= 32'b0;
				instr_out <= 32'b0;
			end
			else begin
				PC_4_out <= PC_4_in;
				instr_out <= instr_in;
			end
		end
	end
end

endmodule