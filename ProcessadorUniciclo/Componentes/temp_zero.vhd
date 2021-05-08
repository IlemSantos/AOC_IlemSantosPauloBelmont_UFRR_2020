LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY temp_zero IS
    PORT (
        input_port : IN STD_LOGIC;
        output_port : OUT STD_LOGIC
    );
END temp_zero;

ARCHITECTURE Behavior OF temp_zero IS
BEGIN
    output_port <= input_port;
END Behavior;