module multiplexer
(
	input [15:0] a0,
	input [15:0] b1,
	input s,
	output [15:0] z
);

	assign z = oz(a0, b1, s);

	function [15:0] oz
	(
		input [15:0] ia0,
		input [15:0] ib1,
		input is
	);
		begin 
			if(is == 1'b0) begin
				oz = ia0;
			end
			else begin
				oz = ib1;
			end
		end
	endfunction
  
endmodule
