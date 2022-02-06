`timescale 1ns / 10ps

`include "transmitter.sv"


module txtb();
reg [7:0] din;
reg txclk;
reg wr_en;
reg txclk_en;

wire tx;
wire tx_busy;

transmitter DUT (	.din(din),
			.txclk(txclk),
			.tx(tx),
			.wr_en(wr_en),
			.txclken(txclk_en),
			.tx_busy(tx_busy));



initial begin
	 forever #1 txclk = ~txclk;
end

initial begin

	txclk=1'b0;
	din= 8'b01100011;
	wr_en=1'b1;
	txclk_en=1'b1;


#11000;
$stop;
	
	
end

endmodule 
