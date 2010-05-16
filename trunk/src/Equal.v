module Equal(
    input1,
    input2,
    result
);

input input1, input2;
output result;

assign result = (input1 == input2) ? 1 : 0 ;

endmodule