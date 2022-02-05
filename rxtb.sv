`timescale 1ns / 10ps




//receiver self
`include "receiver.sv"

module tb();
	reg rx;
	//wire rdy;
	//reg rdy_clr;
	reg clk;
	reg clken;
	wire [7:0] data;

	
	receiver DUT (	.rx(rx),
					//.rdy(rdy),
					//.rdy_clr(rdy_clr),
					.clk(clk),
					.clken(clken),
					.data(data));


	initial begin
	  forever #1 clk = ~clk;
	end
	initial
 begin
	  clk=1'b0;
	  //rdy_clr=1'b1;

	  #10;

	  clken=1'b1;

	  #10;

	  rx=1'b0; //start bit

	  #1200;

	  rx=1'b1; //bit 1
	  #1300;

	  rx=1'b0;//bit 2
	  #1200;

	  rx=1'b1;//bit 3
	  #1100;
		
	  rx=1'b0; //bit 4
	  #1100;

	  rx=1'b1;//bit 5
	  #1100;

	  rx=1'b1;//bit 6
	  #1100;
	
	  rx=1'b0; //bit 7
	  #1100;

	  rx=1'b0;//bit 8
	  #1100;

	  rx=1'b1;//Stop bit
	  #1200;
			

		
$stop;

end

endmodule


