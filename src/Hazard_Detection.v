module Hazard_Detection(
    IFIDRegRs,
    IFIDRegRt,
    IDEXRegRt,
    IDEXMemRead,
    PCWrite,
    IFIDWrite,
    Stall,
);

input [4:0] IFIDRegRs, IFIDRegRt, IDEXRegRt;
input IDEXMemRead;
output PCWrite, IFIDWrite, Stall;

reg PCWrite, IFIDWrite, Stall;

always @ (IDEXMemRead or IDEXRegRt or IFIDRegRs or IFIDRegRt)
if(IDEXMemRead && ((IDEXRegRt == IFIDRegRs) || (IDEXRegRt == IFIDRegRt))) begin
    PCWrite <= 0;
    IFIDWrite <= 0;
    Stall <= 1;
end else begin
    PCWrite <= 1;
    IFIDWrite <= 1;
    Stall <= 0;
end


endmodule