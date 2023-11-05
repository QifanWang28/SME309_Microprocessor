	AREA    MYCODE, CODE, READONLY, ALIGN=9 
   	  ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>

	LDR R1, constant1;
	LDR R2, constant2;
	LDR R3, addr1;
	LDR R4, addr2;
	ADD R5, R1, R2; R5 = a1 + a2;
	
	STR R5, [R3,#4];
	ADD R3, R3, #8;
	LDR R5,[R3,#-4]; R5 = a1 + a2;
	
	SUB R6, R1, R2;  R6 = a1 - a2;
	STR R6, [R4,#-4];
	SUB R4, R4, #8;
	LDR R6,[R4,#4];	 R6 = a1 - a2;
	
	AND R3, R1, #0x00000000; R3 = 0
	LDR R10, constant3;
	ORR R4, R1, R10; R4 = 0xFFFFFFFF;
	ORR R1, R1, R4; R1 = 0xFFFFFFFF;
	AND R2, R2, R3; R2 = 0;
	
	AND R7,R1,R1,LSL #16; R7 = 0xFFFF0000;
	AND R8,R1,R1,LSR #16; R8 = 0x0000FFFF;
	AND R7,R1,R7,ASR #8; R7 = 0xFFFFFF00;
	AND R8,R1,R8,ASR #16; R8 = 0;
	
	;LSL R7, R1, #16; R7 = 0xFFFF0000;
	;LSR R8, R1, #16; R8 = 0x0000FFFF;
	;ASR R7, R7, #8; R7 = 0xFFFFFF00;
	;ASR R8, R8, #16; R8 = 0;
	
	
	ADD R9, R8, R5; R9 = a1+a2;
	SUB R10,R7, R6; R10 = FFFFFF00 - 1 = FFFFFEFF;
	SUB R11,R10,R9; 
	SUB R11,R11,R9; R11 = FFFFFF00 - (a1 - a2) - 2*(a1+a2) = FFFFFF00 - 3a1 - a2= FFFFFEF9;
	
	;ROR R11,R11,#16; R16 stores the result R11 = FEF9FFFF;
	
	AND R11,R1,R11,ROR #16; R16 stores the result R11 = FEF9FFFF;
	
	LDR R10, constant4;
	SUB R11,R11,R10; R11 = 6;
	ADD R3, R11,#0; R3 = R11 =6;
	LDR R1, number0;
	LDR R2, number0;
loop1
	SUB R11,R11,#1;
	ADD R1,R1,#1;
	CMP R11,#2;
	BNE loop1;
	
	;R1 = 4;
loop2
	SUB R3,R3,#1;
	ADD R2,R2,#2;
	CMN R3,#-1;
	BNE loop2;
	
	;R2 = 10
	
	ADD R11,R1,R2; R11 = 0x0000000E;
	ORR R11,R11,#0x00000001; R11 = 0x0000 000F;
	AND R11,R11,#0x0000000C; R11 = 0x0000 000C;
	
	LDR R1,constant3;
	AND R11,R1,R11,ROR #4; R11 = 0xC00000000; the resule is in R11;
	
	;ROR R11,R11,#4; R11 = 0xC00000000; the result is in R11;
	
	LDR R1,constant3; R1 = FFFFFFFF
	LDR R2,constant1; R2 = 2
	LDR R3,constant2; R3 = 1
	
	ADD R11,R2,R11,ASR #4; R11 = 0xFC00 0002
	ADD R11,R2,R11,LSR #4; R11 = 0x0FC0 0002
	ADD R11,R2,R11,LSL #4; R11 = 0xFC00 0022
	ADD R11,R2,R11,ROR #4; R11 = 0x2FC0 0004
	
	AND R11,R11,R1,LSR #4; R11 = 0x0FC0 0004
	ORR R11,R3,R11,LSL #4; R11 = 0xFC00 0041
	SUB R11,R1,R11,ROR #16; R11 = 0xFFBE 03FF
	
	LDR R10,addr3;
	STR R11,[R10];MEM[12]=R11
	LDR R9,addr2;
	STR R1,[R9];MEM[8]=R1
	
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
		DCD 0x00000002; 
constant2
		DCD 0x00000001;
constant3 
		DCD 0xFFFFFFFF;
constant4
		DCD 0xFEF9FFF9;
number0
		DCD 0x00000000;




		END	