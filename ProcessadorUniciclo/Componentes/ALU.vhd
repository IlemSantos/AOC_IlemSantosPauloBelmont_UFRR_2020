LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY ALU IS
    PORT (
        Clock : IN STD_LOGIC;
        ALUOp : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        input_A : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        input_B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        output_Result : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        Zero : OUT STD_LOGIC;
        Overflow : OUT STD_LOGIC
    );
END ALU;

ARCHITECTURE Behavior OF ALU IS

    COMPONENT temp_zero IS
        PORT (
            input_port : IN STD_LOGIC;
			output_port : OUT STD_LOGIC
        );
    END COMPONENT;
	 
    -- Para usar na instrução cmp
    SIGNAL in_temp_zero : STD_LOGIC;
    SIGNAL out_temp_zero : STD_LOGIC;

    -- Usados nas operações de adição e subtração
    SIGNAL result_adder : STD_LOGIC_VECTOR (8 DOWNTO 0);
	SIGNAL temp_overflow_adder : STD_LOGIC;
    SIGNAL result_sub : STD_LOGIC_VECTOR (8 DOWNTO 0);
	SIGNAL temp_overflow_sub : STD_LOGIC;

BEGIN
    port_map_temp_zero : temp_zero PORT MAP(in_temp_zero, out_temp_zero);
    result_adder <= ('0' & input_A) + ('0' & input_B);
    temp_overflow_adder <= result_adder(8) XOR input_A(7) XOR input_B(7) XOR result_adder(7);
	result_sub <= ('0' & input_A) - ('0' & input_B);
	temp_overflow_sub <= result_sub(8) XOR input_A(7) XOR input_B(7) XOR result_sub(7);
    PROCESS (Clock, ALUOp, input_A, input_B)
    BEGIN
        CASE ALUOp IS

            WHEN "000" => -- lw, sw
                output_Result <= input_A;
				Overflow <= '0';

            WHEN "001" => --add, addi
                output_Result <= result_adder (7 DOWNTO 0);
                Overflow <= temp_overflow_adder;

            WHEN "010" => --sub, subi
                output_Result <= result_sub (7 DOWNTO 0);
				Overflow <= temp_overflow_sub;

            WHEN "011" => -- move, li
                output_Result <= input_B;
				Overflow <= '0';
					 
            WHEN "100" => -- beq
                IF out_temp_zero = '1' THEN
                    Zero <= '1';
                ELSE
                    Zero <= '0';
                END IF;
                output_Result <= "00000000";

            WHEN "101" => -- bne
                IF out_temp_zero = '0' THEN
                    Zero <= '1';
                ELSE
                    Zero <= '0';
                END IF;
                output_Result <= "00000000";

            WHEN "110" => -- cmp
                IF input_A = input_B THEN
                    in_temp_zero <= '1';
                ELSE
                    in_temp_zero <= '0';
                END IF;
                output_Result <= "00000000";

            WHEN OTHERS =>
                output_Result <= "00000000";
        END CASE;
    END PROCESS;
END Behavior;