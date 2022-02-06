module uart(input wire [7:0] din,
	    input wire wr_en,
	    input wire txclk,
	    output wire tx,
	    output wire tx_busy,
	    input wire rx,
	    //output wire rdy,
	    //input wire rdy_clr,
	    input wire rxclken,
	    input wire rxclk, 
	    input wire txclken,
	    output wire [7:0] dout);




transmitter uart_tx(.din(din),
		    .wr_en(wr_en),
		    .txclk(txclk),
		    .txclken(txclken),
		    .tx(tx),
		    .tx_busy(tx_busy));
receiver uart_rx(.rx(rx),
		 //.rdy(rdy),
		 //.rdy_clr(rdy_clr),
		 .rxclk(rxclk),
		 .rxclken(rxclken),
		 .dout(dout));


endmodule
