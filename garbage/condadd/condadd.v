module condadd(flag,immd,pc,op,pcresult);

input flag;
input [11:0]immd;
input [11:0]pc;
input [1:0] op;
output [11:0]pcresult;

wire resultflag;
wire [11:0]addpc;


assign addpc = pc + immd + 1;

assign resultflag = check({op,flag});

assign pcresult = (resultflag==1)?addpc:pc;

function check;
	input [2:0] opflag;
	begin
	if(opflag == 3'b101) check = 1;
	else check =0;
	end
	endfunction

endmodule
	

 
