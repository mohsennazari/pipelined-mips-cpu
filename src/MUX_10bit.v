module MUX_10bit(
	data1_in,
	data2_in,
	select_in,
	data_out
);

input	[9:0]	data1_in;
input	[9:0]	data2_in;
input	select_in;
output	[9:0]	data_out;

assign data_out = (select_in) ? data1_in : data2_in;

endmodule