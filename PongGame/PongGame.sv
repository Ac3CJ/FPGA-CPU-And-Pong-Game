////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 7-12-2022
// Module name: PongGame
// Description: Top Module of the Pong Game
////////////////////////////////////////////////////////////////////////

module PongGame
(
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output logic [6:0] HEX0, HEX1, HEX4, HEX5,
	output logic VGA_CLK,
	output logic VGA_BLANK_N,
	output logic VGA_SYNC_N,
	output logic VGA_HS,
	output logic VGA_VS,
	output logic [7:0] VGA_R,
	output logic [7:0] VGA_G,
	output logic [7:0] VGA_B
);

	assign VGA_CLK = ~CLOCK_50;


	logic [10:0] xPos;			// current x position of hCount from the VGA controller
	logic [ 9:0] yPos;			// current y position of vCount from the VGA controller
	
	logic [6:0] leftScore;
	logic [6:0] rightScore;

	
	logic drawBall;
	logic drawPaddleL;
	logic drawPaddleR;
	logic drawHalfLine;
	
	// Paddle Positions
	logic [10:0] padlPosX;
	logic [10:0] padlPosY;
	logic [10:0] padrPosX;
	logic [10:0] padrPosY;
	
	// instantiation of the VGA controller
	VgaController vgaDisplay
	(
		.Clock(CLOCK_50),
		.Reset(SW[9]),
		.blank_n(VGA_BLANK_N),
		.sync_n(VGA_SYNC_N),
		.hSync_n(VGA_HS),
		.vSync_n(VGA_VS),
		.nextX(xPos),
		.nextY(yPos)
	);
	

	// instatiation of the slowClock module
	slowClock #(17) tick(CLOCK_50, SW[9], pix_stb);

	// instantiation of the paddle module
	// oLeft and oTop define the x,y initial position of the object
	paddle #(.pLeft(30), .pTop(225)) PaddleLObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.drawPaddle(drawPaddleL),
		.butCont(~KEY[3:2]),
		.padPosX(padlPosX),
		.padPosY(padlPosY)
	);
	
	// instantiate the right paddle module
	paddle #(.pLeft(720), .pTop(225)) PaddleRObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.drawPaddle(drawPaddleR),
		.butCont(~KEY[1:0]),
		.padPosX(padrPosX),
		.padPosY(padrPosY)
	);
	
	// instantiate a paddle module for the middle bar, 
	paddle #(.pLeft(395), .pTop(0), .oHeight(600), .oWidth(10), .alwaysDisplay(1)) HalfLineObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.drawPaddle(drawHalfLine),
		.butCont(2'b00),
		.padPosX(0),
		.padPosY(0)
	);
	
	// instantiation of the ball module
	// oLeft and oTop define the x,y initial position of the object
	ball #(.oLeft(390), .oTop(290)) BallObj
	(
		.PixelClock(pix_stb),
		.Reset(SW[9]),
		.xPos(xPos),
		.yPos(yPos),
		.drawBall(drawBall),
		.plPosX(padlPosX),
		.plPosY(padlPosY),
		.prPosX(padrPosX),
		.prPosY(padrPosY),
		.leftScore(leftScore),
		.rightScore(rightScore)
	);
	
	// this block is used to draw all the objects on the screen
	// you can add more objects and their corresponding colour
	always_comb
	begin
	
		// Uses draw conditions from each module to draw the respective object, the drawing is contrained by the position of each object
		if (drawBall) {VGA_R, VGA_G, VGA_B} = {8'hFF, 8'h00, 8'h00};				// Draw ball red
		else if (drawPaddleL) {VGA_R, VGA_G, VGA_B} = {8'hFF, 8'h7B, 8'h00};		// Draw left paddle orange
		else if (drawPaddleR) {VGA_R, VGA_G, VGA_B} = {8'h00, 8'hFF, 8'hF7};		// Draw right paddle light blue
		else if (drawHalfLine) {VGA_R, VGA_G, VGA_B} = {8'hFF, 8'hFF, 8'hFF};	// Draw half line white
		else {VGA_R, VGA_G, VGA_B} = {8'h00, 8'h00, 8'h00};							// Draw black for background
	end
	
	// Score Display
	DecimalDisplayTwoDigit U0(rightScore, HEX1, HEX0);
	DecimalDisplayTwoDigit U1(leftScore, HEX5, HEX4);
	
endmodule

// #################################################################################
// ################################# EXTRA MODULES #################################
// #################################################################################
// These modules were reused from PC Counter, which were given before

module DecimalDisplayTwoDigit 
#(
	parameter		ActiveValue = 0		// The output value that switches an LED on.
)
(
	input 	[6:0]	Value, 					// The input value in the decimal range 0-F
	output 	[6:0]	Segments1,Segments0  // The 7 bit outputs for the 7 segment displays.
);

	wire 	[6:0]	Digit [1:0];
	wire 			Blank [1:0];

	// Separate the digits
	assign Digit[0] = Value % 4'd10;
	assign Digit[1] = Value / 4'd10;

	// Set the blanking conditions
	assign Blank[0] = (Value > 7'd99) ? 1'b1 : 1'b0;
	assign Blank[1] = (Digit[1] == 7'd0) ? 1'b1 : Blank[0];

	// Instantiate the LED decoders
	SevenSegmentDecoder #(ActiveValue) decoder0 (Digit[0][3:0],Blank[0],Segments0);
	SevenSegmentDecoder #(ActiveValue) decoder1 (Digit[1][3:0],Blank[1],Segments1);

endmodule

module SevenSegmentDecoder 
#(
	parameter				ActiveValue = 0	// The output value that switches an LED on.
)
(
	input		[3:0] Value,						// The input value in the HEX range 0-F
	input 		 	Blank,						// An input which causes all LED outputs
														// to be off if this input is active (1)
	output 	[6:0] SegmentsOut					// The 7 bit output for the 7 segment display.
);

	logic  	[6:0] Segments;

	always @*
	begin
	   // Create the right bit sequence to drive the 7 segment 
		// display based upon the input value and whether or not
		// blanking is applied.
		case ({Blank,Value})
			0: 		Segments = 7'b0111111;
			1: 		Segments = 7'b0000110;
			2: 		Segments = 7'b1011011;
			3: 		Segments = 7'b1001111;
			4: 		Segments = 7'b1100110;
			5: 		Segments = 7'b1101101;
			6:			Segments = 7'b1111101;
			7: 		Segments = 7'b0000111;
			8: 		Segments = 7'b1111111;
			9: 		Segments = 7'b1101111;
			10: 		Segments = 7'b1110111;
			11: 		Segments = 7'b1111100;
			12: 		Segments = 7'b0111001;
			13: 		Segments = 7'b1011110;
			14: 		Segments = 7'b1111001;
			15: 		Segments = 7'b1110001;
			default:	Segments = 7'b0000000;
		endcase
	end

	// Invert the result if the output is active low.
	assign SegmentsOut = (ActiveValue == 1) ? Segments : ~Segments;
endmodule
