LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY unidade_de_controle IS
    PORT (
        Clock : IN STD_LOGIC;
        OpCode : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        Jump : OUT STD_LOGIC;
        Branch : OUT STD_LOGIC;
        MemRead : OUT STD_LOGIC;
        MemtoReg : OUT STD_LOGIC;
        ALUOp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        MemWrite : OUT STD_LOGIC;
        ALUSrc : OUT STD_LOGIC;
        RegWrite : OUT STD_LOGIC
    );
END unidade_de_controle;

ARCHITECTURE behavior OF unidade_de_controle IS
BEGIN
    PROCESS (Clock)
    BEGIN
        CASE OpCode IS
			WHEN "0000" => -- sw
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "0101";
                MemWrite <= '1';
                ALUSrc <= '0';
                RegWrite <= '0';
		  
			WHEN "0001" => -- lw
                Jump <= '0';
                Branch <= '0';
                MemRead <= '1';
                MemtoReg <= '1';
                ALUOp <= "0100";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '1';
					 
			WHEN "0010" => -- add
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "0010";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '1';
					 
			WHEN "0011" => -- sub
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "0010";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '1';
					 
			WHEN "0100" => -- mul
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "1011";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '1';  
			
			WHEN "0101" => -- addi
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "0010";
                MemWrite <= '0';
                ALUSrc <= '1';
                RegWrite <= '1';

			WHEN "0110" => -- subi
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "0110";
                MemWrite <= '0';
                ALUSrc <= '1';
                RegWrite <= '1';

			WHEN "0111" => -- move
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "0011";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '1';
					 
			WHEN "1000" => -- beq
                Jump <= '0';
                Branch <= '1';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "1000";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '0';

			WHEN "1001" => -- bne
                Jump <= '0';
                Branch <= '1';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "1001";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '0';
					 
			WHEN "1010" => -- Jump
                Jump <= '1';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "1111";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '0';

			WHEN "1011" => -- li
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "0111";
                MemWrite <= '0';
                ALUSrc <= '1';
                RegWrite <= '1';                      
                      
			WHEN OTHERS =>
                Jump <= '0';
                Branch <= '0';
                MemRead <= '0';
                MemtoReg <= '0';
                ALUOp <= "1111";
                MemWrite <= '0';
                ALUSrc <= '0';
                RegWrite <= '0';
        END CASE;
    END PROCESS;
END behavior;
