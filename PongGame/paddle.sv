////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 7-12-2022
// Module name: paddle
// Description: Paddle module of the Pong Game, this controls the movement of the paddle 
////////////////////////////////////////////////////////////////////////

module paddle
#(									// default values
	pLeft = 30,					// x position of the left paddle
	pTop = 225,					// y position of the left paddle
	
	oHeight = 150,				// height of the paddle
	oWidth = 50,				// width of the paddle
	sHeight = 600,				// height of the screen
	
	yDirMove = 1,				// left paddle movement in y direction
	alwaysDisplay = 0			//	Used to always display the paddle even if out of range
)
(
	input PixelClock,									// slow clock to dispay pixels
	input Reset,										// reset position/movement of the paddle
	input  logic [10:0] xPos,						// x position of hCounter
	input  logic [ 9:0] yPos,						// y position of vCounter
	output logic drawPaddle,						// activates/deactivates drawing
	input logic [1:0] butCont,						// Buttons
	output logic [10:0] padPosX, padPosY		// Used to output the position of the paddle
);
	// Function to check if the movement is valid or not
	/*function logic MoveCheck(
		input padTop, padBottom, padUp, padDown, sHeight
	);
		logic valid;
		
		if ((padTop <= 1) & (padUp)) valid = 0;
		else valid = 1;
		if ((padBottom >= sHeight) & (padUp)) valid = 0;
		else valid = 1;
		
		return valid;
	endfunction*/
	
	// Paddle Sprite Boundaries
	logic [10:0] padLeft;						
	logic [10:0] padRight;
	
	logic [10:0] padTop;
	logic [10:0] padBottom;

	// Paddle Positions
	logic [10:0] pX = pLeft;
	logic [10:0] pY = pTop;
	
	
	// Assign Positions
	assign padLeft = pX;						// left(x) position of the paddle
	assign padRight = pX + oWidth;		// right(x+width) position of the paddle
	assign padTop = pY;						// top(y) position of the paddle
	assign padBottom = pY + oHeight;		// bottom(y+height) position of the paddle
	
	always_ff @(posedge PixelClock)
	begin
		if( Reset == 1 ) begin					// all values are initialised, whenever the reset(SW[9]) is 1
			pX <= pLeft;
			pY <= pTop;
			padPosX <= pLeft;
			padPosY <= pTop;
		end
		else begin
		
			// If the alwaysDisplay is off, then allow for movement and collisions with walls
			if (alwaysDisplay == 0) begin
				if ((padTop < 1) | padBottom > sHeight) begin 					// Checks if the paddle is at the screen edges
					if (padTop < 1) pY <= 2;											// If at the top, move it one pixel down to not get stuck	
					if (padBottom > sHeight) pY <= sHeight - (oHeight + 1);	//	If at bottom, move it one pixel above the bottom to not get stuck
				end
				else begin
					if (^(butCont)) begin						// Checks if one of the buttons are pressed
						if (butCont[1]) pY <= pY - 1;			// If the left button is pressed, move up
						if (butCont[0]) pY <= pY + 1;			// If right button pressed, move down
					end
				end
			end
			
			// Assign the output variables to the local values
			padPosX <= pX;		
			padPosY <= pY;
		end
	end

	// drawpaddle is 1 if the screen counters (hCount and vCount) are in the area of the paddle
	// otherwise, drawpaddle is 0 and the paddle is not drawn.
	// drawpaddle is used by the top module PongGame
	assign drawPaddle = ((xPos > padLeft) & (yPos > padTop) & (xPos < padRight) & (yPos < padBottom)) ? 1 : 0;
	
endmodule 