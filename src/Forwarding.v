module Forwarding(
    IdExRegRs,
    IdExRegRt,
    ExMemRegWrite,
    ExMemRegRd,
    MemWbRegWrite,
    MemWbRegRd,
    ForwardA,	
    ForwardB,
);

input [4:0] IdExRegRs, IdExRegRt, ExMemRegRd, MemWbRegRd; 
input ExMemRegWrite,  MemWbRegWrite;
output [1:0] ForwardA, ForwardB;

reg [1:0] ForwardA, ForwardB;

always @ (IdExRegRs or IdExRegRt or ExMemRegRd or MemWbRegRd or ExMemRegWrite or MemWbRegWrite)
if (ExMemRegWrite && (ExMemRegRd != 0) && (ExMemRegRd == IdExRegRs))
    ForwardA <= 2'b10;
else if (MemWbRegWrite && (MemWbRegRd != 0) && (MemWbRegRd == IdExRegRs))
    ForwardA <= 2'b01;
else
    ForwardA <= 2'b00;

if (ExMemRegWrite && (ExMemRegRd != 0) && (ExMemRegRd == IdExRegRt))
    ForwardB <= 2'b10;
else if (MemWbRegWrite && (MemWbRegRd != 0) && (MemWbRegRd == IdExRegRt))
    ForwardB <= 2'b01;
else
    ForwardB <= 2'b00;

endmodule
