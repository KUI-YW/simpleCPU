module jumper
(
	input [15:0] instr,
	input [11:0] instr_address, 
	output [11:0] jump_address,
	output is_jump
);

	assign {jump_address,is_jump} = f(instr,instr_address);
	
	function [12:0] f(
		input [15:0] instr,
		input [11:0] instr_address
	);
		begin
		
			reg [1:0] op1 = instr[15:14];
			reg [2:0] op2 = instr[13:11];
			reg [7:0] d = instr[7:0];
			reg [11:0] exd = (d[7] ? {4'b1111,d} : {4'b0000,d});
			
			reg [11:0] _jump_address = (instr_address + 1'b1);
			reg _is_jump = 1'b0;
		
			if(op1 == 2'b10 & op2 == 3'b100) begin
				_jump_address = (instr_address + 1'b1 + exd);
				_is_jump = 1'b1;
			end 
			else begin 
				_jump_address = (instr_address + 1'b1);
				_is_jump = 1'b0;
			end
			
			f = {_jump_address,_is_jump};
			
		end
		
	endfunction
	
endmodule
