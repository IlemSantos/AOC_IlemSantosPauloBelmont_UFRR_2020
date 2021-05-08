LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux2to1 IS
    PORT (
        input_port : IN STD_LOGIC;
        input_A : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        input_B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END Mux2to1;

ARCHITECTURE Behavior OF Mux2to1 IS
BEGIN
    PROCESS (input_port, input_A, input_B)
    BEGIN
        CASE input_port IS
            WHEN '0' => output_port <= input_A;
            WHEN '1' => output_port <= input_B;
        END CASE;
    END PROCESS;
END Behavior;