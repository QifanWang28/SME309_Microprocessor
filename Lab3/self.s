	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>

	LDR R1, constant1;
	LDR R2, constant2;
	LDR R3, addr1;
	LDR R4, addr2;
	ADD R5, R1, R2; R5 = a1 + a2 = 4;
	
	MUL R5, R1, R5; R5 = R5*R1 = 12
	MUL R5, R1, R5; R5 = R5*R1 = 48
	
	
halt	
	B    halt
	
; ------- <code memory (ROM mapped to Instruction Memory) begins>
	
	
	
	

; ------- <code memory (ROM mapped to DATA Memory) begins>
	AREA    CONSTANTS, DATA, READONLY, ALIGN=9 


addr1
		DCD 0x00000810;
addr2 	
		DCD 0x00000820;
addr3
		DCD 0x00000830;
constant1
		DCD 0x00000003; 
constant2
		DCD 0x00000001;
constant3 
		DCD 0xFFFFFFFF;
constant4
		DCD 0xFFFFFEFA;
number0
		DCD 0x00000000;




		END	