////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 7-11-2022
// Module name: RegisterFileTb
// Description: Testbench for the register file
////////////////////////////////////////////////////////////////////////

module RegisterFileTb();
	logic        Clock = 0;
	logic [5:0]  AddressA;
	logic [15:0] ReadDataA;
	logic [15:0] WriteData;
	logic        WriteEnable;
	logic [5:0]  AddressB;
	logic [15:0] ReadDataB;

	RegisterFile uut(.*);
		
	default clocking @(posedge Clock);
	endclocking
		
	always  #10  Clock++;

	initial
	begin

		// Enables and writes data to the first 5 addresses
		#10;
		WriteEnable = 1;
		AddressA = '0;
		WriteData = '0;
		
		#10;
		AddressA = 1;
		WriteData = 1;
		
		#10;
		AddressA = 2;
		WriteData = 2;
		
		#10;
		AddressA = 3;
		WriteData = 3;
		
		#10;
		AddressA = 4;
		WriteData = 4;
		
		#10;
		AddressA = 5;
		WriteData = 5;
		
		// Disables the writing and reads from addresses 0, 1 then 4, and 5
		#10;#10;
		WriteEnable = 0;
		AddressA = 0;
		AddressB = 1;
		
		#10;
		AddressA = 4;
		AddressB = 5;
		
	end
	
endmodule
