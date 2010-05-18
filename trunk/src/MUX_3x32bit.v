module MUX_3x32bit(    
    data0_in,
    data1_in,
    data2_in,
    select,
    data_out
);

input [31:0] data0_in, data1_in, data2_in;
input [1:0] select;
output [31:0] data_out;

assign data_out = (select[1]) ? data2_in : ((select[0]) ? data1_in : data0_in);

endmodule
