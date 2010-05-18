module Equal(
    input1,
    input2,
    result
);

input [31:0] input1, input2;
output result;

assign result = (input1 == input2) ? 1 : 0 ;

endmodule