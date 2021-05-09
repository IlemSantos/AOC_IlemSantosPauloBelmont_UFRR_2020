LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY MemoriaRom IS
	PORT (
		Clock : IN STD_LOGIC;
		input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END MemoriaRom;

ARCHITECTURE Behavior OF MemoriaRom IS
	TYPE InstructionMemory IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
	CONSTANT Memoria_Rom : InstructionMemory := (

--	Teste addi, add, subi, li e jump
	0 => "01000010", -- addi S0 2 -- S0 == 2
	1 => "01000111", -- addi S1 3 -- S1 == 3
	2 => "00100001", -- add S0 S1 -- S0 == 5
	3 => "01000011", -- addi S0 3 -- S0 == 8
	4 => "01010010", -- subi S0 2 -- S0 == 6
	5 => "01110000", -- li S0 0
	6 => "01110100", -- li S1 0
	7 => "10110000", -- jump 0000
	OTHERS => "00000000");

----	Teste sw e lw
--	0 => "01000011", -- addi S0 3 -- S0 == 3
--	1 => "00010000", -- sw S0 ram(00)
--	2 => "01000110", -- addi S1 2 -- S1 == 2
--	3 => "00010101", -- sw S1 ram(01)
--	4 => "01110000", -- li S0 0
--	5 => "01110100", -- li S1 0
--	6 => "00000000", -- lw S0 ram(00)
--	7 => "00000101", -- lw S1 ram(01)
--	8 => "00100001", -- add S0 S1 -- S0 == 5
--	9 => "01110000", -- li S0 0
--	10 => "01110100", -- li S1 0
--	11 => "10110000", -- jump 0000
--	OTHERS => "00000000");

----	Teste move
--	0 => "01110011", -- li S0 3
--	1 => "01110110", -- li S1 2
--	2 => "01101000", -- move S2 S0
--	3 => "01101101", -- move S3 S1
--	4 => "00101011", -- add S2 S3
--	5 => "01100010", -- move S0 S2
--	6 => "01010001", -- subi S0 1
--	7 => "01110000", -- li S0 0
--	8 => "01110100", -- li S1 0
--	9 => "10110000", -- jump 0000
--	OTHERS => "00000000");

----	Teste beq
--	0 => "01110010", -- li S0 2
--	1 => "01110110", -- li S1 2
--	2 => "10100001", -- cmp S0, S1
--	3 => "10000110", -- beq S0 == S1 jump 0110
--	4 => "01000011", -- addi S0 3
--	5 => "01000011", -- addi S0 3
--	6 => "00100001", -- add S0 S1
--	7 => "01110000", -- li S0 0
--	8 => "01110100", -- li S1 0
--	9 => "10110000", -- jump 0000
--	OTHERS => "00000000");

----	Teste bne
--	0 => "01110010", -- li S0 2
--	1 => "01110111", -- li S1 3
--	2 => "10100001", -- cmp S0, S1
--	3 => "10010110", -- bne S0 != S1 jump 0110
--	4 => "01000011", -- addi S0 3
--	5 => "01000011", -- addi S0 3
--	6 => "00100001", -- add S0 S1
--	7 => "01110000", -- li S0 0
--	8 => "01110100", -- li S1 0
--	9 => "10110000", -- jump 0000
--	OTHERS => "00000000");

----	Teste do overflow, números positivos 
--	0 => "01110011", -- li S0 3
--	1 => "00100000", -- add S0 S0 -- S0 = 6
--	2 => "00100000", -- add S0 S0 -- S0 = 12
--	3 => "00100000", -- add S0 S0 -- S0 = 24
--	4 => "00100100", -- add S1 S0 -- S1 = 24
--	5 => "00100000", -- add S0 S0 -- S0 = 48
--	6 => "00100000", -- add S0 S0 -- S0 = 96
--	7 => "00100001", -- add S0 S1 -- S0 = 120
--	8 => "01000011", -- addi S0 3 -- S0 = 123
--	9 => "01000011", -- addi S0 3 -- S0 = 126
--	10 => "01000001", -- addi S0 1 -- S0 = 127
--	11 => "01000001", -- addi S0 1 -- S0 = 128 Overflow
--	12 => "01110100", -- li S1 0
--	13 => "10110000", -- jump 0000
--	OTHERS => "00000000");

----	Teste do overflow, números negativos
--	0 => "01110011", -- li S0 3
--	1 => "00100000", -- add S0 S0 -- S0 = 6
--	2 => "00100000", -- add S0 S0 -- S0 = 12
--	3 => "00100000", -- add S0 S0 -- S0 = 24
--	4 => "00100100", -- add S1 S0 -- S1 = 24
--	5 => "00100000", -- add S0 S0 -- S0 = 48
--	6 => "00100000", -- add S0 S0 -- S0 = 96
--	7 => "00100001", -- add S0 S1 -- S0 = 120
--	8 => "01000011", -- addi S0 3 -- S0 = 123
--	9 => "01000011", -- addi S0 3 -- S0 = 126
--	10 => "01000001", -- addi S0 1 -- S0 = 127
--	11 => "00111000", -- sub S2 S1 -- S2 == -127
--	12 => "01011001", -- subi S2 1 -- S2 == -128
--	13 => "01011001", -- subi S2 1 -- S2 == -129 Overflow
--	14 => "01110100", -- li S1 0
--	15 => "01111000", -- li S2 0
--	16 => "10110000", -- jump 0000
--	OTHERS => "00000000");

----	Teste subtrair números negativos
--	0 => "01111111", -- li S3 3
--	1 => "01111001", -- li S2 1
--	2 => "00111011", -- sub S2 S3 -- S2 == -2
--	3 => "01110101", -- li S1 1
--	4 => "00110111", -- sub S1 S3 -- S1 == -2
--	5 => "00110110", -- sub S1 S2 -- S1 == 0
--	6 => "00110111", -- sub S1 S3 -- S1 == -3
--	7 => "00111001", -- sub S2 S1 -- S2 == 1
--	8 => "00111011", -- sub S2 S3 -- S2 == -2
--	9 => "00100110", -- add S1 S2 -- S1 == -5
--	10 => "01000101", -- addi S1 1 -- S1 == -4
--	OTHERS => "00000000");

BEGIN
	PROCESS (Clock)
	BEGIN
		output_port <= Memoria_Rom(conv_integer(unsigned(input_port)));
	END PROCESS;
END Behavior;