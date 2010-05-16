/* =============================================================================
 *
 * Name           : ALU.v
 * Author         : Hakki Caner Kirmizi
 * Date           : 2010-5-1
 * Description    : A module which implements an ALU unit for the excution of
 *					instruction. Supported instructions: add, sub, and, or, slt, 
					addi, andi, ori, lw, sw, beq
 * References	  : http://personal.denison.edu/~bressoud/cs281-s08/homework/MIPSALU.html
 * 
 * Note: 'addi, andi, ori' are already covered in their R-format counterparts. 
 * We assume that 6-bit function code which is input to the ALU control 
 * circuit will be correctly generated at the main control circuit.
 * =============================================================================
*/

module ALU(
	data1_in,
	data2_in,
	ALUCtrl,
	data,
	Zero
);

input	[31:0]	data1_in;
input	[31:0]	data2_in;
input	[2:0]	ALUCtrl;
output	[31:0]	data;
output			Zero;

reg [31:0] data;
reg Zero;

always @(data1_in or data2_in or ALUCtrl) begin
	// ALUCtrl = 010 (add, lw, sw)
	if (~ALUCtrl[2] & ALUCtrl[1] & ~ALUCtrl[0]) begin
		data = data1_in + data2_in;
		if (data == 32'b0) begin
			Zero = 1'b1;
		end
		else begin
			Zero = 1'b0;
		end
	end
	
	// ALUCtrl = 110 (sub, beq)
	if (ALUCtrl[2] & ALUCtrl[1] & ~ALUCtrl[0]) begin
		data = data1_in - data2_in;
		if (data == 32'b0) begin
			Zero = 1'b1;
		end
		else begin
			Zero = 1'b0;
		end
	end
	
	// ALUCtrl = 000 (and)
	if (~ALUCtrl[2] & ~ALUCtrl[1] & ~ALUCtrl[0]) begin
		data = data1_in & data2_in;
		if (data == 32'b0) begin
			Zero = 1'b1;
		end
		else begin
			Zero = 1'b0;
		end
	end
	
	// ALUCtrl = 001 (or)
	if (~ALUCtrl[2] & ~ALUCtrl[1] & ALUCtrl[0]) begin
		data = data1_in | data2_in;
		if (data == 32'b0) begin
			Zero = 1'b1;
		end
		else begin
			Zero = 1'b0;
		end
	end
	
	// ALUCtrl = 111 (slt)
	// We do not need to set/reset Zero
	if (ALUCtrl[2] & ALUCtrl[1] & ALUCtrl[0]) begin
		if ((data1_in - data2_in) < 0) begin
			data = 32'b1;
		end
		else begin
			data = 32'b0;
		end
	end
end

endmodule