////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 7-11-2022
// Module name: ProgramCounterTestBench
// Description: Testbench for the PC
////////////////////////////////////////////////////////////////////////

module ProgramCounterTestBench();

	// These are the signals that connect to 
	// the program counter
	logic              	Clock = '0;
	logic              	Reset;
	logic signed   [15:0]	LoadValue;
	logic				LoadEnable;
	logic signed  [8:0]	Offset;
	logic 					OffsetEnable;
	logic signed  [15:0]	CounterValue;

	// this is another method to create an instantiation
	// of the program counter
	ProgramCounter uut
	(
		.Clock,
		.Reset,
		.LoadValue,
		.LoadEnable,
		.Offset,
		.OffsetEnable,
		.CounterValue
	);
	

	default clocking @(posedge Clock);
	endclocking
		
	always  #10  Clock++;

	initial
	begin

	// Check if it counts up by one
	#10;
	Reset = 1;
	LoadEnable = 0;
	OffsetEnable = 0;
	Offset = 0;
	
	#10;
	Reset = 0;
	LoadEnable = 0;
	OffsetEnable = 0;
	Offset = 0;
	
	#10;#10;#10;#10;#10;
	// Check if the load value is right
	#10;
	LoadValue = 16'b1010_1010_1010_1010;
	LoadEnable = 1;
	Offset = -1;
	
	#10;#10;#10;#10;#10;
	// Shut off loadEnable and check if the offset decrements the PC
	#10;
	LoadEnable = 0;
	OffsetEnable = 1;
	
	#10;
	LoadEnable = 0;
	
	end
endmodule
	
	