LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY CounterPc IS
    PORT (
        Clock : IN STD_LOGIC;
        input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END CounterPc;

ARCHITECTURE Behavior OF CounterPc IS
BEGIN
    PROCESS (Clock)
    BEGIN
        output_port <= input_port + "00000001";
    END PROCESS;
END Behavior;