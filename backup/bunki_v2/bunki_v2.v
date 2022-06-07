module bunki_v2(clock,reset,enable,inminusflag,inzeroflag,inoverflow,inst,inpc,resultpc,flash,debugflash,pc);
reg [11:0] pcfetch;

input [11:0] inpc;
output [1:0] debugflash;
assign debugflash = {zeroflag,toconsresult2};
input [15:0] inst;
reg [15:0] IFinst =16'b0000000000000000;
reg[15:0] IDinst=16'b0000000000000000;
reg [15:0] IEinst=16'b0000000000000000;
wire [2:0] twocond;
wire [2:0] onecond;
assign twocond = IDinst[10:8];
assign onecond = IEinst[13:11];
input inzeroflag;
input inoverflow;
input inminusflag;
input enable;

reg prezeroflag = 1'b0;
reg preoverflow = 1'b0;
reg preminusflag = 1'b0;
reg zeroflag = 1'b0;
reg overflow = 1'b0;
reg minusflag = 1'b0;

input reset;
wire [4:0] opfive;
assign opfive = inst [15:11];
output [11:0] pc ;
assign pc = pcfetch;
reg [11:0] IFpc =12'b000000000000;
reg[11:0] IDpc  =12'b000000000000;
reg [11:0] IEpc  =12'b000000000000;

wire [11:0] hzpc;
wire [11:0] immd;
assign immd = extended(inst[7:0]);

wire [11:0] hzimmd;
assign hzimmd = extended(hzinst[7:0]);

wire contradict;//結果が予測失敗のとき１
wire conseq;//結果がかえって来るとき１
wire consresult;//結果が分岐しないとき０、するとき１
input clock;

output [11:0]resultpc;
wire [1:0] status;//分岐命令じゃないとき00、分岐すると予測した時１０,分岐しないと予測した時０１
wire oneortwo;//1命令分岐のとき０、２命令分岐の時１



reg [1:0] prefile [15:0];//00,01で分岐しない１０、１１で分岐する
wire istwobranch;//２命令分岐
wire isnocond;//無条件分岐
wire isonebranch;//１命令分岐

wire isbranch;
assign isbranch = istwobranch || isonebranch;

assign istwobranch = (opfive == 5'b10111 && compflag == 1'b1)?1'b1:1'b0;
assign isnocond = (opfive == 5'b10100)?1'b1:1'b0;
assign isonebranch = onebranch(opfive);

assign status = changestatus({isbranch,pc[3:0]});
assign oneortwo = (istwobranch ==1'b1 )?1'b1:1'b0;

wire [1:0] topred;
assign topred = (conseq==1'b1)? changeprefile({consresult,prefile[hzpc[3:0]]}):prefile[hzpc[3:0]];


wire [2:0] changepc;//下位2bitが00のときpcかつpc+1,10のときhzpcかつhzpc+1,１１のときhzかつhz+hzimmd+1、また最上位が１のとき無条件分岐
wire [1:0]wherebranch;//最高位が1のときにぶんき、０のときに分岐しない
assign wherebranch = prefile[pc[3:0]];

assign changepc = tochangepc({isnocond,wherebranch[1],isbranch,contradict,conseq,consresult});

assign resultpc = ispc({changepc,pc,hzpc,immd,hzimmd});


wire iscomp;
reg comp = 1'b0;

wire compflag;

assign iscomp = (inst[15:14] == 2'b11 && inst[7:4] == 4'b0101)?1'b1:1'b0;

assign compflag = comp;

reg [1:0]IFstatus = 2'b00;
reg IFoneortwo = 1'b0;

wire [1:0]toIDstatus;
wire toIDoneortwo;

assign toIDstatus = IFstatus;
assign toIDoneortwo = IFoneortwo;

reg [1:0]IDstatus = 2'b00;
reg IDoneortwo = 1'b0;

reg [1:0] IEstatus = 2'b00;
reg IEoneortwo = 1'b0;



integer i;
always @(posedge clock) begin
   if(reset == 1'b1) begin
	  for (i =0;i<16;i=i+1) begin
	     prefile[i] <= 2'b00;
	  end 
	  
	 zeroflag <= 1'b0;
	 overflow <= 1'b0;
	 minusflag <= 1'b0;
	 comp <= 1'b0;
	 
	 IFstatus <= 2'b00;
	 IFoneortwo <= 1'b0;
	 
	 IDstatus <= 2'b00;
	 IDoneortwo <= 1'b0;
	 
	 IEstatus <= 2'b00;
	 IEoneortwo <= 1'b0;
	 
	 IFinst <= 16'b0000000000000000;
	 IDinst <= 16'b0000000000000000;
	 IEinst <= 16'b0000000000000000;
	 
	 IFpc <= 12'b000000000000;
	 IDpc <= 12'b000000000000;
	 IEpc <= 12'b000000000000;
	 
	 end 
	 else begin
		 if(enable) begin  
		    pcfetch <= inpc;
			 prefile[hzpc[3:0]] <= topred;
			 comp <= iscomp;
			 IFstatus <= status;
			 IFoneortwo <= oneortwo;
			 IDstatus <= toIDstatus;
			 IDoneortwo <=toIDoneortwo;
			 IFinst <= inst;
			 IDinst <= IFinst;
			 IEinst <=IDinst;
			 IFpc <= pc;
			 IDpc <= IFpc;
			 IEpc <=IDpc;
			 prezeroflag <= inzeroflag;
			 preoverflow <= inoverflow;
			 preminusflag <=inminusflag;
			  zeroflag <= prezeroflag;
			 overflow <= preoverflow;
			 minusflag <=preminusflag;
			 
			 IEstatus <= IDstatus;
			 IEoneortwo <= IDoneortwo;
		
		 end 
		 else begin
			//do nothing
		 end
	end
end


function [11:0]extended;
	input [7:0]data;
	begin
	
		if(data[7] == 1'b0) extended = {4'b0000,data};
		else if(data[7] == 1'b1)  extended = {4'b1111,data};
		else  extended = {4'b0000,data};
	end
endfunction

function onebranch;
	input [4:0] five;
	begin
	if(five == 5'b01010) onebranch= 1'b1;
	else if(five == 5'b01011) onebranch= 1'b1;
	else if(five == 5'b01101) onebranch= 1'b1;
	else if(five == 5'b01110) onebranch= 1'b1;
	else onebranch = 1'b0;
	end
endfunction


function [1:0]tochangestatus;//changestatusにつかう
	input [3:0] inst;
	begin
	if(prefile[inst] == 2'b00) tochangestatus = 2'b01;
	else if(prefile[inst] == 2'b01) tochangestatus = 2'b01;
	else if(prefile[inst] == 2'b10) tochangestatus = 2'b10;
	else if(prefile[inst] == 2'b11) tochangestatus = 2'b10;
	else tochangestatus = 2'b00;
	end
	endfunction
	

function [1:0]changestatus;
	input [4:0]isbra_inst;
	begin
	if(isbra_inst[4] == 1'b1) changestatus = tochangestatus(isbra_inst[3:0]);
	else changestatus = 2'b00;
	end
	endfunction
	
function [1:0]changeprefile;
	input [2:0]result_pred;
	begin 
	if(result_pred == 3'b111) changeprefile = 2'b11;
	else if(result_pred == 3'b110) changeprefile = 2'b11; 
	else if(result_pred == 3'b101) changeprefile = 2'b10; 
	else if(result_pred == 3'b100) changeprefile = 2'b01; 
	else if(result_pred == 3'b011) changeprefile = 2'b10; 
	else if(result_pred == 3'b010) changeprefile = 2'b01; 
	else if(result_pred == 3'b001) changeprefile = 2'b00; 
	else  changeprefile = 2'b00; 
	end
endfunction

function [2:0]tochangepc;
	input [5:0]nocon_wh_bra_tra_seq_resu;
	begin
	if(nocon_wh_bra_tra_seq_resu[2:1] == 2'b11) tochangepc = {2'b01,nocon_wh_bra_tra_seq_resu[0]};
	else if(nocon_wh_bra_tra_seq_resu[3] == 1'b1) tochangepc = {2'b00,nocon_wh_bra_tra_seq_resu[4]};
	else if(nocon_wh_bra_tra_seq_resu[5] == 1'b1) tochangepc = 3'b100;
	else tochangepc = 3'b000;
	end
endfunction


function [11:0]ispc;
	input [50:0]ch_pc_hzpc_immd_hzimmd;
	begin
	if(ch_pc_hzpc_immd_hzimmd[50:48] == 3'b000) ispc = ch_pc_hzpc_immd_hzimmd[47:36]+1'b1;
	else if(ch_pc_hzpc_immd_hzimmd[50:48] == 3'b001) ispc = ch_pc_hzpc_immd_hzimmd[47:36] +ch_pc_hzpc_immd_hzimmd[23:12]+1'b1;
	else if(ch_pc_hzpc_immd_hzimmd[50:48] == 3'b010) ispc = ch_pc_hzpc_immd_hzimmd[35:24] +1'b1;
	else if(ch_pc_hzpc_immd_hzimmd[50:48] == 3'b011) ispc = ch_pc_hzpc_immd_hzimmd[35:24]+ch_pc_hzpc_immd_hzimmd[11:0] +1'b1;
	else if(ch_pc_hzpc_immd_hzimmd[50:48] == 3'b100) ispc = ch_pc_hzpc_immd_hzimmd[47:36] +ch_pc_hzpc_immd_hzimmd[23:12]+1'b1;
	else ispc = ch_pc_hzpc_immd_hzimmd[47:36]+1'b1;
	end
endfunction


function check2;
	input [5:0]condzvs;
	begin
	if(condzvs[5:3] == 3'b000) check2 = condzvs[2];
	else if(condzvs[5:3] == 3'b001) check2 = condzvs[0] ^ condzvs[1];
	else if(condzvs[5:3] == 3'b010) check2 =condzvs[2] | (condzvs[0] ^ condzvs[1]);
	else if(condzvs[5:3] == 3'b011) check2 = !(condzvs[2]);
	else check2 = 0;
	end
endfunction
	
function 	tocontra2;
	input [2:0] cons_status;
	begin
	if(cons_status == 3'b101) tocontra2 = 1'b1;
	else if(cons_status == 3'b010) tocontra2 = 1'b1;
	else tocontra2= 1'b0;
	end
endfunction
	

	
	
wire toconseq2;
wire tocontradict2;
wire toconsresult2;
wire flash2;


assign tocontradict2 = tocontra2({toconsresult2,IDstatus});

assign toconseq2 = (IDoneortwo==1'b1 && IDstatus != 2'b00);


assign toconsresult2 = (toconseq2 == 1'b1)? check2({twocond,zeroflag,overflow,minusflag}):1'b0;

assign flash2 = tocontradict2;	

wire toconseq1;
wire tocontradict1;
wire toconsresult1;
wire flash1;

assign tocontradict1 = tocontra1({toconsresult1,IEstatus});

assign toconseq1 = (IEoneortwo==1'b0 && IEstatus != 2'b00);

assign toconsresult1= (toconseq1 == 1'b1)? check1({onecond,zeroflag,overflow,minusflag}):1'b0;

assign flash1 = tocontradict1;

wire isoneortwo;
assign isoneortwo = (toconseq1 == 1'b1)?1'b1:1'b0;//1命令なら１、そうでないなら０

assign contradict = (isoneortwo == 1'b1)?tocontradict1:tocontradict2;
assign conseq = (isoneortwo == 1'b1)?toconseq1:toconseq2;
assign consresult = (isoneortwo == 1'b1)?toconsresult1:toconsresult2;
wire [15:0]hzinst;

assign hzinst = (isoneortwo == 1'b1) ? IEinst:IDinst;
assign hzpc = (isoneortwo == 1'b1) ? IEpc:IDpc;

output [1:0] flash;//00でフラッシュしない、０１で１命令フラッシュ、１０で２命令フラッシュ
assign flash = toflash({flash1,flash2,toconseq1,toconseq2});

function check1;
	input [5:0]condzvs;
	begin
	if(condzvs[5:3] == 3'b010) check1 = condzvs[2];
	else if(condzvs[5:3] == 3'b011) check1 = condzvs[0] ^ condzvs[1];
	else if(condzvs[5:3] == 3'b101) check1 =condzvs[2] | (condzvs[0] ^ condzvs[1]);
	else if(condzvs[5:3] == 3'b110) check1= !(condzvs[2]);
	else check1 = 0;
	end
endfunction
	
function tocontra1;
	input [2:0] cons_status;
	begin
	if(cons_status == 3'b101) tocontra1 = 1'b1;
	else if(cons_status == 3'b010) tocontra1 = 1'b1;
	else tocontra1 = 1'b0;
	end
endfunction
	

	 
function [1:0] toflash;
 input [3:0]one_two_one_two;
	begin
	if(one_two_one_two[1:0] == 2'b00) toflash = 2'b00;
	else if(one_two_one_two[2] == 1'b1 && one_two_one_two[1:0] == 2'b01) toflash = 2'b10;
	else if(one_two_one_two[2] == 1'b0 && one_two_one_two[1:0] == 2'b01) toflash = 2'b00;
	else if(one_two_one_two[3] == 1'b1 && one_two_one_two[1:0] == 2'b10) toflash = 2'b01;
	else if(one_two_one_two[3] == 1'b0 && one_two_one_two[1:0] == 2'b10) toflash = 2'b00;
	else toflash = 2'b00;
	end
endfunction	
	
endmodule
