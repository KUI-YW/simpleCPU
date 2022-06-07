module controller
(
	//input reset,
	input [15:0] instr,
	
	output reg isLoad,
	output reg isStore,
	output reg isLoadImm,
	output reg isJump,
	output reg isBranch,
	output reg isIn,
	output reg isOut, 
	output reg isHalt,
	output reg ALUsource,
	output reg regWrite,
	output reg regDst
);
	
	always @(*) begin
		/*if(reset) begin 
			isLoad <= 1'b0;
			isStore <= 1'b0;
			isLoadImm <= 1'b0;
			isJump <= 1'b0;
			isBranch <= 1'b0;
			isIn <= 1'b0;
			isOut  <= 1'b0;
			isHalt <= 1'b0;
			ALUsource <= 1'b0;
			regWrite <= 1'b0;
			regDst <= 1'b0;
		end 
		else begin*/
			if(instr[15:14] == 2'b00) begin //load
				if(instr == 16'b0000_0000_0000_0000) begin
					isLoad <= 1'b0;
					isStore <= 1'b0;
					isLoadImm <= 1'b0;
					isJump <= 1'b0;
					isBranch <= 1'b0;
					isIn <= 1'b0;
					isOut  <= 1'b0;
					isHalt <= 1'b0;
					ALUsource <= 1'b0;
					regWrite <= 1'b0;
					regDst <= 1'b0;
				end
				else begin 
					isLoad <= 1'b1;
					isStore <= 1'b0;
					isLoadImm <= 1'b0;
					isJump <= 1'b0;
					isBranch <= 1'b0;
					isIn <= 1'b0;
					isOut  <= 1'b0;
					isHalt <= 1'b0;
					ALUsource <= 1'b1;
					regWrite <= 1'b1;
					regDst <= 1'b0;
				end
			end else if(instr[15:14] == 2'b01) begin //store
				isLoad <= 1'b0;
				isStore <= 1'b1;
				isLoadImm <= 1'b0;
				isJump <= 1'b0;
				isBranch <= 1'b0;
				isIn <= 1'b0;
				isOut  <= 1'b0;
				isHalt <= 1'b0;
				ALUsource <= 1'b1;
				regWrite <= 1'b0;
				regDst <= 1'b0;
			end else if(instr[15:14] == 2'b10) begin //即値ロード・条件分岐命令
				isLoad <= 1'b0;
				isStore <= 1'b0;
				isLoadImm <= 1'b0;
				isJump <= 1'b0;
				isBranch <= 1'b0;
				isIn <= 1'b0;
				isOut  <= 1'b0;
				isHalt <= 1'b0;
				ALUsource <= 1'b0;
				regWrite <= 1'b0;
				regDst <= 1'b0;
				
				if(instr[13:11] == 3'b000 | instr[13:11] == 3'b001 | instr[13:11] == 3'b010) begin 
					isLoadImm <= 1'b1;
					regWrite <= 1'b1;
					regDst <= 1'b1;
				end
				
				if(instr[13:11] == 3'b100) begin
					isJump <= 1'b1;
					isBranch <= 1'b1;
				end else if(instr[13:11] == 3'b111) begin 
					isBranch <= 1'b1;
				end
				
			end else begin //演算・入出力命令
				isLoad <= 1'b0;
				isStore <= 1'b0;
				isLoadImm <= 1'b0;
				isJump <= 1'b0;
				isBranch <= 1'b0;
				isIn <= 1'b0;
				isOut  <= 1'b0;
				isHalt <= 1'b0;
				ALUsource <= 1'b0;
				regWrite <= 1'b1;
				regDst <= 1'b1;
				
				if(instr[7:4] == 4'b0101) begin
					regWrite <= 1'b0;
				end 
				else if(instr[7:4] == 4'b1100) begin 
					isIn <= 1'b1;
				end 
				else if(instr[7:4] == 4'b1101) begin 
					isOut <= 1'b1;
					regDst <= 1'b0;
					regWrite <= 1'b0;
				end 
				else if(instr[7:4] == 4'b1111) begin 
					isHalt <= 1'b1;
					regDst <= 1'b0;
					regWrite <= 1'b0;
				end
			end 
		//end
	end
	
endmodule
