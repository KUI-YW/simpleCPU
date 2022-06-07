module pipeline_register(
	input clock,
	input reset,
	input exec,
	input is_halt_commanded,
	
	input enable,
	input stall,
	input flush,
	
	input [15:0] idata1,
	input [15:0] idata2,
	input [15:0] idata3,
	input [15:0] idata4,
	input [15:0] idata5,
	input iflag1,
	input iflag2,
	input iflag3,
	input iflag4,
	input iflag5,
	input iflag6,
	input iflag7,
	input iflag8,
	input iflag9,
	input iflag10,
	input iflag11,
	input iflag12,
	input iflag13,
	input iflag14,
	input iflag15,
	input iflag16,
	output [15:0] odata1,
	output [15:0] odata2,
	output [15:0] odata3,
	output [15:0] odata4,
	output [15:0] odata5,
	output oflag1, 
	output oflag2, 
	output oflag3, 
	output oflag4, 
	output oflag5, 
	output oflag6, 
	output oflag7, 
	output oflag8, 
	output oflag9, 
	output oflag10, 
	output oflag11, 
	output oflag12, 
	output oflag13, 
	output oflag14, 
	output oflag15, 
	output oflag16,
	output is_halt_now
);

	reg is_halt = 1'b1;

	reg [15:0] data1;
	reg [15:0] data2;
	reg [15:0] data3;
	reg [15:0] data4;
	reg [15:0] data5;
	reg flag1;
	reg flag2;
	reg flag3;
	reg flag4;
	reg flag5;
	reg flag6;
	reg flag7;
	reg flag8;
	reg flag9;
	reg flag10;
	reg flag11;
	reg flag12;
	reg flag13;
	reg flag14;
	reg flag15;
	reg flag16;

	always @(posedge clock /*or posedge reset or posedge exec*/) begin
		if(reset) begin 
			data1 <= 16'b0000_0000_0000_0000;
			data2 <= 16'b0000_0000_0000_0000;
			data3 <= 16'b0000_0000_0000_0000;
			data4 <= 16'b0000_0000_0000_0000;
			data5 <= 16'b0000_0000_0000_0000;
			flag1 <= 1'b0;
			flag2 <= 1'b0;
			flag3 <= 1'b0;
			flag4 <= 1'b0;
			flag5 <= 1'b0;
			flag6 <= 1'b0;
			flag7 <= 1'b0;
			flag8 <= 1'b0;
			flag9 <= 1'b0;
			flag10 <= 1'b0;
			flag11 <= 1'b0;
			flag12 <= 1'b0;
			flag13 <= 1'b0;
			flag14 <= 1'b0;
			flag15 <= 1'b0;
			flag16 <= 1'b0;
		end 
		else if(exec) begin
			is_halt <= ~is_halt;
		end 
		else if(is_halt_commanded) begin
			is_halt <= 1'b1;
		end
		else begin
		
		end
		
		if( (is_halt ^ exec) || is_halt_commanded ) begin
			/*
			data1 <= 16'b0000_0000_0000_0000;
			data2 <= 16'b0000_0000_0000_0000;
			data3 <= 16'b0000_0000_0000_0000;
			data4 <= 16'b0000_0000_0000_0000;
			data5 <= 16'b0000_0000_0000_0000;
			flag1 <= 1'b0;
			flag2 <= 1'b0;
			flag3 <= 1'b0;
			flag4 <= 1'b0;
			flag5 <= 1'b0;
			flag6 <= 1'b0;
			flag7 <= 1'b0;
			flag8 <= 1'b0;
			flag9 <= 1'b0;
			flag10 <= 1'b0;
			flag11 <= 1'b0;
			flag12 <= 1'b0;
			flag13 <= 1'b0;
			flag14 <= 1'b0;
			flag15 <= 1'b0;
			flag16 <= 1'b0;
			*/
		end
		else begin
			if(! enable) begin
				//do nothing
			end 
			else begin
				if(stall) begin
					//do nothing
				end
				else if(flush) begin 
					data1 <= 16'b0000_0000_0000_0000;
					data2 <= 16'b0000_0000_0000_0000;
					data3 <= 16'b0000_0000_0000_0000;
					data4 <= 16'b0000_0000_0000_0000;
					data5 <= 16'b0000_0000_0000_0000;
					flag1 <= 1'b0;
					flag2 <= 1'b0;
					flag3 <= 1'b0;
					flag4 <= 1'b0;
					flag5 <= 1'b0;
					flag6 <= 1'b0;
					flag7 <= 1'b0;
					flag8 <= 1'b0;
					flag9 <= 1'b0;
					flag10 <= 1'b0;
					flag11 <= 1'b0;
					flag12 <= 1'b0;
					flag13 <= 1'b0;
					flag14 <= 1'b0;
					flag15 <= 1'b0;
					flag16 <= 1'b0;
				end 
				else begin 
					data1 <= idata1;
					data2 <= idata2;
					data3 <= idata3;
					data4 <= idata4;
					data5 <= idata5;
					flag1 <= iflag1;
					flag2 <= iflag2;
					flag3 <= iflag3;
					flag4 <= iflag4;
					flag5 <= iflag5;
					flag6 <= iflag6;
					flag7 <= iflag7;
					flag8 <= iflag8;
					flag9 <= iflag9;
					flag10 <= iflag10;
					flag11 <= iflag11;
					flag12 <= iflag12;
					flag13 <= iflag13;
					flag14 <= iflag14;
					flag15 <= iflag15;
					flag16 <= iflag16;
				end
			end
		end
	end
	
	assign is_halt_now = is_halt;
	assign odata1 = data1;
	assign odata2 = data2;
	assign odata3 = data3;
	assign odata4 = data4;
	assign odata5 = data5;
	assign oflag1 = flag1;
	assign oflag2 = flag2;
	assign oflag3 = flag3;
	assign oflag4 = flag4;
	assign oflag5 = flag5;
	assign oflag6 = flag6;
	assign oflag7 = flag7;
	assign oflag8 = flag8;
	assign oflag9 = flag9;
	assign oflag10 = flag10;
	assign oflag11 = flag11;
	assign oflag12 = flag12;
	assign oflag13 = flag13;
	assign oflag14 = flag14;
	assign oflag15 = flag15;
	assign oflag16 = flag16;
	
endmodule
