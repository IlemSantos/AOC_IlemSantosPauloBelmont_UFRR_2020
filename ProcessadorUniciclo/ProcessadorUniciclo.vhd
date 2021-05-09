LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ProcessadorUniciclo IS
	PORT (
		Clock : IN STD_LOGIC;
    	out_out_pc : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    	out_out_rom : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    	out_opcode : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    	out_rs : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    	out_rt : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    	out_endereco : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    	out_out_br_reg_A : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    	out_out_br_reg_B : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    	out_out_alu_result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    	out_out_overflow : OUT STD_LOGIC;
    	out_out_memoria_ram : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    	out_out_mul_2to1_ram_alu : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END ProcessadorUniciclo;

ARCHITECTURE Behavior OF ProcessadorUniciclo IS
	COMPONENT PC IS
		PORT (
			Clock : IN STD_LOGIC;
        	input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        	output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT CounterPc IS
		PORT (
			Clock : IN STD_LOGIC;
			input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT MemoriaRom IS
		PORT (
			Clock : IN STD_LOGIC;
        	input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        	output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
      );
	END COMPONENT;

	COMPONENT DivisaoInstrucao IS
		PORT (
			input_port : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			output_OpCode : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			output_rs : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			output_rt : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			output_jump : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT UnidadeControle IS
		PORT (
			Clock : IN STD_LOGIC;
			OpCode : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			Jump : OUT STD_LOGIC;
			Branch : OUT STD_LOGIC;
			MemRead : OUT STD_LOGIC;
			MemtoReg : OUT STD_LOGIC;
			ALUOp : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			MemWrite : OUT STD_LOGIC;
			ALUSrc : OUT STD_LOGIC;
			RegWrite : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT BancoRegistradores IS
		PORT (
			Clock : IN STD_LOGIC;
			RegWrite : IN STD_LOGIC;
			ReadReg1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- Endereço do registrador 1
			ReadReg2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- Endereço do registrador 2
			WriteData : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			ReadData1 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			ReadData2 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

    COMPONENT ExtensorSinal2to8 IS
		PORT (
			input_port : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT Mux2to1 IS
		PORT (
			input_port : IN STD_LOGIC;
			input_A : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			input_B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ALU IS
		PORT (
			Clock : IN STD_LOGIC;
			ALUOp : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			input_A : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			input_B : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			output_Result : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			Zero : OUT STD_LOGIC;
			Overflow : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT MemoriaRam IS
		PORT (
			Clock : IN STD_LOGIC;
			MemWrite : IN STD_LOGIC;
			MemRead : IN STD_LOGIC;
			Address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			WriteData : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			ReadData : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ExtensorSinal4to8 IS
		PORT (
			input_port : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT and_gate IS
		PORT (
			input_A : IN STD_LOGIC;
			input_B : IN STD_LOGIC;
			output_port : OUT STD_LOGIC
		);
	END COMPONENT;

--	somador PC 
	SIGNAL out_counter_pc : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	PC
	SIGNAL out_pc : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	rom
	SIGNAL out_rom : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	Divisao da instrucao
	SIGNAL out_di_7_4 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL out_di_3_2 : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL out_di_1_0 : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL out_di_3_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);

--	Unidade de Controle
	SIGNAL out_uc_Jump : STD_LOGIC;
	SIGNAL out_uc_Branch : STD_LOGIC;
	SIGNAL out_uc_MemRead : STD_LOGIC;
	SIGNAL out_uc_MemtoReg : STD_LOGIC;
	SIGNAL out_uc_ALUOp : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL out_uc_MemWrite : STD_LOGIC;
	SIGNAL out_uc_ALUSrc : STD_LOGIC;
	SIGNAL out_uc_RegWrite : STD_LOGIC;

--	Banco de registradores
	SIGNAL out_br_reg_A : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL out_br_reg_B : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	extensor sinal 2 bits para 8 bits
	SIGNAL out_es_2_8 : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	multiplexador 2x1 8 bits, banco registradores e ALU
	SIGNAL out_mul_2to1_br_alu : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	ALU
	SIGNAL out_alu_result : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL out_alu_zero : STD_LOGIC;
	SIGNAL out_overflow : STD_LOGIC;

--	Memoria Ram
	SIGNAL out_memoria_ram : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	multiplexador 2x1 8 bits, ALU e memoria ram
	SIGNAL out_mul_2to1_ram_alu : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	Extensor sinal 4 bits para 8 bits
	SIGNAL out_es_4_8 : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	porta and
	SIGNAL out_and_gate : STD_LOGIC;

--	multiplexador 2x1 8 bits, somador do pc e extensor de sinal 4 bits para 8 bits do jump
	SIGNAL out_mul_2to1_add_pc_jump : STD_LOGIC_VECTOR (7 DOWNTO 0);

--	multiplexador 2x1 8 bits, saida do multiplexador anterior e e extensor de sinal 4 bits para 8 bits do jump
	SIGNAL out_port_map_mul_2to1_jump : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
	port_map_somador_pc : CounterPc PORT MAP(Clock, out_pc, out_counter_pc);

	port_map_pc : PC PORT MAP(Clock, out_port_map_mul_2to1_jump, out_pc);

	port_map_memoria_rom : MemoriaRom PORT MAP(Clock, out_pc, out_rom);

	port_map_divisao_instrucao : DivisaoInstrucao PORT MAP(out_rom, out_di_7_4, out_di_3_2, out_di_1_0, out_di_3_0);

	port_map_unidade_controle : UnidadeControle PORT MAP(Clock, out_di_7_4, out_uc_Jump, out_uc_Branch, out_uc_MemRead, out_uc_MemtoReg, out_uc_ALUOp, out_uc_MemWrite, out_uc_ALUSrc, out_uc_RegWrite);

	port_map_banco_registradores : BancoRegistradores PORT MAP(Clock, out_uc_RegWrite, out_di_3_2, out_di_1_0, out_mul_2to1_ram_alu, out_br_reg_A, out_br_reg_B);

	port_map_extensor_sinal_2_8 : ExtensorSinal2to8 PORT MAP(out_di_1_0, out_es_2_8);

	port_map_mul_2to1_br_alu : Mux2to1 PORT MAP(out_uc_ALUSrc, out_br_reg_B, out_es_2_8, out_mul_2to1_br_alu);

	port_map_alu : ALU PORT MAP(Clock, out_uc_ALUOp, out_br_reg_A, out_mul_2to1_br_alu, out_alu_result, out_alu_zero, out_overflow);

	port_map_memoria_ram : MemoriaRam PORT MAP(Clock, out_uc_MemWrite, out_uc_MemRead, out_es_2_8, out_alu_result, out_memoria_ram);

	port_map_mul_2to1_ram_alu : Mux2to1 PORT MAP(out_uc_MemtoReg, out_alu_result, out_memoria_ram, out_mul_2to1_ram_alu);

	port_map_extensor_sinal_4_8 : ExtensorSinal4to8 PORT MAP(out_di_3_0, out_es_4_8);

	port_map_and_gate : and_gate PORT MAP(out_uc_Branch, out_alu_zero, out_and_gate);

	port_map_mul_2to1_add_pc_jump : Mux2to1 PORT MAP(out_and_gate, out_counter_pc, out_es_4_8, out_mul_2to1_add_pc_jump);

	port_map_mul_2to1_jump : Mux2to1 PORT MAP(out_uc_Jump, out_mul_2to1_add_pc_jump, out_es_4_8, out_port_map_mul_2to1_jump);

--	Resultados Saidas
	out_out_pc <= out_pc;
	out_out_rom <= out_rom;
	out_opcode <= out_di_7_4;
	out_rs <= out_di_3_2;
	out_rt <= out_di_1_0;
	out_endereco <= out_di_3_0;
	out_out_br_reg_A <= out_br_reg_A;
	out_out_br_reg_B <= out_br_reg_B;
	out_out_alu_result <= out_alu_result;
	out_out_overflow <= out_overflow;
	out_out_memoria_ram <= out_memoria_ram;
	out_out_mul_2to1_ram_alu <= out_mul_2to1_ram_alu;
END Behavior;