////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 7-11-2022
// Module name: RegisterFile
// Description: Writes and Reads to the registers
////////////////////////////////////////////////////////////////////////

module RegisterFile(
	input Clock,
	input logic [5:0] AddressA,
	output logic [15:0] ReadDataA,
	input logic [15:0] WriteData,
	input WriteEnable,
	
	input logic [5:0] AddressB,
	output logic [15:0] ReadDataB
);

	logic [15:0] Registers [64]; 			// Creates 64 Registers of 16 bit width
	
	always_ff@(posedge Clock) begin
		if (WriteEnable) Registers[AddressA] <= WriteData; // If WriteEnable is HIGH, set counter values to the new values
	end
	
	// Reads the data from the chosen address
	assign ReadDataA = Registers[AddressA];
	assign ReadDataB = Registers[AddressB];
endmodule 