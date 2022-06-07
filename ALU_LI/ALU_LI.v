module ALU_LI(
	input [15:0] instr,
	input signed [15:0] rs,
	input signed [15:0] rd,
	input signed [15:0] iData,
	output wire [15:0] result, 
	output wire signFlag,
	output wire zeroFlag,
	output wire carryFlag,
	output wire overflowFlag
);

	assign {result,signFlag,zeroFlag,carryFlag,overflowFlag} = f(instr,rs,rd);

	function [19:0] f (
		input [15:0] instr,
		input signed [15:0] rs,
		input signed [15:0] rd
	); 
		begin 
		
			reg [1:0] op1 = instr[15:14];
			reg [2:0] op2 = instr[13:11];
			reg [3:0] op3 = instr[7:4];
			reg [7:0] imm = instr[7:0];
			reg [3:0] shamt = instr[3:0];
			
			reg [16:0] exrs = {1'b0,rs};
			reg [16:0] exrd = {1'b0,rd};
			reg [16:0] eximm = (imm[7] ? {9'b0_1111_1111,imm} : {9'b0_0000_0000,imm});
			
			reg [16:0] exresult;
			reg [15:0] result;
			reg s, z, c, o;
		
			//calculation
			//Load
			if(op1 == 2'b00) begin 
				exresult = (exrd + eximm); 
			end 
			//Store
			else if(op1 == 2'b01) begin
				exresult = (exrd + eximm); 
			end
			//LoadImmediate
			else if(op1 == 2'b10) begin
				case (op2) 
					3'b000 : exresult = eximm;
					3'b001 : exresult = {1'b0,imm,rd[7:0]};
					default : exresult = 17'b0_0000_0000_0000_0000;
				endcase
			end
			else begin 
				case (op3) 
					4'b0000 : exresult = (exrd + exrs);
					4'b0001 : exresult = (exrd - exrs);
					4'b0010 : exresult = (exrd & exrs);
					4'b0011 : exresult = (exrd | exrs);
					4'b0100 : exresult = (exrd ^ exrs);
					4'b0101 : exresult = (exrd - exrs);
					4'b0110 : exresult = exrs;
					//4'b0111 : ;
					4'b1000 : exresult = (exrd << shamt);
					4'b1001 : exresult = { 1'b0, ( (rd << shamt) | (rd >> (5'd16-shamt)) ) };
					4'b1010 : exresult = { /*(rd >> (shamt-1'b1))[0]*/ rd[shamt-1'b1], (rd >> shamt) };
					4'b1011 : exresult = { /*(rd >>> (shamt-1'b1))[0]*/ rd[shamt-1'b1], (rd >>> shamt) };
					4'b1100 : exresult = {1'b0,iData};
					4'b1101 : exresult = {1'b0,rs};
					//4'b1110 : ;
					//4'b1111 : ;
					default : exresult = 17'b00000_0000_0000_0000;
				endcase
			end
			
			result = exresult[15:0];
			s = result[15];
			z = (result == 16'b0000_0000_0000_0000);
			//carryの仕様次第
			c = (
					op1 == 2'b11 
					& (op3 == 4'b0000 || op3 == 4'b0001 || op3 == 4'b0101 || op3 == 4'b1000 || op3 == 4'b1000 || op3 == 4'b1010 || op3 == 4'b1011) 
					& exresult[16]
				);
			o = (
					op1 == 2'b11 &
					(
						( (op3 == 4'b0000) & (rs[15] == rd[15]) & (rd[15] != exresult[15]) ) 
						||  ( (op3 == 4'b0001 || op3 == 4'b0101) & (rs[15] ^ rd[15]) & (rd[15] != exresult[15]) ) 
					)		
				);
				
			f = {result,s,z,c,o};
		end
	endfunction
	
endmodule
