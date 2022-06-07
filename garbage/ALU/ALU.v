module ALU(rs,rd,opcode,result,carry,overflow,minusflag,zeroflag,immd);

	input [15:0]rs;
	input [15:0]rd;
	input [3:0]opcode;
	input [3:0] immd;//シフトの即値
	
	output [15:0] result;
	 
	wire [15:0] revrs;
	assign revrs = ~rs +1;
	
	//carry信号はじまり
	wire ds11;
	wire ds22;
	wire addcarry;
	
	assign ds11 = rd[15]&rs[15];
	assign ds22 = rd[14]&rs[14];
	assign addcarry = ds11+rs[15]&ds22+rd[15]&ds22;
	
	wire drs11;
	wire drs22;
	wire subcarry;
	
	assign drs11 = rd[15]&revrs[15];
	assign drs22 = rd[14]&revrs[14];
	assign subcarry =  drs11+rs[15]&drs22+rd[15]&drs22;
	
	output carry;
	wire carry0;
	wire carry1;
	
	
	assign carry0 = carryer({opcode[3:1],addcarry,subcarry});
	assign carry1 = shiftc({opcode,immd,rd});
	
	assign carry = (opcode[3] == 1'b0)?carry0:carry1;

	
	//carry信号終わり
	
	
	assign result = alu({revrs,opcode,rd,rs});
	
	//オーバーフロー
	output overflow;
	
	assign overflow = flow({opcode,rd[15],rs[15],result[15]});
	//負フラグ
	output minusflag;
	
	assign minusflag = minus({opcode,overflow,result});
	//zeroフラグ
	output zeroflag;
	
	wire check;//とりあえずゼロかどうかみる
	
	assign check = (16'h0000==result)?1'b1:1'b0;
	
	assign zeroflag = zero({opcode,overflow,check});
	
	function zero;
		input [5:0]op_flow_check;
		begin 
		if(op_flow_check==6'b000001) zero=1'b1;
		else if(op_flow_check==6'b000101) zero=1'b1;
		else if(op_flow_check==6'b010101) zero=1'b1;
		else zero=1'b0;
		end
	endfunction
	
	
	
	function minus;
		input [5:0] op_flow_resu;
		begin 
		if(op_flow_resu==6'b000001) minus=1'b1;
		else if(op_flow_resu==6'b000101) minus=1'b1;
		else if(op_flow_resu==6'b010101) minus=1'b1;
		else minus=0;
		end
	endfunction
	
	
	function flow;
		input [5:0] opdsr;
		begin
		if(opdsr == 6'b000110) flow =1'b1;
		else if(opdsr==6'b000001) flow =1'b1;
		else flow =1'b0;
		end
	endfunction
	
	function carryer;
		input [5:0] op;
		begin
		if(op[5:2] == 4'b0000) carryer = op[1];
		else if(op[5:2]==4'b0001) carryer = op[0];
		else if(op[5:2]==4'b0101) carryer = op[0];
		else carryer = 1'b0;
		end
	endfunction
	
	
	function shiftc;
		input [23:0] op_im_rd;
			begin
			if(op_im_rd[19:16] == 4'b0000) shiftc = 1'b0;
			else if (op_im_rd[23:20]==4'b1000) shiftc = op_im_rd[(16-op_im_rd[19:16])];
			else if (op_im_rd[23:20]==4'b1001) shiftc = 1'b0;
			else if (op_im_rd[23:20]==4'b1010) shiftc = op_im_rd[(op_im_rd[19:16])];
			else if (op_im_rd[23:20]==4'b1010) shiftc = op_im_rd[(op_im_rd[19:16])];
			else shiftc = 1'b0;
			end
		endfunction
		

		
	function [15:0] alu;
	
		input [55:0]opds;
		begin
			if(opds[35:32] == 4'b0000) alu = opds[31:16] + opds[15:0];
			else if(opds[35:32] == 4'b0001) alu = opds[31:16] + opds[51:36];
			else if(opds[35:32] == 4'b0010) alu = opds[31:16] & opds[15:0];
			else if(opds[35:32] == 4'b0011) alu = opds[31:16] | opds[15:0];
			else if(opds[35:32] == 4'b0100) alu = opds[31:16] ^ opds[15:0];
			else if(opds[35:32] == 4'b0101) alu = opds[31:16] + opds[51:36];
			else if(opds[35:32] == 4'b0110) alu = opds[15:0];
			else if(opds[35:32]==4'b1000) alu = opds[31:16] << opds[55:52];
			else if(opds[35:32]==4'b1001) alu = (opds[31:16] << opds[55:52] | opds[31:16] >>16 - opds[55:52] );
			else if(opds[35:32]==4'b1010) alu = opds[31:16] >> opds[55:52];
			else if(opds[35:32]==4'b1011) alu = opds[31:16] >>> opds[55:52];
			else alu = 16'h0000;
		end
	endfunction
endmodule
