module segleddecoder
(
  input count_clock,
  input selector_clock, 
  input reset,
  input [15:0] num,
  //output [15:0] cnt,    //カウントを出力する
  output [7:0] LED,
  output [3:0] selector
);
  
  
  function [7:0] to7seg;
	 input [3:0] i;
	 begin 
		case (i)
		  4'b0000 : to7seg = 8'b1111_1100; //0
		  4'b0001 : to7seg = 8'b0110_0000; //1
		  4'b0010 : to7seg = 8'b1101_1010; //2
		  4'b0011 : to7seg = 8'b1111_0010; //3
		  4'b0100 : to7seg = 8'b0110_0110; //4
		  4'b0101 : to7seg = 8'b1011_0110; //5
		  4'b0110 : to7seg = 8'b1011_1110; //6
		  4'b0111 : to7seg = 8'b1110_0000; //7
		  4'b1000 : to7seg = 8'b1111_1110; //8
		  4'b1001 : to7seg = 8'b1111_0110; //9
		  4'b1010 : to7seg = 8'b1110_1110; //A
		  4'b1011 : to7seg = 8'b0011_1110; //B
		  4'b1100 : to7seg = 8'b0001_1010; //C
		  4'b1101 : to7seg = 8'b0111_1010; //D
		  4'b1110 : to7seg = 8'b1001_1110; //E
		  4'b1111 : to7seg = 8'b1000_1110; //F
		  default : to7seg = 8'b0000_0000; //default
		endcase
	 end
  endfunction

  reg [15:0] count_data;
  reg [15:0] selector_count = 16'd0;
  reg [7:0] LED_data;
  reg [3:0] selector_data;
  
  always@(posedge selector_clock) begin	
	 if(reset) begin
		LED_data <= 8'b0000_0000;
	   selector_data <= 4'b1111;
	 end
	 else if (selector_count % 16'd400 == 16'd0) begin 
	   LED_data <= to7seg(num[15:12]);
	   selector_data <= 4'b0111;
	 end 
	 else if (selector_count % 16'd400 == 16'd100) begin 
	   LED_data <= to7seg(num[11:8]);
	   selector_data <= 4'b1011;
	 end 
    else if (selector_count % 16'd400 == 16'd200) begin 
	   LED_data <= to7seg(num[7:4]);
	   selector_data <= 4'b1101;
    end 
	 else if (selector_count % 16'd400 == 16'd300) begin 
	   LED_data <= to7seg(num[3:0]);
	   selector_data <= 4'b1110;
    end 
    
	 if (selector_count == 9999) begin 
	   selector_count <= 16'd0000;
    end 
	 else begin
      selector_count <= selector_count + 16'd1;
	 end		 
  end

  assign LED = LED_data;
  assign selector = selector_data;
  //assign cnt  = count_data;

endmodule