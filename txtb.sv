`timescale 1ns / 10ps

`include "transmitter.sv"


module txtb();
reg [7:0] data;
reg clk;
reg wire_enable;
reg txclk_en;

wire tx;
wire tx_busy;

transmitter DUT (	.din(data),
			.clk(clk),
			.tx(tx),
			.wr_en(wire_enable),
			.clken(txclk_en),
			.tx_busy(tx_busy));



initial begin
	 forever #1 clk = ~clk;
end

initial begin

	clk=1'b0;
	data= 8'b01100011;
	wire_enable=1'b1;
	txclk_en=1'b1;


#11000;
$stop;
	
	
end

endmodule 
