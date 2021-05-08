LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY and_gate IS
    PORT (
        input_A : IN STD_LOGIC;
        input_B : IN STD_LOGIC;
        output_port : OUT STD_LOGIC
    );
END and_gate;

ARCHITECTURE Behavior OF and_gate IS
BEGIN
    output_port <= input_A AND input_B;
END Behavior;