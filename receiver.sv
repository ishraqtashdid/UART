module receiver(input wire rx,
		   output wire rx_busy,
		   //input wire rdy_clr,
		   input wire rxclk,
		   input wire rxclken,
		   output reg [7:0] dout);

initial begin
	//rdy = 0;
	dout=8'b0;
end
parameter CLKS_PER_BIT 		= 1085;			//clock=1GHz ; baud rate=115200x8=921600; clocks/bit=1G/921600=1085
parameter RX_STATE_IDLE		= 2'b00;
parameter RX_STATE_START	= 2'b01;
parameter RX_STATE_DATA		= 2'b10;
parameter RX_STATE_STOP		= 2'b11;

reg [1:0] state 	= RX_STATE_IDLE;
reg [15:0] counter 	= 0;
reg [2:0] bitpos 	= 0;


always @(posedge rxclk) begin
              
          
	//if (rdy_clr)
	//	rdy <= 0;

	
	case (state)

		RX_STATE_IDLE :	begin
		if (rxclken) begin
         		//rdy    	<= 1'b0;			//no valid dout being received
          		counter	<= 0;				//counter set to 0
          		bitpos	<= 0;				//index position
          
          		if (rx == 1'b0)      			// Start bit detected
            			state <= RX_STATE_START;
          		else
            			state <= RX_STATE_IDLE;
        	end
		
		else
			state <= RX_STATE_IDLE;
		
		end
		RX_STATE_START: begin
		if (rxclken) begin
          			if (counter > (CLKS_PER_BIT-1)/2) begin
            				if (rx == 1'b0) begin
              					counter	<= 0;  			// reset counter, found the middle
              					state   <= RX_STATE_DATA;	//move to the next state
            				end 
            				else					//anomaly detected, go back to idle state
            					state <= RX_STATE_IDLE;
          			end
          			else begin
          				counter <= counter + 1;			//increase counter
          				state   <= RX_STATE_START;		//stay on the current state
          			end
        		end	

		else begin
			state 	<= RX_STATE_IDLE;
			counter 	<= 0;
			bitpos 	<= 0;

		
		end
		end
		


		RX_STATE_DATA : begin
          	if (rxclken) begin	
			if (counter < (CLKS_PER_BIT-1)/2) begin		//until counter reaches middle sampling point
            			counter <= counter + 1; 		//increase counter
            			state   <= RX_STATE_DATA;		//stay on the current state
          		end
          		else begin					//when at middle sampling point
          
            			counter      <= 0;		//reset counter
            			dout[bitpos] <= rx;	//start converting to byte
            
            						// Check if we have received all bits
            			if (bitpos < 7) begin
              				bitpos <= bitpos + 1;		//increasing index
              				state  <= RX_STATE_DATA;
            			end
            			else begin
              				bitpos <= 0;			//received all dout as byte, set index=0
              				state  <= RX_STATE_STOP;		//go to next state
            			end
          		end
		end
		else begin
			state 	<= RX_STATE_IDLE;
			counter 	<= 0;
			bitpos 	<= 0;

		
		end
        	end // case: RX_STATE_DATA
      		RX_STATE_STOP : begin
		if (rxclken) begin
          		if (counter < CLKS_PER_BIT) begin
            			counter <= counter + 1;
     	    			state   <= RX_STATE_STOP;
          		end
          		else begin
       	    			//rdy		<= 1'b1;
            			counter 	<= 0;
            			state		<= RX_STATE_IDLE;
				$display("Output : %b",dout);
          		end
		end
		else begin
			state 	<= RX_STATE_IDLE;
			counter 	<= 0;
			bitpos 	<= 0;

		
		end
        	end
      
		
		default: begin
			state <= RX_STATE_IDLE;
		end
		endcase
	

end

assign rx_busy = (state != RX_STATE_IDLE);	//busy when not idle 

endmodule
