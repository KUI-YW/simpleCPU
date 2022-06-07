module cond(op1,op2,cond,zeroflag,overflow,minusflag,flag);

input [2:0] cond;
input zeroflag;
input overflow;
input minusflag;

output flag;

assign flag = check({cond,zeroflag,overflow,minusflag});

	function check;
	input [5:0]condzvs;
	begin
	if(condzvs[5:3] == 3'b000) check = condzvs[2];
	else if(condzvs[5:3] == 3'b001) check = condzvs[0] ^ condzvs[1];
	else if(condzvs[5:3] == 3'b010) check =condzvs[2] | (condzvs[0] ^ condzvs[1]);
	else if(condzvs[5:3] == 3'b011) check = !(condzvs[2]);
	else check = 0;
	end
	endfunction
	
endmodule
	