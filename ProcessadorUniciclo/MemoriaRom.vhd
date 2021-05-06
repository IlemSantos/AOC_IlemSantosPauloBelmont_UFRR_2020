LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.ALL;

ENTITY MemoriaRom IS
    PORT (
        Clock : IN STD_LOGIC;
        input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END MemoriaRom;

ARCHITECTURE Behavior OF MemoriaRom IS
    TYPE InstructionMemory IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
    CONSTANT Memoria_Rom : InstructionMemory := (

    -- load immediate 1011
    0 => "10110010", -- li $s0, 0 -- $s0 == 0
    1 => "10110101", -- li $s1, 1 -- $s1 == 1
    2 => "10110010", -- li $s0, 2 -- $s2 == 2
    3 => "10110011", -- li $s0, 3 -- $s3 == 3

    OTHERS => "00000000");

BEGIN
    PROCESS (Clock)
    BEGIN
        output_port <= Memoria_Rom(conv_integer(unsigned(input_port)));
    END PROCESS;
END Behavior;
