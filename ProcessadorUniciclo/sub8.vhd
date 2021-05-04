LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY sub8 IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		Cout : OUT STD_LOGIC;
		SUB : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
   );
END sub8;

ARCHITECTURE Behavior OF sub8 IS

COMPONENT adder8 IS
	PORT (
		A: IN STD_LOGIC_VECTOR (7 downto 0);
		B: IN STD_LOGIC_VECTOR (7 downto 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		Sum : OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

SIGNAl Complemento_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
	Complemento_1 <= "11111111" XOR B;
	ChipSub : adder8 PORT MAP (A, Complemento_1, '1', Cout, SUB);
END Behavior;