LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MemoriaRam IS
    PORT (
        Clock : IN STD_LOGIC;
        MemWrite : IN STD_LOGIC;
        MemRead : IN STD_LOGIC;
        Address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        WriteData : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        ReadData : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END MemoriaRam;

ARCHITECTURE behavior OF MemoriaRam IS
    TYPE DataMemory IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL Memoria_Ram : DataMemory := (OTHERS => "00000000");
BEGIN
    PROCESS (Clock)
    BEGIN
        IF rising_edge(Clock) THEN
            IF (MemWrite = '1') THEN
                Memoria_Ram(to_integer(unsigned(Address))) <= WriteData;
            END IF;
        END IF;
		  ReadData <= "00000000";
        IF (MemRead = '1') THEN
            ReadData <= Memoria_Ram(to_integer(unsigned(Address)));
        END IF;
    END PROCESS;
END behavior;