module Hazard_Detection(
    IFIDRegRs,
    IFIDRegRt,
    IDEXRegRt,
    IDEXMemRead,
    IDEXRegDST,
    Branch,
    PCWrite,
    IFIDWrite,
    Stall
);

input [4:0] IFIDRegRs, IFIDRegRt, IDEXRegRt, IDEXRegDST;
input IDEXMemRead, Branch;
output PCWrite, IFIDWrite, Stall;

reg PCWrite, IFIDWrite, Stall;
reg [1:0] Stall_Counter;

always @ (IFIDRegRs, IFIDRegRt, IDEXRegRt, IDEXRegDST, IDEXMemRead, Branch) begin
if (IDEXMemRead && ((IDEXRegRt == IFIDRegRs) || (IDEXRegRt == IFIDRegRt))) begin
  if (Branch == 1) begin
    PCWrite <= 0;
    IFIDWrite <= 0;
    Stall <= 1;
    Stall_Counter <= 2'b01;
  end else begin
    PCWrite <= 0;
    IFIDWrite <= 0;
    Stall <= 1;
    Stall_Counter <= 2'b00;
  end 
end else if (Stall == 0 && Branch == 1 && ((IDEXRegDST == IFIDRegRs) || (IDEXRegDST == IFIDRegRt))) begin
    PCWrite <= 0;
    IFIDWrite <= 0;
    Stall <= 1;
    Stall_Counter <= 2'b00;
  end else if (Stall_Counter == 2'b01) begin
    PCWrite <= 0;
    IFIDWrite <= 0;
    Stall <= 1;
    Stall_Counter <= 2'b00;
  end else begin
    PCWrite <= 1;
    IFIDWrite <= 1;
    Stall <= 0;
  end

end



endmodule