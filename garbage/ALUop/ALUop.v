module ALUop
(
	input [15:0] instr,
	output wire [3:0] op
);

	assign op = instr_to_ALUop(instr);
	
	function [3:0] instr_to_ALUop;
		input [15:0] iinstr;
		begin
			if(iinstr[15:14] == 2'b00) begin 
				instr_to_ALUop = 4'b0000;
			end 
			else if(iinstr[15:14] == 2'b01) begin 
				instr_to_ALUop = 4'b0000;
			end 
			else if(iinstr[15:14] == 2'b10) begin 
				if(iinstr[13:11] == 3'b111) begin 
					instr_to_ALUop = 4'b0101;
				end
				else begin 
					instr_to_ALUop = 4'b0101;
				end
			end 
			else begin
				instr_to_ALUop = iinstr[7:4];
			end
		end
	endfunction
 
 endmodule
