module signext(data,extdata);

	input [7:0]data;
	
	output [15:0]extdata;
	
	assign extdata = extended(data);
	
	function [15:0]extended;
	
		input [7:0]data;
		begin
		
			if(data[7] == 1'b0) extended = {8'b00000000,data};
			else if(data[7] == 1'b1)  extended = {8'b11111111,data};
		end
	endfunction
	
endmodule
			