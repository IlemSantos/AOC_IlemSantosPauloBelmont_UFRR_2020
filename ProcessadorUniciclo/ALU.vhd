LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU IS
    PORT (
		Clock	: IN STD_LOGIC;
		ALUOp : IN STD_LOGIC_VECTOR (3 downto 0);
		A : IN STD_LOGIC_VECTOR (7 downto 0);
		B : IN STD_LOGIC_VECTOR (7 downto 0);
		Result : OUT STD_LOGIC_VECTOR (7 downto 0);
		Zero : OUT STD_LOGIC;
		CarryOut : OUT STD_LOGIC -- overflow
    );
END ALU;

ARCHITECTURE Behavior OF ALU IS

SIGNAl ResultAdder : STD_LOGIC_VECTOR (8 DOWNTO 0);

BEGIN

	PROCESS(Clock)
	BEGIN
		CASE ALUOp IS
			WHEN "0101" => -- sw
				Result <= A;
				
			WHEN "0100" => -- lw
				Result <= A;
				
			WHEN "0010" => -- add
				ResultAdder <= ('0' & A) + ('0' & B);
				Result <= ResultAdder (7 DOWNTO 0);
				CarryOut <= ResultAdder(8);
			
			WHEN "0110" => -- sub
				Result <= A - B;
				
--			WHEN "1011" => -- mul
--				Result <= result_sub;
			 
			WHEN "0011" => -- move
				Result <= B;
				
			WHEN "0111" => -- li
				Result <= B;
				
			WHEN "1000" => -- beq
				IF A = B THEN
					Zero <= '1';
            ELSE
					Zero <= '0';
            END IF;
            Result <= "00000000";
			
			WHEN "1001" => -- bne
				IF A /= B THEN
					Zero <= '1';
            ELSE
					Zero <= '0';
            END IF;
            Result <= "00000000";
			
			WHEN OTHERS =>
				Result <= "00000000";
		END CASE;
	END PROCESS;
END Behavior;