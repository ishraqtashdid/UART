`timescale 1ns / 10ps

//`include "uart.sv"
`include "transmitter.sv"
`include "receiver.sv"


module errorcase1();
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
	//wire not enabled
	din= 8'b01100011;
	wr_en=1'b0;
	txclken=1'b1;

/* explanation of the output
_______________________________

not even taking the input "d_in" into the transmitter. As the input
is depended on wire_enable so doesn't get transferred from the bus to the
transmitter without it.

*/


#1200;


	din= 8'b01100011;
	wr_en=1'b1; //wire is enabled this time
	txclken=1'b0; //clock_enable not enabled
	


/* explanation of the output
_______________________________

Input is taken. State is initiated as "IDLE". 
However, as it changes state from "IDLE" to "START BIT" (as a result tx_busy turns 1).
But as the clock enable pin is 0 (not enabled), it keeps the din in the data register of the
transmitter and returns to IDLE state and waits for the next clock cycle to check whether 
clock_enable has become 1 (tx_busy flickers from 1 to 0 as a result).

*/


#1200;

	
	clk=1'b0;
	din= 8'b11110000;
	wr_en=1'b1;
	txclken=1'b1;

	rxclken=1'b0; // receiver clock not enabled
#2000;
	rxclken=1'b1; //receiver clock enabled after 2000 clock cycle


#11000;

	
/* explanation of the output
_______________________________

Output doesn't fully pass through. Partially passes through as the clock is enabled after 
2000 clock cycle the receiver receives error in the transmission.

*/

	
	din= 8'b11001100;
	wr_en=1'b1;
	txclken=1'b1;


	rxclken=1'b1; 

#11000;

/* explanation of the output
_______________________________

receiver is still processing the last output. fails to identify new input. 
Solve : reset the transmitter and receiver by making the wire and enable clock pins as 0. 
Wait for a bit for the running processes to end.

*/

	
	din= 8'bxxxxxx;
	wr_en=1'b0;
	txclken=1'b0;


	rxclken=1'b0; 

#20000;

	din= 8'b01100011;
	wr_en=1'b1;
	txclken=1'b1;

	rxclken=1'b1;


/* explanation of the output
_______________________________

Output works fine as desired.

*/

#11000;

$stop;
	
end 
endmodule 