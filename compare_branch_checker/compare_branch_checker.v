module compare_branch_checker
(
	input [15:0] instr,
	input sign_flag,
	input zero_flag,
	input overflow_flag,
	input [15:0] instr_address,
	output [11:0] cmpb_address,
	output is_cmpb_satisfied
);

	assign {cmpb_address,is_cmpb_satisfied} = f(instr, sign_flag, zero_flag, overflow_flag, instr_address);
	
	function [12:0] f(
		input [15:0] instr,
		input s,
		input z,
		input v,
		input [15:0] instr_address
	);
		begin
			
			reg [1:0] op1 = instr[15:14];
			reg [2:0] op2 = instr[13:11];
			reg [2:0] cond = instr[10:8];
			reg signed [7:0] d = instr[7:0];
			reg signed [11:0] exd = (d[7] ? {4'b1111,d} : {4'b0000,d});
			reg [11:0] pc = instr_address[11:0];
			
			reg is_satisfied = 1'b0;
			reg [11:0] branch_address = 12'h000;
		
			if(op1 == 2'b10 & op2 == 3'b111) begin
				case (cond)
					3'b000 : is_satisfied = z;
					3'b001 : is_satisfied = (s ^ v);
					3'b010 : is_satisfied = (z | (s ^ v));
					3'b011 : is_satisfied = (! z);
					default : is_satisfied = 1'b0;
				endcase
			end
			else begin 
				is_satisfied = 1'b0;
			end
			
			branch_address = (is_satisfied ? (pc + 1'b1 + exd) : 12'h000);  
			
			f = {branch_address,is_satisfied};
			
		end
		
	endfunction
	
endmodule
