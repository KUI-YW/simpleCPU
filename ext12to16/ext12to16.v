module ext12to16(
	input [11:0] idata,
	output wire [15:0] odata
);
	
	assign odata[15:12] = 4'b0000;
	assign odata[11:0]  = idata;
	
endmodule
