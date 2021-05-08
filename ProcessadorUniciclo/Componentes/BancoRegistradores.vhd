LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY BancoRegistradores IS
    PORT (
        Clock : IN STD_LOGIC;
        RegWrite : IN STD_LOGIC;
        ReadReg1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- Endereço do registrador 1
        ReadReg2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- Endereço do registrador 2
        WriteData : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        ReadData1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        ReadData2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END BancoRegistradores;

ARCHITECTURE Behavior OF BancoRegistradores IS

    TYPE BankofRegistrars IS ARRAY(0 TO 3) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL Registrars : BankofRegistrars;

BEGIN
    PROCESS (Clock)
    BEGIN
        IF rising_edge(Clock) THEN
            IF (RegWrite = '1') THEN
                Registrars(to_integer(unsigned(ReadReg1))) <= WriteData;
            END IF;
        END IF;
        ReadData1 <= Registrars(to_integer(unsigned(ReadReg1)));
        ReadData2 <= Registrars(to_integer(unsigned(ReadReg2)));
    END PROCESS;
END Behavior;