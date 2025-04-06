////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 28-11-2022
// Module name: VgaController
// Description: Used to sync the VGA Controller
////////////////////////////////////////////////////////////////////////

module VgaController
(
	input	logic	Clock,
	input	logic	Reset,
	output	logic	blank_n,
	output	logic	sync_n,
	output	logic	hSync_n,
	output	logic 	vSync_n,
	output	logic	[10:0] nextX,
	output	logic	[ 9:0] nextY
);

	// use this signal as counter for the horizontal axis 
	logic [10:0] hCount;

	// use this signal as counter for the vertical axis
	logic [ 9:0] vCount;
	
	
	// add here your code for the VGA controller
	
	// Monitor Sync Req.
	// Resolution: 800x600
	// Pixel Clock: 50 MHz
	
	// Front Porch: Horiz 56  | Vert 37
	// Sync Pulse:  Horiz 120 | Vert 6
	// Back Porch:  Horiz 64  | Vert 23
	
	
	always_ff@(posedge Clock) begin
	
		// Reset Code
		if (Reset) begin	// If Reset is high, set the hCount and vCount to 0
			hCount <= 0;
			vCount <= 0;
		end
		
		// Count Code
		if (hCount > 1039) hCount <= 0; 								// If the hCount is greater than the Back Porch, set it to zero
		else hCount <= hCount + 1;										// Else count up
		
		if (vCount > 665) vCount <= 0;								// If the vCount is greater than the Back Porch, set it to zero
		else if (hCount > 1039) vCount <= vCount + 1;			// Else count up
		
		// Sync Code
		if (hCount < 800) nextX <= hCount;							// If the hCount is in visible range, set nextX to current hCount
		else nextX <= 0;													// Else set it to zero
		
		if (vCount < 600) nextY <= vCount;							// If the vCount is in visible range, set nextY to current hCount
		else nextY <= 0;													// Else set it to zero
		
		if ((hCount >= 800)|(vCount >= 600)) blank_n <= 0;		// If out of the visual range, set blank_n to zero
		else blank_n <= 1;												// Else set it to 1
		
		if (hCount >= 856 & hCount < 976) hSync_n <= 0;			// If between Front Porch and Sync Pulse, set hSync_n to zero
		else hSync_n <= 1;												// Else set it to 1
		
		if (vCount >= 637 & vCount < 643) vSync_n <= 0;			// If between Front Porch and Sync Pulse, set vSync_n to zero
		else vSync_n <= 1;												// Else set it to 1
		
		if (((hCount >= 856) & (hCount < 976)) | ((vCount >= 637) & (vCount < 643))) sync_n <= 0; 	// If outside one of the front porches
		else sync_n <= 1;																										// Else, set sync_n to 1
		
	end
endmodule
