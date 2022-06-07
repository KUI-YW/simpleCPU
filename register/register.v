module register
(
	input clock,
	input reset,
	input exec, 
	
	input enable,
	
	input [2:0] radd1,
	input [2:0] radd2,
	input [15:0] wdata,
	input [2:0] wadd,
	input wflag,
	output reg [15:0] rdata1,
	output reg [15:0] rdata2
);
	
	reg [15:0] rgst [7:0];
	integer i;
	
	always @(posedge clock /*or posedge reset or posedge exec*/) begin 
		if(reset) begin 
			for(i = 0; i < 8; i = i + 1) begin
				rgst[i] <= 16'b0000_0000_0000_0000;
			end
		end 
		else if(exec) begin 
			// do nothing
		end 
		else begin
			if(! enable) begin
				// do nothing
			end 
			else begin
				if(wflag) begin
					rgst[wadd] <= wdata;
					if(radd1 == wadd) begin 
						rdata1 <= wdata;
						rdata2 <= rgst[radd2];
					end 
					else if(radd2 == wadd) begin 
						rdata1 <= rgst[radd1];
						rdata2 <= wdata;
					end 
					else begin
						rdata1 <= rgst[radd1];
						rdata2 <= rgst[radd2];
					end
				end
				else begin
					rdata1 <= rgst[radd1];
					rdata2 <= rgst[radd2];
				end
			end
		end
	end

endmodule

/*
	always @(negedge reset or posedge wclock or posedge rclock) begin 
		if(! reset) begin 
			for(i = 0; i < 8; i = i + 1) begin
				rgst[i] <= 16'b0000_0000_0000_0000;
			end
		end 
		else if(wclock) begin
			if(rclock) begin 
				if(wflag) begin 
					rgst[wadd] <= wdata;
					if(radd1 == wadd) begin 
						rdata1 <= wdata;
						rdata2 <= rgst[radd2];
					end 
					else if(radd2 == wadd) begin 
						rdata1 <= rgst[radd1];
						rdata2 <= wdata;
					end 
					else begin
						rdata1 <= rgst[radd1];
						rdata2 <= rgst[radd2];
					end
				end
				else begin
					rdata1 <= rgst[radd1];
					rdata2 <= rgst[radd2];
				end
			end
			else begin
				if(wflag) begin 
					rgst[wadd] <= wdata;
				end
			end
		end
		else begin
			rdata1 <= rgst[radd1];
			rdata2 <= rgst[radd2];
		end
	end
	
endmodule
*/
		