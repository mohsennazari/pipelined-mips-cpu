module MUX_2x32bit(    
    data0_in,
    data1_in,
    select,
    data_out
);

input [31:0] data0_in, data1_in;
input select;
output [31:0] data_out;

assign data_out = (select) ? data1_in : data0_in;

endmodule
