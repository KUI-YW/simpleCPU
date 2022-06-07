module phase_counter
(
	input clock,
	input reset,  //正論理
	input exec,   //正論理
	//input is_halt_commanded, //正論理
	output reg phase1,
	output reg phase2,
	output reg phase3
);
	
	reg [1:0] count = 2'b00;
	//reg [1:0] isHalt = 1'b0;
	
	//実行中の命令を完了するためにはphaseを止めてはならない
	always @(posedge clock /*or posedge reset*/) begin
		if(reset) begin 
			count <= 2'b00;
		end 
		/*else if(exec) begin
			isHalt <= ~isHalt;
		end*/
		else begin
			/*if(is_halt_commanded) begin
				isHalt <= 1'b1;
			end 
			if(isHalt) begin 
				//do nothing
			end
			else begin*/ 
				if(count == 2'b00) begin
					phase1 <= 1'b1;
					phase2 <= 1'b0;
					phase3 <= 1'b0;
					count <= 2'b01;
				end 
				else begin
					phase1 <= 1'b0;
					phase2 <= 1'b1;
					phase3 <= 1'b0;
					count <= 2'b00;
				end
				/*else if(count == 2'b01) begin
					phase1 <= 1'b0;
					phase2 <= 1'b1;
					phase3 <= 1'b0;
					count <= 2'b10;
				end 
				else begin 
					phase1 <= 1'b0;
					phase2 <= 1'b0;
					phase3 <= 1'b1;
					count <= 2'b00;
				end*/
			//end
		end
	end
	
endmodule
