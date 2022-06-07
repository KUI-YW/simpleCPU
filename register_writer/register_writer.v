module register_writer(
	input [15:0] instr,
	input [15:0] ALU_data,
	input [15:0] memory_data,
	input rawf,
	input rbwf,
	
	output [15:0] write_data,
	output [2:0] write_address,
	output is_write
);

	assign {write_data,write_address,is_write} = f(instr,ALU_data,memory_data,rawf,rbwf);

	function [19:0] f (
		input [15:0] _instr,
		input [15:0] _ALU_data,
		input [15:0] _memory_data,
		input _rawf,
		input _rbwf
	);
		begin
	
			reg [1:0] op1 = _instr[15:14];
			reg [2:0] rawa = _instr[13:11];
			reg [2:0] rbwa = _instr[10:8];
			
			reg [15:0] _write_data;
			reg [2:0] _write_address;
			reg _is_write;
			
			_write_data = (op1 == 2'b00 ? _memory_data : _ALU_data);
			
			if(_rawf) begin
				_write_address = rawa;
			end
			else if(_rbwf) begin
				_write_address = rbwa;
			end
			else begin
				_write_address = 3'b000;
			end
			
			_is_write = (_rawf || _rbwf);
			
			f = {_write_data,_write_address,_is_write}; //16+3+1
			
		end
	
	endfunction
	
endmodule	