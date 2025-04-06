////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 7-12-2022
// Module name: ball
// Description: Ball module of the Pong Game, this controls the movement of the ball, collisions, and score
////////////////////////////////////////////////////////////////////////

module ball
#(								// default values
	oLeft = 10,				// x position of the ball
	oTop = 10,				// y position of the ball
	oHeight = 20,			// height of the ball
	oWidth = 20,			// width of the ball
	pHeight = 150,
	pWidth = 50,
	sWidth = 800,			// width of the screen
	sHeight = 600,			// height of the screen
	xDirMove = 0,			// ball movement in x direction
	yDirMove = 1			// ball movement in y direction
)
(
	input PixelClock,					// slow clock to display pixels
	input Reset,						// reset position/movement of the ball
	input  logic [10:0] xPos,		// x position of hCounter
	input  logic [ 9:0] yPos,		// y position of vCounter
	output logic drawBall,			// activates/deactivates drawing
	
	// Inherit Paddle Positions
	input logic [10:0] plPosX,
	input logic [10:0] plPosY,
	input logic [10:0] prPosX,
	input logic [10:0] prPosY,
	
	output logic [5:0]leftScore, rightScore		// Score variables
);
	
	//################################## MAIN CODE ##################################

	// Ball Boundaries
	logic [10:0] left;						
	logic [10:0] right;						
	logic [10:0] top;
	logic [10:0] bottom;
	
	// Left Paddle Boundaries
	logic [10:0] padlLeft;						
	logic [10:0] padlRight;						
	logic [10:0] padlTop;
	logic [10:0] padlBottom;
	
	// Right Paddle Boundaries
	logic [10:0] padrLeft;						
	logic [10:0] padrRight;						
	logic [10:0] padrTop;
	logic [10:0] padrBottom;

	// Ball Coordinates
	logic [10:0] ballX = oLeft;
	logic [10:0] ballY = oTop;
	
	// Local scores, if not included the score will be a random value on initialisation
	logic [5:0] localLeftScore = 0;
	logic [5:0] localRightScore = 0;

	// Direction Varables
	logic xdir = xDirMove;
	logic ydir = yDirMove;	
		
	assign left = ballX;						// left(x) position of the ball
	assign right = ballX + oWidth;		// right(x+width) position of the ball
	assign top = ballY;						// top(y) position of the ball
	assign bottom = ballY + oHeight;		// bottom(y+height) position of the ball
	
	// Initialise paddle side values
	assign padlLeft = plPosX;
	assign padlRight = plPosX + pWidth;
	assign padlTop = plPosY;
	assign padlBottom = plPosY + pHeight;
	
	assign padrLeft = prPosX;
	assign padrRight = prPosX + pWidth;
	assign padrTop = prPosY;
	assign padrBottom = prPosY + pHeight;

		
	always_ff @(posedge PixelClock)
	begin
		if( Reset == 1 ) begin		// all values are initialised
											// whenever the reset(SW[9]) is 1
				ballX <= oLeft;
				ballY <= oTop;
				xdir <= xDirMove;
				ydir <= yDirMove;
				leftScore <= 0;
				rightScore <= 0;
				localLeftScore <= 0;
				localRightScore <= 0;
		end
		else begin				
				ballX <= (xdir == 1) ? ballX + 1 : ballX - 1;	// changes movement of the ball in x direction
				ballY <= (ydir == 1) ? ballY + 1 : ballY - 1;	// changes movement of the ball in y direction
					
				// NOTE: For xdir and ydir, 1 is down or right, 0 is up or left
					
				// Upper and lower screen collisions
				if (top  <= 1) ydir <= 1; 				// Ball bounces down, when it hits top of screen
				if (bottom >= sHeight) ydir <= 0;	// Ball bounces up, when it hits bottom
					
					
				// ################### LEFT PADDLE COLLISION ###################
					
				// Ball bottom lower than left pad top, Ball Top higher than left pad bottom, Ball left is to the left of pad right
				if ((bottom >= padlTop) & (top <= padlBottom) & (left <= padlRight) & (bottom <= padlBottom) & (top >= padlTop)) xdir <= 1;
					
				// Ball right is right of the pad left, ball left is left of the pad left, ball top is above or equal to pad bottom, check if below pad top
				else if ((right >= padlLeft) & (left <= padlRight) & (top <= padlBottom) & (top >= padlTop)) ydir <= 1;
					
				// Same as above, but checks if ball bottom is above pad bottom and below pad top 
				else if ((right >= padlLeft) & (left <= padlRight) & (bottom <= padlBottom) & (bottom >= padlTop)) ydir <= 0;
					
					
				// ################### RIGHT PADDLE COLLISION ###################
					
				// This is the same as the left collisions but for the right paddle
				if ((bottom >= padrTop) & (top <= padrBottom) & (right >= padrLeft) & (bottom <= padrBottom) & (top >= padrTop)) xdir <= 0;

				else if ((right >= padrLeft) & (left <= padrRight) & (top <= padrBottom) & (top >= padrTop)) ydir <= 1;
				
				else if ((right >= padrLeft) & (left <= padrRight) & (bottom <= padrBottom) & (bottom >= padrTop)) ydir <= 0;
					
				// ################################# SCORING #################################
				
				// If the ball hits the sides of the screens
				if ((left <= 1) | (right >= sWidth)) begin 
				
					// Reset the ball coordinates and y direction
					ballX <= oLeft;
					ballY <= oTop;
					ydir <= yDirMove;
					
					// If the ball hits the left side, add score to the right player and set xdir so ball goes to left player
					if (left <= 1) begin 
						localRightScore <= localRightScore + 1;
						xdir <= 0;
					end
					
					// If the ball hits the right side, add score to the left player and set xdir so ball goes to right player
					else begin 
						localLeftScore <= localLeftScore + 1;
						xdir <= 1;
					end
				end
				
				// Set the output variables to the value of the local variables
				rightScore <= localRightScore;
				leftScore <= localLeftScore;
		end
	end

	// drawball is 1 if the screen counters (hCount and vCount) are in the area of the ball
	// otherwise, drawball is 0 and the ball is not drawn.
	// drawball is used by the top module PongGame
	assign drawBall = ((xPos > left) & (yPos > top) & (xPos < right) & (yPos < bottom)) ? 1 : 0;

endmodule 
