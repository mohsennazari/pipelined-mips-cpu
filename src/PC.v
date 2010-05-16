// UCA 2010
//=========================================================
// Programer counter
//=========================================================

module PC(
    clk,
    rst_n,
    pc_in,
    pc_out
);

// Interface
input           clk;
input           rst_n;
input   [31:0]  pc_in;
output  [31:0]  pc_out;

// Wire/Reg
reg     [31:0]  pc_out;

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        pc_out <= 32'b0;
    end
    else
    begin
        pc_out <= pc_in;
    end
end

endmodule
