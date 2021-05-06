LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY PC IS
    PORT (
        Clock : IN STD_LOGIC;
        input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END PC;

ARCHITECTURE Behavior OF PC IS
BEGIN
    PROCESS (Clock)
    BEGIN
        IF rising_edge(Clock) THEN
				output_port <= input_port;
--            output_port <= input_port + "00000001";
        END IF;
    END PROCESS;
END Behavior;