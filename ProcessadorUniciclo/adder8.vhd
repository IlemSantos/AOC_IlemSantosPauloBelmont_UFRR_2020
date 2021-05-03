LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY adder8 IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		Cin: IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		SUM : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
   );
END adder8;

ARCHITECTURE Behavior OF adder8 IS

SIGNAl ChipSum : STD_LOGIC_VECTOR (8 DOWNTO 0);

BEGIN
	ChipSum <= ('0' & A) + ('0' & B)  + ("00000000" & Cin);
	Cout <= ChipSum(8);
	SUM <= ChipSum(7 DOWNTO 0);
END Behavior;