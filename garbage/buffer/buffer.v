module buffer(
	input clock,
	input idata,
	output reg odata
);

	reg [99:0] data;

	always@(posedge clock) begin 
		data <= idata;
		odata <= data;
	end
endmodule
