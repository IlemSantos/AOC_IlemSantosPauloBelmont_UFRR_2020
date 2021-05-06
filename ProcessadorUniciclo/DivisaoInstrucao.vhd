LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DivisaoInstrucao IS PORT (
    input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    output_OpCode : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    output_rs : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    output_rt : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    output_jump : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
);
END DivisaoInstrucao;

ARCHITECTURE Behavior OF DivisaoInstrucao IS
BEGIN
    output_OpCode <= input_port (7 DOWNTO 4);
    output_rs <= input_port (3 DOWNTO 2);
    output_rt <= input_port (1 DOWNTO 0);
    output_jump <= input_port (3 DOWNTO 0);

END Behavior;