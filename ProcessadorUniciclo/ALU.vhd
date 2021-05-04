LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

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

ARCHITECTURE behavior OF ALU IS

-- Somador de 8 bits
COMPONENT adder8 IS
	PORT (
		A: IN STD_LOGIC_VECTOR (7 downto 0);
		B: IN STD_LOGIC_VECTOR (7 downto 0);
		Cin : IN STD_LOGIC;
		Cout : OUT STD_LOGIC;
		Sum : OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

-- Subtrator de 8bits
COMPONENT sub8 IS
	PORT (
		A : IN STD_LOGIC_VECTOR (7 downto 0);
		B : IN STD_LOGIC_VECTOR (7 downto 0);
		Cout : OUT STD_LOGIC;
		Sub : OUT STD_LOGIC_VECTOR (7 downto 0)
	);
END COMPONENT;

-- portas lógicas
COMPONENT and_gate is
    PORT (
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        S  : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT not_gate is
    PORT (
        A : IN STD_LOGIC;
        S  : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT or_gate is
    PORT (
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        S  : OUT STD_LOGIC
    );
END COMPONENT;

COMPONENT xor_gate is
    PORT (
        A : IN STD_LOGIC;
        B : IN STD_LOGIC;
        S  : OUT STD_LOGIC
    );
END COMPONENT;

-- Para usar na instrução (1010) if para o beq e bne
    SIGNAL in_temp_zero : std_logic;
    SIGNAL out_temp_zero : std_logic;

-- Usado no resultado da multiplicação
    SIGNAL out_multi : std_logic_vector(15 DOWNTO 0);

--Usados nas operações de adição e subtração
	SIGNAL result_adder : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL result_sub : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL tempCoutAdder : STD_LOGIC;
	SIGNAL tempCoutSub : STD_LOGIC;

BEGIN

	 ChipSomador : adder8 PORT MAP(A, B, '0', tempCoutAdder, result_adder);
    ChipSubtrator : sub8 PORT MAP(A, B, tempCoutSub, result_sub);

	PROCESS(Clock)
	BEGIN
		CASE ALUOp IS
			WHEN "0101" => -- sw
				Result <= A;
				
			WHEN "0100" => -- lw
				Result <= A;
				
			WHEN "0010" => -- add
				Result <= result_adder;
				CarryOut <= tempCoutAdder;
			
			WHEN "0110" => -- sub
				Result <= result_sub;
				
			WHEN "1011" => -- mul
				Result <= result_sub;
			 
			WHEN "0011" => -- move
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
END behavior;
