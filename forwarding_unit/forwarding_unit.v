module forwarding_unit (
	input [15:0] instr0,
	input [15:0] instr1,
	input [15:0] instr2,
	
	input [15:0] rard0, // register A read data
	input [15:0] rbrd0,
	input [15:0] rard1,
	
	input [15:0] ALUd1,
	input [15:0] memoryd1,
	input [15:0] ALUd2,
	input [15:0] memoryd2,
	
	input rarf0, // register A/B read/write flag (zero/one/two stages ahead)
	input rbrf0,
	input rawf1,
	input rbwf1, 
	input rawf2, 
	input rbwf2,
	
	output [15:0] rad0, // register A data
	output [15:0] rbd0,
	output [15:0] rad1,
	output [15:0] ALUout1
	//output [5:0] flags,
	//output isStall
);

//クソコードでごめんなさい

	assign {rad0,rbd0,rad1,ALUout1} = f(instr0,instr1,instr2,rard0,rbrd0,rard1,ALUd1,memoryd1,ALUd2,memoryd2);

	function [63:0] f(
		input [15:0] instr0,
		input [15:0] instr1,
		input [15:0] instr2,
		
		input [15:0] rard0,
		input [15:0] rbrd0,
		input [15:0] rard1,
		
		input [15:0] ALUd1,
		input [15:0] memoryd1,
		input [15:0] ALUd2,
		input [15:0] memoryd2
	);
	
		begin
		
			reg [1:0] op10 = instr0[15:14];
			reg [1:0] op11 = instr1[15:14];
			reg [1:0] op12 = instr2[15:14];
			
			reg [3:0] op30 = instr0[7:4];
			reg [3:0] op31 = instr1[7:4];
			reg [3:0] op32 = instr2[7:4];
			
			reg [2:0] rara0 = instr0[13:11]; // register A read/write address (zero/one/two stages ahead)
			reg [2:0] rawa1 = instr1[13:11]; 
			reg [2:0] rawa2 = instr2[13:11]; 
			
			reg [2:0] rbra0 = instr0[10:8]; // register B read/write address (zero/one/two stages ahead)
			reg [2:0] rbwa1 = instr1[10:8];
			reg [2:0] rbwa2 = instr2[10:8]; 
			
			reg isRaWaEq = (rara0 == rawa1);
			reg isRbWaEq = (rbra0 == rawa1);
			
			reg [15:0] rawd1 = (op11 == 2'b00 ?  memoryd1 : 16'h0000);
			reg [15:0] rbwd1 = ( (op11 == 2'b11 & ( (op31 == 4'b0101) | (op31 == 4'b1101) ) ) ? 16'h0000 : ALUd1 );
			reg [15:0] rawd2 = (op12 == 2'b00 ?  memoryd2 : 16'h0000);
			reg [15:0] rbwd2 = ( (op12 == 2'b11 & ( (op32 == 4'b0101) | (op32 == 4'b1101) ) ) ? 16'h0000 : ALUd2 );
			
			reg [15:0] rad0; //register A/B data
			reg [15:0] rbd0; 
			reg [15:0] rad1;
			reg [15:0] ALUout1;
			
		
			if((rarf0 & rawf1) & (rara0 == rawa1)) begin 
				rad0 = rawd1;
			end 
			else if((rarf0 & rbwf1) & (rara0 == rbwa1)) begin 
				rad0 = rbwd1;
			end 
			else if((rarf0 & rawf2) & (rara0 == rawa2)) begin 
				rad0 = rawd2;
			end
			else if((rarf0 & rbwf2) & (rara0 == rbwa2)) begin 
				rad0 = rbwd2;
			end
			else begin
				rad0 = rard0;
			end
			
			
			if((rbrf0 & rbwf1) & (rbra0 == rbwa1)) begin 
				rbd0 = rbwd1;
			end
			else if((rbrf0 & rawf1) & (rbra0 == rawa1)) begin 
				rbd0 = rawd1;
			end
			else if((rbrf0 & rbwf2) & (rbra0 == rbwa2)) begin 
				rbd0 = rbwd2;
			end
			else if((rbrf0 & rawf2) & (rbra0 == rawa2)) begin 
				rbd0 = rawd2;
			end
			else begin
				rbd0 = rbrd0;
			end
			
			
			if( instr1[15:14] == 2'b01 & instr2[15:14] == 2'b00 & (rawa1 == rawa2)) begin 
				rad1 = rawd2;
			end
			else begin
				rad1 = rard1;
			end
			
			if( instr1[15:14] == 2'b11 && instr1[7:4] == 4'b1101 && instr2[15:14] == 2'b00 && (rawa1 == rawa2)) begin 
				ALUout1 = memoryd2;
			end
			else begin
				ALUout1 = ALUd1; 
			end
			
			
			f = {rad0,rbd0,rad1,ALUout1};
			
		end
		
	endfunction
	/*
	function [31:0] select_wdata(
		input [15:0] instr,
		input [15:0] memory_data,
		input [15:0] imm_data,
		input [15:0] ALU_data,
		input [15:0] input_data
	);
		begin 
			reg [1:0] op1 = instr[15:14];
			reg [2:0] op2 = instr[13:11];
			reg [3:0] op3 = instr[7:4];
			reg [15:0] rawd, rbwd; 
			
			if(op1 == 2'b00) begin 
				rawd = memory_data;
			end 
			else if(op1 == 2'b10 && (op2 == 3'b000 || op2 == 3'b001 || op2 == 3'b010)) begin
				rbwd = imm_data;
			end 
			else if(op1 == 2'b11) begin
				case (op3) 
					4'b0000 : rbwd = ALU_data;
					4'b0001 : rbwd = ALU_data;
					4'b0010 : rbwd = ALU_data;
					4'b0011 : rbwd = ALU_data;
					4'b0100 : rbwd = ALU_data;
					4'b0110 : rbwd = ALU_data;
					4'b1000 : rbwd = ALU_data;
					4'b1001 : rbwd = ALU_data;
					4'b1010 : rbwd = ALU_data;
					4'b1011 : rbwd = ALU_data;
					4'b1100 : rbwd = input_data;
					default : rbwd = 16'b0000_0000_0000_0000;
				endcase
			end 
			else begin 
				// do nothing
			end
			select_wdata = {rawd,rbwd};
		end
	endfunction	
	
	
	
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
					3'b010 : {rarf,rbrf} = 2'b01;
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
					3'b010 : {rawf,rbwf} = 2'b01;
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
	*/
endmodule
