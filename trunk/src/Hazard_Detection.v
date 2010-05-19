module Hazard_Detection(
    IFIDRegRs,
    IFIDRegRt,
    IDEXRegDST,
    IDEXMemRead,
    IDEXRegWrite,
    Branch,
    Stall
);

input [4:0] IFIDRegRs, IFIDRegRt, IDEXRegDST;
input IDEXMemRead, Branch, IDEXRegWrite;
output Stall;

reg Stall, Stall2;

initial begin
  Stall <= 0;
  Stall2 <= 0;
end

always @ (IFIDRegRs or IFIDRegRt or IDEXRegDST or IDEXMemRead or Branch or IDEXRegWrite) begin
  if (Stall)
    Stall <= 0;
  
  if (Branch) begin
    if (IDEXMemRead && ((IFIDRegRs == IDEXRegDST) || (IFIDRegRt == IDEXRegDST))) begin
      Stall <= 1;
      Stall2 <= 1;
    end else if (IDEXRegWrite && ((IFIDRegRs == IDEXRegDST) || (IFIDRegRt == IDEXRegDST))) begin
      Stall <= 1;
      Stall2 <= 0;
    end
  end else if ((IDEXMemRead && ((IFIDRegRs == IDEXRegDST) || (IFIDRegRt == IDEXRegDST))) || Stall2) begin
      Stall <= 1;
      Stall2 <= 0;
  end else begin
      Stall <= 0; 
  end

end

endmodule