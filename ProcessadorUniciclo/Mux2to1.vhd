-- Mux2to1
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux2to1 IS
	PORT (
		D0, D1, S0 : IN std_logic;
		O 	: OUT std_logic
	);
END Mux2to1;

ARCHITECTURE Behavior OF Mux2to1 IS
BEGIN
	PROCESS (D0, D1, S0) IS
   BEGIN
		IF S0 = '0' then O <= D0;
		ELSE O <= D1;
		END IF;
   END PROCESS;
END Behavior;
