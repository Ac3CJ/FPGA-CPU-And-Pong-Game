////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 7-11-2022
// Module name: ProgramCounter
// Description: Used to count, count by an offset value, and load PC values
////////////////////////////////////////////////////////////////////////

module ProgramCounter(
	input Clock, Reset,
	input logic signed [15:0] LoadValue,
	input LoadEnable,
	input logic signed [8:0] Offset,
	input logic OffsetEnable,
	output logic signed [15:0] CounterValue
);

	logic [15:0] nextCount; // Assigns the Values

	// Sets the CounterValues depending on what is enabled
	always_ff@(posedge Clock) begin
	
		if (Reset) CounterValue <= '0;							// If Reset is HIGH, set the counter values to 0
		else if (LoadEnable) CounterValue <= LoadValue;		// If Reset is not HIGH and LoadEnable is HIGH, set counter values to Load Values
		else CounterValue <= nextCount;							// If the above statements are not meant, default to using the next counter values
	end
	
	// Incremental Code
	always_comb begin
	
		if (OffsetEnable) nextCount = CounterValue + Offset;		// If Offset is enabled, add counter value by the offset
		else nextCount = CounterValue + 1; 								// If Offset is not enabled, add 1
	end

endmodule 