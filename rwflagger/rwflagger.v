module rwflagger(
	input [15:0] instr,
	output rarf,
	output rbrf,
	output rawf,
	output rbwf
);

	assign {rarf,rbrf,rawf,rbwf} = {instr_to_rf(instr),instr_to_wf(instr)};

	function [1:0] instr_to_rf(
		input [15:0] instr
	);
		begin
			reg [1:0] op1 = instr[15:14];
			reg [2:0] op2 = instr[13:11];
			reg [3:0] op3 = instr[7:4];
			reg rarf; 
			reg rbrf;
			
			if(op1 == 2'b00) begin
				if(instr == 16'h0000) begin
					{rarf,rbrf} = 2'b00;
				end 
				else begin 
					{rarf,rbrf} = 2'b01;
				end
			end
			else if(op1 == 2'b01) begin
				{rarf,rbrf} = 2'b11;
			end 
			else if(op1 == 2'b10) begin
				case (op2) 
					3'b001 : {rarf,rbrf} = 2'b01;
					3'b010 : {rarf,rbrf} = 2'b11;
					3'b011 : {rarf,rbrf} = 2'b11;
					3'b101 : {rarf,rbrf} = 2'b11;
					3'b110 : {rarf,rbrf} = 2'b11;
					default : {rarf,rbrf} = 2'b00;
				endcase
			end
			else begin
				case (op3)
					4'b0000 : {rarf,rbrf} = 2'b11;
					4'b0001 : {rarf,rbrf} = 2'b11;
					4'b0010 : {rarf,rbrf} = 2'b11;
					4'b0011 : {rarf,rbrf} = 2'b11;
					4'b0100 : {rarf,rbrf} = 2'b11;
					4'b0101 : {rarf,rbrf} = 2'b11;
					4'b0110 : {rarf,rbrf} = 2'b10;
					4'b1000 : {rarf,rbrf} = 2'b01;
					4'b1001 : {rarf,rbrf} = 2'b01;
					4'b1010 : {rarf,rbrf} = 2'b01;
					4'b1011 : {rarf,rbrf} = 2'b01;
					4'b1101 : {rarf,rbrf} = 2'b10;
					default : {rarf,rbrf} = 2'b00;
				endcase
			end
			instr_to_rf = {rarf,rbrf};
		end
	endfunction
	
	
	function [1:0] instr_to_wf(
		input [15:0] instr
	);
		begin
			reg [1:0] op1 = instr[15:14];
			reg [2:0] op2 = instr[13:11];
			reg [3:0] op3 = instr[7:4];
			reg rawf; 
			reg rbwf;
			
			if(op1 == 2'b00) begin
				if(instr == 16'h0000) begin
					{rawf,rbwf} = 2'b00;
				end
				else begin 
					{rawf,rbwf} = 2'b10;
				end
			end
			else if(op1 == 2'b01) begin
				{rawf,rbwf} = 2'b00;
			end 
			else if(op1 == 2'b10) begin
				case (op2) 
					3'b000 : {rawf,rbwf} = 2'b01;
					3'b001 : {rawf,rbwf} = 2'b01;
					default : {rawf,rbwf} = 2'b00;
				endcase
			end
			else begin
				case (op3)
					4'b0000 : {rawf,rbwf} = 2'b01;
					4'b0001 : {rawf,rbwf} = 2'b01;
					4'b0010 : {rawf,rbwf} = 2'b01;
					4'b0011 : {rawf,rbwf} = 2'b01;
					4'b0100 : {rawf,rbwf} = 2'b01;
					4'b0110 : {rawf,rbwf} = 2'b01;
					4'b1000 : {rawf,rbwf} = 2'b01;
					4'b1001 : {rawf,rbwf} = 2'b01;
					4'b1010 : {rawf,rbwf} = 2'b01;
					4'b1011 : {rawf,rbwf} = 2'b01;
					4'b1100 : {rawf,rbwf} = 2'b01;
					default : {rawf,rbwf} = 2'b00;
				endcase
			end
			instr_to_wf = {rawf,rbwf};
		end
	endfunction
	
endmodule
