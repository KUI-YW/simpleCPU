module branch_predictor(
	input clock,
	input reset,
	input exec,
	
	input enable,
	
	input [15:0] instr0,
	input [15:0] instr1,
	input [15:0] instr2,
	
	input [15:0] branch_src0,
	input [15:0] branch_src1,
	input [15:0] branch_src2,
	
	input signflag,
	input zeroflag,
	input overflowflag,
	
	output [11:0] predict_dst,
	output is_branch0,
	output [11:0] branch_dst,
	output is_predict_miss
);

	reg [1:0] history [15:0];
	
	wire is_one_instr_branch0, is_one_instr_branch1, is_one_instr_branch2;
	wire is_two_instr_branch0, is_two_instr_branch1, is_two_instr_branch2;
	wire [11:0] branch_dst1, branch_dst2; // 1 or 2 stage(s) ahead
	wire _is_predict_miss1, _is_predict_miss2; // 1 or 2 stage(s) ahead
	
	assign {is_one_instr_branch0, is_two_instr_branch0} = is_branch(instr0);
	assign {is_one_instr_branch1, is_two_instr_branch1} = is_branch(instr1);
	assign {is_one_instr_branch2, is_two_instr_branch2} = is_branch(instr2);
	
	assign {branch_dst1,_is_predict_miss1} = verify(instr1,branch_src1,signflag,zeroflag,overflowflag);
	assign {branch_dst2,_is_predict_miss2} = verify(instr2,branch_src2,signflag,zeroflag,overflowflag);
	
	assign is_predict_miss1 = (_is_predict_miss1 && is_two_instr_branch1);
	assign is_predict_miss2 = (_is_predict_miss2 && is_one_instr_branch1);
	
	assign predict_dst = predict(instr0,branch_src0,(is_one_instr_branch0 || is_two_instr_branch0));
	assign is_branch0 = (is_one_instr_branch0 || is_two_instr_branch0);
	assign branch_dst = (is_predict_miss2 ? branch_dst2 : ( is_predict_miss1 ? branch_dst1 : (branch_src0 + 12'h001) ));
	assign is_predict_miss = (is_predict_miss1 || is_predict_miss2);
	
	integer i;
	
	always @(posedge clock) begin
		if(reset) begin
			for(i = 4'b0000; i <= 4'b1111; i = i + 4'b0001) begin
				history[i] <= 2'b00;
			end
		end 
		else begin
	    	if(enable) begin
				if(is_one_instr_branch2) begin 
					case (history[branch_src2[3:0]]) 
						2'b00 : history[branch_src2[3:0]] <= (is_predict_miss2 ? 2'b01 : 2'b00); 
						2'b01 : history[branch_src2[3:0]] <= (is_predict_miss2 ? 2'b10 : 2'b00); 
						2'b10 : history[branch_src2[3:0]] <= (is_predict_miss2 ? 2'b01 : 2'b11); 
						2'b11 : history[branch_src2[3:0]] <= (is_predict_miss2 ? 2'b10 : 2'b11); 
					endcase				
				end 
				else if(is_two_instr_branch1) begin
					case (history[branch_src1[3:0]]) 
						2'b00 : history[branch_src1[3:0]] <= (is_predict_miss1 ? 2'b01 : 2'b00); 
						2'b01 : history[branch_src1[3:0]] <= (is_predict_miss1 ? 2'b10 : 2'b00); 
						2'b10 : history[branch_src1[3:0]] <= (is_predict_miss1 ? 2'b01 : 2'b11); 
						2'b11 : history[branch_src1[3:0]] <= (is_predict_miss1 ? 2'b10 : 2'b11); 
					endcase		
				end
				else begin
					// do nothing
				end
			end
			else begin
				//do nothing
			end
		end
	end
	
	function [1:0] is_branch(
		input [15:0] instr
	); 
		begin
			reg [1:0] op1 = instr[15:14];
			reg [2:0] op2 = instr[13:11];
			reg [2:0] cond = instr[10:8];
			
			reg is_one_instr_branch, is_two_instr_branch;
			is_one_instr_branch 
			= 	(	op1 == 2'b10 
					&& (op2 == 3'b010 || op2 == 3'b011 || op2 == 3'b101 || op2 == 3'b110)
				);	
			is_two_instr_branch 
			= 	(	op1 == 2'b10 
					&& op2 == 3'b111
					&& (cond == 3'b000 || cond == 3'b001 || cond == 3'b010 || cond == 3'b011)
				);
			is_branch = {is_one_instr_branch,is_two_instr_branch};
		end
	endfunction
	
	function [11:0] predict(
		input [15:0] instr,
		input [15:0] instr_address,
		input is_branch
	);
		begin
			
			reg [7:0] d = instr[7:0];
			reg [11:0] exd = (d[7] ? {4'b1111,d} : {4'b0000,d});
			reg [11:0] branch_src = instr_address[11:0];
			reg [11:0] predict_address;
		
			if(is_branch) begin
				if(predict_satis(branch_src)) begin
					predict_address = branch_src + 12'h001 + exd;
				end
				else begin
					predict_address = branch_src + 12'h001;
				end
			end 
			else begin
				predict_address = branch_src + 12'h001;
			end
			predict = predict_address;
		end
	endfunction
	
	
	
	function predict_satis(
		input [11:0] branch_src
	);	 
		begin 
			reg _predict_satis;
			case (history[branch_src[3:0]])
				2'b00 : _predict_satis = 1'b0;
				2'b01 : _predict_satis = 1'b0;
				2'b10 : _predict_satis = 1'b1;
				2'b11 : _predict_satis = 1'b1;
				default : _predict_satis = 1'b0;
			endcase
			predict_satis = _predict_satis;
		end
	endfunction
	
	
	
	function [12:0] verify(
		input [15:0] instr,
		input [15:0] instr_address,
		input s,
		input z,
		input v
	);
		begin
			
			reg [1:0] op1 = instr[15:14];
			reg [2:0] op2 = instr[13:11];
			reg [2:0] cond = instr[10:8];
			reg signed [7:0] d = instr[7:0];
			reg signed [11:0] exd = (d[7] ? {4'b1111,d} : {4'b0000,d});
			reg [11:0] branch_src = instr_address[11:0];
			
			reg is_satisfied = 1'b0;
			
			reg [11:0] branch_address = 12'h000;
			reg is_predict_miss = 1'b0;
		
			if(op1 == 2'b10 && op2 == 3'b111) begin
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
			
			branch_address = (is_satisfied ? (branch_src + 12'h001 + exd) : (branch_src + 12'h001)); 
			
			if( ^(is_branch(instr)) ) begin 
				 is_predict_miss =  ( (predict_satis(branch_src)) ^ is_satisfied );
			end
			else begin
			    // do nothing 
			end
			
			verify = {branch_address,is_predict_miss};
		end
	endfunction
	
endmodule
