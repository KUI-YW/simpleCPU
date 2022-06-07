module data_hazard_staller(
	input [15:0] instr0,
	input [15:0] instr1,
	output is_data_hazard_stall
);

	reg is_stalled_now = 1'b0;

	assign is_data_hazard_stall = check_data_hazard_stall(instr0,instr1);
	
	function check_data_hazard_stall(
		input [15:0] instr0,
		input [15:0] instr1
	);
		
		begin
		
			reg [1:0] op10 = instr0[15:14];
			reg [1:0] op11 = instr1[15:14];
			reg [3:0] op30 = instr0[7:4];
			reg isRaWaEq = (instr0[13:11] == instr1[13:11]);
			reg isRbWaEq = (instr0[10:8]  == instr1[13:11]);
			
			reg isStall = 1'b0;
		
			if(	op11 == 2'b00 
				&& 	instr1 != 16'b0000_0000_0000_0000
				&& 	(  (op10 == 2'b00 && isRbWaEq)
					|| (op10 == 2'b01 && isRbWaEq)
					|| (op10 == 2'b11 
						&& 	(	(op30 == 4'b0000 && (isRaWaEq || isRbWaEq))
							||	(op30 == 4'b0001 && (isRaWaEq || isRbWaEq))
							||	(op30 == 4'b0010 && (isRaWaEq || isRbWaEq))
							||	(op30 == 4'b0011 && (isRaWaEq || isRbWaEq))
							||	(op30 == 4'b0100 && (isRaWaEq || isRbWaEq))
							||	(op30 == 4'b0101 && (isRaWaEq || isRbWaEq))
							||	(op30 == 4'b0110 && isRaWaEq)
							||	(op30 == 4'b1000 && isRbWaEq)
							||	(op30 == 4'b1001 && isRbWaEq)
							||	(op30 == 4'b1010 && isRbWaEq)
							||	(op30 == 4'b1011 && isRbWaEq)
							//||	(op30 == 4'b1011 && isRaWaEq)
							)
						)
					)
			) begin 
				isStall = 1'b1;
			end 
			else begin
				isStall = 1'b0;
			end
			
			check_data_hazard_stall = isStall;
		
		end
		
	endfunction
	
endmodule
