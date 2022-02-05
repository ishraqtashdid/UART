module transmitter(input wire [7:0] din,	//input data
		   input wire wr_en,		//Wire enable pin (allows data input)
		   input wire clk,		//A 1GHz Clock
		   input wire clken,		//Clock enable pin
		   output reg tx,		//Transmission wire
		   output wire tx_busy);	//Transmission busy

initial begin
	 tx = 1'b1;	//Line remains high during idle for fault detection		
end

parameter STATE_IDLE	= 2'b00;	//default state
parameter STATE_START	= 2'b01;	//start bit adding state
parameter STATE_DATA	= 2'b10;	//data transmission state
parameter STATE_STOP	= 2'b11;	//stop bit adding state

reg [7:0] data = 8'h00;		
reg [2:0] bitpos = 3'h0;	//bit position index
reg [1:0] state = STATE_IDLE;	//default state initialized with idle

always @(posedge clk) begin		//positive edge triggered transmitter
	case (state)
	
	/*
	
	* The first state. Which is idle and goes to start when gets data from din. 
	* Bit position is initialized with 0. 
	
	*/
	
	STATE_IDLE: begin
		if (wr_en) begin		//when the wire is enabled it takes the data as input
			state <= STATE_START;	//next state
			data <= din;		//data is taken
			bitpos <= 3'h0;		//index=0
		end
	end


	/*
	
	* The second state.  
	* start bit is added with 0
	
	*/
	
	STATE_START: begin
		if (clken) begin	//clock is enabled for data transmission start
			tx <= 1'b0;	//start bit=0 (indicating the start of transmission
			state <= STATE_DATA; 	// next state is data state (where data is transmitted)
		end
		else 	begin			//if somehow the clock is not enabled it goes back to the idle state
			state <=STATE_IDLE;
			data <= 8'h00;		
			bitpos <= 3'h0;	
		end 
	end	
	STATE_DATA: begin
		if (clken) begin
			if (bitpos == 3'h7)			//when at the last position
				state <= STATE_STOP;		//the next state is made to stop state
			else
				bitpos <= bitpos + 3'h1;	//index position is increased
			tx <= data[bitpos];			/* this is outside the if-else condition so gets implemented always,
								   that's why we can make the index position==7 and get away with it. */
		end
		else 	begin			//if somehow the clock is not enabled it goes back to the idle state
			state  <=STATE_IDLE;
			data   <= 8'h00;		
			bitpos <= 3'h0;	
		end 
	end
	STATE_STOP: begin
		if (clken) begin
			tx <= 1'b1;		//stop bit is made 1
              
          
			state <= STATE_IDLE;	//goes back to idle state
		end
		else 	begin			//if somehow the clock is not enabled it goes back to the idle state
			state  <=STATE_IDLE;
			data   <= 8'h00;		
			bitpos <= 3'h0;	
		end 
	end
	default: begin
		tx <= 1'b1;
		state <= STATE_IDLE;
	end
	endcase
end

assign tx_busy = (state != STATE_IDLE);	//busy when not idle 

endmodule
