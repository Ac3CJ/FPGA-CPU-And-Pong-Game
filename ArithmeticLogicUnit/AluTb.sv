////////////////////////////////////////////////////////////////////////
// Author(s): Conrad Gacay (cjg75) and Chanin Bulakul (cb2464)
// Date: 29-11-2022
// Module name: AluTb
// Description: Testbench for the ALU
////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

import InstructionSetPkg::*;

// This module implements a set of tests that 
// partially verify the ALU operation.
module AluTb();

	eOperation Operation;
	
	sFlags    InFlags;
	sFlags    OutFlags;
	
	logic signed [ImmediateWidth-1:0] InImm = '0;
	
	logic	signed [DataWidth-1:0] InSrc  = '0;
	logic signed [DataWidth-1:0] InDest = '0;
	
	logic signed [DataWidth-1:0] OutDest;

	ArithmeticLogicUnit uut (.*);

	initial
	begin
		InFlags = sFlags'(0);
		
		$display("Start of NAND tests");
		Operation = NAND;
		
		InDest = 16'h0000;
		InSrc  = 16'ha5a5;      
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'h9999; 
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'hFFFF; 
	   #1 if (OutDest != 16'h5a5a) $display("Error in NAND operation at time %t",$time);
		
		#10 InDest = 16'h1234; 
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h0000;   
		InDest = 16'ha5a5;     
	   #1 if (OutDest != 16'hFFFF) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h9999;  
	   #1 if (OutDest != 16'h7E7E) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'hFFFF; 
	   #1 if (OutDest != 16'h5a5a) $display("Error in NAND operation at time %t",$time);
		
		#10 InSrc = 16'h1234;  
	   #1 if (OutDest != 16'hFFDB) $display("Error in NAND operation at time %t",$time);
		#50;

		
		$display("Start of ADC tests");
		Operation = ADC;
		
		InDest = 16'h0000;
		InSrc = 16'ha5a5;   
	   #1 
		if (OutDest != 16'ha5a5) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InFlags.Carry = '1;
	   #1 
		if (OutDest != 16'ha5a6) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in ADC operation at time %t",$time);

		#10 InDest = 16'h5a5a; 
	   #1 
		if (OutDest != 16'h0000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(11)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h8000;
		InFlags.Carry = '0;
		InSrc = 16'hffff;      
	   #1 
		if (OutDest != 16'h7fff) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(17)) $display("Error (flags) in ADC operation at time %t",$time);
		
		#10 InDest = 16'h7fff;
		InSrc = 16'h0001;     
	   #1 
		if (OutDest != 16'h8000) $display("Error in ADC operation at time %t",$time);
	   if (OutFlags != sFlags'(20)) $display("Error (flags) in ADC operation at time %t",$time);
		#50;

		
		$display("Start of LIU tests");
		Operation = LIU;
		
		InDest = 16'h0000; 
		InImm = 6'h3F;	
	   #1 if (OutDest != 16'hF800) $display("Error in LIU operation at time %t",$time);
		
		#10 InImm = 6'h0F;		 
	   #1 if (OutDest != 16'h03C0) $display("Error in LIU operation at time %t",$time);	
		
		#10 InDest = 16'hAAAA;
	   #1 if (OutDest != 16'h03EA) $display("Error in LIU operation at time %t",$time);
		
		#10 InImm = 6'h3F;      	
	   #1 if (OutDest != 16'hFAAA) $display("Error in LIU operation at time %t",$time);	

		
		
		// Put your code here to verify the instructions.
		#50;
		$display("Start of MOVE tests");
		Operation = MOVE;
		
		InSrc = 16'hAAAA;
		#1 if (OutDest != 16'hAAAA) $display("Error in MOVE operation at time %t",$time);
		
		#10;
		InSrc = 16'hFFFF;
		#1 if (OutDest != 16'hFFFF) $display("Error in MOVE operation at time %t",$time);
		
		#10;
		InSrc = 16'h1F20;
		#1 if (OutDest != 16'h1F20) $display("Error in MOVE operation at time %t",$time);
		
		
		//###############################################################################
		#50;
		$display("Start of NOR tests");
		Operation = NOR;
		
		InDest = 16'h0000;
		InSrc  = 16'ha5a5;      
	   #1 if (OutDest != 16'h5A5A) $display("Error in NOR operation at time %t",$time);
		
		#10 InDest = 16'h9999; 
	   #1 if (OutDest != 16'h4242) $display("Error in NOR operation at time %t",$time);
		
		#10 InDest = 16'hFFFF; 
	   #1 if (OutDest != 16'h0000) $display("Error in NOR operation at time %t",$time);
		
		#10 InDest = 16'h1234; 
	   #1 if (OutDest != 16'h484A) $display("Error in NOR operation at time %t",$time);
		
		#10 InSrc = 16'h0000;   
		InDest = 16'ha5a5;     
	   #1 if (OutDest != 16'h5A5A) $display("Error in NOR operation at time %t",$time);
		
		#10 InSrc = 16'h9999;  
	   #1 if (OutDest != 16'h4242) $display("Error in NOR operation at time %t",$time);
		
		#10 InSrc = 16'hFFFF; 
	   #1 if (OutDest != 16'h0000) $display("Error in NOR operation at time %t",$time);
		
		#10 InSrc = 16'h1234;  
	   #1 if (OutDest != 16'h484A) $display("Error in NOR operation at time %t",$time);
		
		
		//###############################################################################
		#50;
		$display("Start of ROL tests");
		Operation = ROL;
		
		InFlags.Carry = 1;
		InSrc = 16'b1001_1010_1010_1010;
		#1 if (OutDest != 16'b0011_0101_0101_0101) $display("Error in ROL operation at time %t",$time);
		if (OutFlags.Carry != 1) $display("Error (flags) in ROL operation at time %t",$time);
		
		#10;
		InFlags.Carry = 0;
		InSrc = 16'b0000_1111_0000_1111;
		#1 if (OutDest != 16'b0001_1110_0001_1110) $display("Error in ROL operation at time %t",$time);
		if (OutFlags.Carry != 0) $display("Error (flags) in ROL operation at time %t",$time);
		
		//###############################################################################
		#50;
		$display("Start of ROR tests");
		Operation = ROR;
		
		InFlags.Carry = 1;
		InSrc = 16'b1001_1010_1010_1010;
		#1 if (OutDest != 16'b1100_1101_0101_0101) $display("Error in ROR operation at time %t",$time);
		if (OutFlags.Carry != 0) $display("Error (flags) in ROR operation at time %t",$time);
		
		#10;
		InFlags.Carry = 0;
		InSrc = 16'b0000_1111_0000_1111;
		#1 if (OutDest != 16'b0000_0111_1000_0111) $display("Error in ROR operation at time %t",$time);
		if (OutFlags.Carry != 1) $display("Error (flags) in ROR operation at time %t",$time);
		
		
		//###############################################################################
		#50;
		$display("Start of LIL tests");
		Operation = LIL;
		
		InDest = 16'h0000;
		InImm = 6'b101100;
		#1 if (OutDest != 16'b1111_1111_1110_1100) $display("Error in LIL operation at time %t",$time);
		
		#10 InImm = 6'b001001;
		#1 if (OutDest != 16'b0000_0000_0000_1001) $display("Error in LIL operation at time %t",$time);
		
		#10;
		InDest = 16'h0FFF;
		InImm = 6'h0F;
		#1 if (OutDest != 16'h000F) $display("Error in LIL operation at time %t",$time);
		
		
		//###############################################################################
		#50; // FIX THESE FLAGS LATER
		$display("Start of SUB tests");
		Operation = SUB;
		
		#10 InFlags.Carry = '0;
		InDest = 16'h0000;
		InSrc = 16'ha5a5;   
	   #1 
		if (OutDest != 16'h5A5B) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(1)) $display("Error (flags) in SUB operation at time %t",$time);
		
		#10 InFlags.Carry = '1;
	   #1 
		if (OutDest != 16'h5A5A) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(9)) $display("Error (flags) in SUB operation at time %t",$time);

		#10 InDest = 16'h5a5a; 
	   #1 
		if (OutDest != 16'hB4B4) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(29)) $display("Error (flags) in SUB operation at time %t",$time);
		
		#10 InDest = 16'h8000;
		InFlags.Carry = '0;
		InSrc = 16'hffff;      
	   #1 
		if (OutDest != 16'h8001) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(13)) $display("Error (flags) in SUB operation at time %t",$time);
		
		#10 InDest = 16'hFFFF;
		InSrc = 16'hFFFF;     
	   #1 
		if (OutDest != 16'h0000) $display("Error in SUB operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in SUB operation at time %t",$time);
		
		
		//###############################################################################
		#50; // FIX THESE LATER
		$display("Start of DIV tests");
		Operation = DIV;
		
		#10;
		InDest = 16'h0000;
		InSrc = 16'ha5a5;   
	   #1 
		if (OutDest != 16'h0000) $display("Error in DIV operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in DIV operation at time %t",$time);
		
		#10;
		InDest = 16'h1FD5;
		InSrc = 16'hFFF8;   
	   #1 
		if (OutDest != 16'hFC06) $display("Error in DIV operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in DIV operation at time %t",$time);
		
		#10;
		InDest = 16'h0008;
		InSrc = 16'h0004;   
	   #1 
		if (OutDest != 16'h0002) $display("Error in DIV operation at time %t",$time);
	   if (OutFlags != sFlags'(0)) $display("Error (flags) in DIV operation at time %t",$time);
		
		#10;
		InDest = 16'hAFFF;
		InSrc = 16'h0001;   
	   #1 
		if (OutDest != 16'hAFFF) $display("Error in DIV operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in DIV operation at time %t",$time);
		
		
		//###############################################################################
		#50; // FIX THESE LATER
		$display("Start of MOD tests");
		Operation = MOD;
		
		#10;
		InDest = 16'h0000;
		InSrc = 16'ha5a5;   
	   #1 
		if (OutDest != 16'h0000) $display("Error in MOD operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in MOD operation at time %t",$time);
		
		#10;
		InDest = 16'h1FD5;
		InSrc = 16'hFFF8;   
	   #1 
		if (OutDest != 16'h0005) $display("Error in MOD operation at time %t",$time);
	   if (OutFlags != sFlags'(8)) $display("Error (flags) in MOD operation at time %t",$time);
		
		#10;
		InDest = 16'h0008;
		InSrc = 16'h0004;   
	   #1 
		if (OutDest != 16'h0000) $display("Error in MOD operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in MOD operation at time %t",$time);
		
		#10;
		InDest = 16'hAFFF;
		InSrc = 16'h0001;   
	   #1 
		if (OutDest != 0) $display("Error in MOD operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in MOD operation at time %t",$time);
		
		
		//###############################################################################
		#50; // FIX THESE LATER
		$display("Start of MUL tests");
		Operation = MUL;
		
		#10;
		InDest = 16'h0000;
		InSrc = 16'ha5a5;   
	   #1 
		if (OutDest != 16'h0000) $display("Error in MUL operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in MUL operation at time %t",$time);
		
		#10;
		InDest = 16'h1FD5;
		InSrc = 16'hFFF8;   
	   #1 
		if (OutDest != 16'h0158) $display("Error in MUL operation at time %t",$time);
	   if (OutFlags != sFlags'(8)) $display("Error (flags) in MUL operation at time %t",$time);
		
		#10;
		InDest = 16'h0008;
		InSrc = 16'h0004;   
	   #1 
		if (OutDest != 16'h0020) $display("Error in MUL operation at time %t",$time);
	   if (OutFlags != sFlags'(0)) $display("Error (flags) in MUL operation at time %t",$time);
		
		#10;
		InDest = 16'hAFFF;
		InSrc = 16'h0001;   
	   #1 
		if (OutDest != 16'hAFFF) $display("Error in MUL operation at time %t",$time);
	   if (OutFlags != sFlags'(12)) $display("Error (flags) in MUL operation at time %t",$time);
		
		
		//###############################################################################
		#50;
		$display("Start of MUH tests");
		Operation = MUH;
		
		#10;
		InDest = 16'h0000;
		InSrc = 16'ha5a5;   
	   #1 
		if (OutDest != 16'h0000) $display("Error in MUH operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in MUH operation at time %t",$time);
		
		#10;
		InDest = 16'h1FD5;
		InSrc = 16'hFFF8;   
	   #1 
		if (OutDest != 16'h0000) $display("Error in MUH operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in MUH operation at time %t",$time);
		
		#10;
		InDest = 16'h0008;
		InSrc = 16'h0004;   
	   #1 
		if (OutDest != 16'h0000) $display("Error in MUH operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in MUH operation at time %t",$time);
		
		#10;
		InDest = 16'hAFFF;
		InSrc = 16'h0001;   
	   #1 
		if (OutDest != 16'h0000) $display("Error in MUH operation at time %t",$time);
	   if (OutFlags != sFlags'(10)) $display("Error (flags) in MUH operation at time %t",$time);
		
		#10;
		InDest = 16'h012C;
		InSrc = 16'h012C;   
	   #1 
		if (OutDest != 16'h0001) $display("Error in MUH operation at time %t",$time);
	   if (OutFlags != sFlags'(0)) $display("Error (flags) in MUH operation at time %t",$time);
		#50;
		// End of instruction simulation

		$display("End of tests");
	end
endmodule 