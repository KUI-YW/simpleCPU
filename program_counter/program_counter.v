module program_counter
(
	input clock,
	input reset,
	input exec,
	input is_halt_commanded,
	
	input enable,
	
	input is_data_hazard_stall,
	input is_branch_hazard_stall,
	input [11:0] branch_hazard_instr_add,
	
	input is_jump,
	input [11:0] jump_instr_add,
	
	input is_branch_predict,
	input [11:0] branch_predict_add,
	
	input is_cmpb_satisfied,
	input [11:0] cmpb_instr_add,
	
	output [11:0] instr_add,
	output instr_add_is_overflow
	//output is_halt_debug
);
	
	reg [11:0] count = 12'b0000_0000_0000;
	reg is_overflow = 1'b0;
	
	reg is_init = 1'b1;
	reg is_halt = 1'b0;
	reg data_hazard_stall_counter = 1'b0;
	
	always @(posedge clock /*or posedge reset or posedge exec*/) begin 
	
		if(reset) begin 
			count <= 12'b0000_0000_0000;
			is_init <= 1'b1;
			data_hazard_stall_counter <= 1'b0;
		end
		else if(exec) begin
			is_halt <= ~is_halt;
		end 
		else if(is_halt_commanded) begin
			is_halt <= 1'b1;
		end
		else begin
		
		end
		
		
		if((is_halt ^ exec) || is_halt_commanded) begin
			//do nothing
		end
		else begin
			if(! enable) begin 
				// do nothing 
			end
			else begin 
				if(is_branch_hazard_stall) begin 
					count <= branch_hazard_instr_add;
				end
				else if(is_data_hazard_stall && (data_hazard_stall_counter < 1'b1)) begin
					data_hazard_stall_counter <= (data_hazard_stall_counter + 1'b1);
				end
				else begin 
				
					is_overflow <= 1'b0;
					data_hazard_stall_counter <= 1'b0;
					
					//jump->IF,cmpb->ID,immb->EX
					if(is_cmpb_satisfied) begin
						count <= cmpb_instr_add;
					end
					else if(is_jump) begin
						count <= jump_instr_add;
					end
					else if(is_branch_predict) begin
						count <= branch_predict_add;
					end
					else begin 
						if((count == 12'b0000_0000_0000) && is_init) begin 
							is_init <= 1'b0;
						end
						else if(count < 12'b1111_1111_1111) begin
							count <= (count + 12'b0000_0000_0001);
						end
						else begin
							count <= 12'b0000_0000_0000;
							is_init <= 1'b1;
							is_overflow <= 1'b1;
						end
					end
				end
			end
		end
	end
	
	assign instr_add = count;
	assign instr_add_is_overflow = is_overflow;
	//assign is_halt_debug = is_halt;
	
endmodule



	