////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 29-11-2022
// Module name: ArithmeticLogicUnit
// Description: Creates the functionality for the instructions in a HighRisc Processor
////////////////////////////////////////////////////////////////////////

// ArithmeticLogicUnit
// This is a basic implementation of the essential operations needed
// in the ALU. Adding futher instructions to this file will increase 
// your marks.

// Load information about the instruction set. 
import InstructionSetPkg::*;

// Define the connections into and out of the ALU.
module ArithmeticLogicUnit
(
	// The Operation variable is an example of an enumerated type and
	// is defined in InstructionSetPkg.
	input eOperation Operation,
	
	// The InFlags and OutFlags variables are examples of structures
	// which have been defined in InstructionSetPkg. They group together
	// all the single bit flags described by the Instruction set.
	input  sFlags    InFlags,
	output sFlags    OutFlags,
	
	// All the input and output busses have widths determined by the 
	// parameters defined in InstructionSetPkg.
	input  signed [ImmediateWidth-1:0] InImm,
	
	// InSrc and InDest are the values in the source and destination
	// registers at the start of the instruction.
	input  signed [DataWidth-1:0] InSrc,
	input  signed [DataWidth-1:0]	InDest,
	
	// OutDest is the result of the ALU operation that is written 
	// into the destination register at the end of the operation.
	output logic signed [DataWidth-1:0] OutDest
);
	
	// This block allows each OpCode to be defined. Any opcode not
	// defined outputs a zero. The names of the operation are defined 
	// in the InstructionSetPkg. 
	always_comb
	begin
	
		// By default the flags are unchanged. Individual operations
		// can override this to change any relevant flags.
		OutFlags  = InFlags;
		
		// The basic implementation of the ALU only has the NAND and
		// ROL operations as examples of how to set ALU outputs 
		// based on the operation and the register / flag inputs.
		casez(Operation)		
		
			ROL: begin 
				{OutFlags.Carry,OutDest} = {InSrc,InFlags.Carry};	
				
			end
			
			NAND:    begin 
				OutDest = ~(InSrc & InDest);
				
			end


			// ***** ONLY CHANGES BELOW THIS LINE ARE ASSESSED *****
			// Put your instruction implementations here.
			
			MOVE: begin 
				OutDest = InSrc;													// Sets OutDest to InSrc
				
			end
			
			NOR:	begin 
				OutDest = ~(InDest | InSrc);									// Applies an OR then NOT function to the result to get a NOR
				
			end 
			
			ROR: begin 
				{OutDest,OutFlags.Carry} = {InFlags.Carry,InSrc};		// Same as ROL but the order of appended bits are swapped
				
			end
			
			LIL: begin 
				OutDest = (DataWidth)'(signed'(InImm));					// Sign Extends the InImm bits to fit the DataWidth size
				
			end
			
			LIU:	begin
				// Checks the first immediate bit
				
				// Sets the first part of the InDest to the 4 bits of InImm, leave the remaining bits unchanged
				if (InImm[ImmediateWidth-1] == 1) OutDest = {InImm[ImmediateWidth-2:0],InDest[ImmediateHighStart-1:0]};
				
				// Creates a Signed InImm to fit the OutDest Width, leaves the remaining bits unchanged
				else OutDest = {(DataWidth-ImmediateWidth)'(signed'(InImm)),InDest[ImmediateWidth-1:0]};		
				
			end
			
			ADC:	begin
				{OutFlags.Carry,OutDest} = InDest + InFlags.Carry +InSrc;		//Concatenates the Carry to the MSB of InSrc and performs addition
				
				OutFlags.Zero = ~|(OutDest);												// Performs the NOR function on the output to check for 0s
				
				OutFlags.Parity = (~^(OutDest))|(~|(OutDest));						// Performs a NXOR function on the output
				
				OutFlags.Negative = (OutDest < 0);										// Returns a Boolean 1 if the result is less than 0
				
				OutFlags.Overflow = ((~InDest[DataWidth-1])&(~InSrc[DataWidth-1])&(OutDest[DataWidth-1]))|	// Logic: Flag = ~A~BC+AB~C
					((InDest[DataWidth-1])&(InSrc[DataWidth-1])&(~OutDest[DataWidth-1]));							// From Instruction Set Table
				
				
			end
			
			SUB:	begin
				{OutFlags.Carry,OutDest} = InDest - (InSrc + InFlags.Carry);	//Concatenates the Carry to the MSB of InSrc and performs subtraction
				
				OutFlags.Zero = ~|(OutDest);												// Performs the NOR function on the output to check for 0s
				
				OutFlags.Parity = (~^(OutDest))|(~|(OutDest));						// Performs a NXOR function to check for an even number of 1s
				
				OutFlags.Negative = (OutDest < 0);										// Returns a Boolean 1 if the result is less than 0
				
				OutFlags.Overflow = ((~InDest[DataWidth-1])&(InSrc[DataWidth-1])&(OutDest[DataWidth-1]))| // Logic: Flag = ~ABC+A~B~C
					((InDest[DataWidth-1])&(~InSrc[DataWidth-1])&(~OutDest[DataWidth-1]));						 // From Instruction Set Table
				
				
			end
			
			DIV:	begin
				if (InSrc != 0) OutDest = InDest / InSrc; 		// If the source is not zero, perform a division operation
				
				else OutDest = 0; 										// Else set Outdest to zero
				
				OutFlags.Zero = ~|(OutDest);							// Performs the NOR function on the output to check for 0s
				
				OutFlags.Parity = (~^(OutDest))|(~|(OutDest));	// Performs a NXOR function to check for an even number of 1s
				
				OutFlags.Negative = (OutDest < 0);					// Returns a Boolean 1 if the result is less than 0
			end
			
			MOD:	begin
				if (InSrc != 0) OutDest = InDest % InSrc;			// Perform a mod operation if the source is not zero
				
				else OutDest = 0; 										// Else set Outdest to zero
				
				OutFlags.Zero = ~|(OutDest);							// Performs the NOR function on the output to check for 0s
				
				OutFlags.Parity = (~^(OutDest))|(~|(OutDest));	// Performs a NXOR function to check for an even number of 1s
				
				OutFlags.Negative = (OutDest < 0);					// Returns a Boolean 1 if the result is less than 0
			end
			
			MUL:	begin
				OutDest = InDest * InSrc;								// Perform multiplication
				
				OutFlags.Zero = ~|(OutDest);							// Performs the NOR function on the output to check for 0s
				
				OutFlags.Parity = (~^(OutDest))|(~|(OutDest));	// Performs a NXOR function to check for an even number of 1s
				
				OutFlags.Negative = (OutDest < 0);					// Returns a Boolean 1 if the result is less than 0
			end
			
			MUH:	begin 				
				OutDest = (InDest * InSrc) / (2**(DataWidth));	// Perform multiplication and bit shift it by the datawidth
				
				OutFlags.Zero = ~|(OutDest);							// Performs the NOR function on the output to check for 0s
				
				OutFlags.Parity = (~^(OutDest))|(~|(OutDest));	// Performs a NXOR function to check for an even number of 1s
				
				OutFlags.Negative = (OutDest < 0);					// Returns a Boolean 1 if the result is less than 0
			end
			
			// ***** ONLY CHANGES ABOVE THIS LINE ARE ASSESSED	*****		
			
			default:	begin 
				OutDest = '0;
			end
			
		endcase;
	end

endmodule
