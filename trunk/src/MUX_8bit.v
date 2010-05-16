module MUX_8bit(
	data1_in,
	data2_in,
	select_in,
	data_out
);

input	[7:0]	data1_in;
input	[7:0]	data2_in;
input	select_in;
output	[7:0]	data_out;

assign data_out = (select_in == 1'b0) ? data1_in : data2_in;

endmodule