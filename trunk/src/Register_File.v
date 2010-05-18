// UCA 2010
//=========================================================
// MIPS general purpose registers
//=========================================================

module Register_File(
    clk,
    Rs_addr,
    Rt_addr,
    Rd_addr, 
    Rd_data,
    RegWrite, 
    Rs_data, 
    Rt_data 
);

// Interface
input           clk;
input   [4:0]   Rs_addr;
input   [4:0]   Rt_addr;
input   [4:0]   Rd_addr;
input   [31:0]  Rd_data;
input           RegWrite;
output  [31:0]  Rs_data; 
output  [31:0]  Rt_data;

// Register file has 32 32-bit registers
reg     [31:0]  register    [0:31];

// Read Data      
assign  Rs_data = (Rs_addr == 5'b0) ? 32'b0 : register[Rs_addr];
assign  Rt_data = (Rt_addr == 5'b0) ? 32'b0 : register[Rt_addr];

// Write Data   
always @(posedge clk)
begin
    if(RegWrite)
        register[Rd_addr] <= Rd_data;
end
   
endmodule 
