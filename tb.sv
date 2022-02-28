`timescale 1ns / 10ps

//`include "uart.sv"
`include "transmitter.sv"
`include "receiver.sv"


module tb();
	
		   reg [7:0] din;	//input data
		   reg wr_en;		//Wire enable pin (allows data input)
		   reg clk;		//A 1GHz Clock
		   reg txclken;		//Clock enable pin
		   wire tx;		//Transmission wire
		   reg tx_busy ;	//Transmission busy


		   //reg rx;
		   //output reg rdy,
		   //input wire rdy_clr,
		   reg rx_busy;
		   reg rxclken;
		   wire [7:0] dout;


		  
transmitter DUT_tran (			.din(din),
					.txclk(clk),
					.tx(tx),
					.wr_en(wr_en),
					.txclken(txclken),
					.tx_busy(tx_busy));	

receiver DUT_rec (			.rx(tx),
					//.rdy(rdy),
					//.rdy_clr(rdy_clr),
					.rxclk(clk),
					.rxclken(rxclken),
					.rx_busy(rx_busy),
					.dout(dout));	


//wire a=1;
//assign tx = (a==1)? rx: 1'b1;k



initial begin
	 forever #1 clk = ~clk;
end

initial begin
	clk=1'b0;
	din= 8'b01100011;
	wr_en=1'b1;
	txclken=1'b1;

	rxclken=1'b1;


#11000;
$stop;
	
	
end

endmodule

