LIBRARY ieee;
USE ieee.std_logic_1164.all;

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
        END IF;
    END PROCESS;
END Behavior;