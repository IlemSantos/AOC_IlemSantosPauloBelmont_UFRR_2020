LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ExtensorSinal2to8 IS
    PORT (
        input_port : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END ExtensorSinal2to8;

ARCHITECTURE Behavior OF ExtensorSinal2to8 IS
BEGIN
    PROCESS (input_port)
    BEGIN
        output_port <= ("000000") & input_port;
    END PROCESS;
END Behavior;