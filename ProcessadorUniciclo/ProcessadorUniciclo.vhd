LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ProcessadorUniciclo IS
    PORT (
        Clock : IN STD_LOGIC;
        --teste : IN STD_LOGIC_VECTOR (7 DOWNTO 0); -- usado teste inserir dados
        out_out_pc : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        --out_in_pc : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        --out_in_rom : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        out_out_rom : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        out_opcode : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        out_rs : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        out_rt : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        out_endereco : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        out_out_br_reg_A : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        out_out_br_reg_B : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        out_out_ula_result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_out_overflow : OUT STD_LOGIC;
        out_out_MemoriaRam : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_out_mul_2X1_ram_ula : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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
            output_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
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
            ALUOp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            MemWrite : OUT STD_LOGIC;
            ALUSrc : OUT STD_LOGIC;
            RegWrite : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT BancoRegistradores IS
        PORT (
            Clock : IN STD_LOGIC;
				RegWrite : IN STD_LOGIC;
				ReadReg1 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
				ReadReg2 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
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
            S0 : IN STD_LOGIC;
				D0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				D1 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				O : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ALU IS
        PORT (
            Clock	: IN STD_LOGIC;
				ALUOp : IN STD_LOGIC_VECTOR (3 downto 0);
				A : IN STD_LOGIC_VECTOR (7 downto 0);
				B : IN STD_LOGIC_VECTOR (7 downto 0);
				Result : OUT STD_LOGIC_VECTOR (7 downto 0);
				Zero : OUT STD_LOGIC;
				CarryOut : OUT STD_LOGIC -- overflow
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

    -- Counter PC 
    SIGNAL out_CounterPc : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- PC
    SIGNAL out_pc : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- rom
    SIGNAL out_rom : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- divisao instrucao
    SIGNAL out_di_7_4 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL out_di_3_2 : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL out_di_1_0 : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL out_di_3_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);

    -- unidade de controle
    SIGNAL out_uc_jump : STD_LOGIC;
    SIGNAL out_uc_branch : STD_LOGIC;
    SIGNAL out_uc_mem_read : STD_LOGIC;
    SIGNAL out_uc_mem_to_reg : STD_LOGIC;
    SIGNAL out_uc_ula_op : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL out_uc_mem_write : STD_LOGIC;
    SIGNAL out_uc_ula_src : STD_LOGIC;
    SIGNAL out_uc_reg_write : STD_LOGIC;

    -- banco de registradores
    SIGNAL out_br_reg_A : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL out_br_reg_B : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- extensor sinal 2 bits para 8 bits
    SIGNAL out_es_2_8 : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- multiplexador 2X1 8 bits, banco registradores e ALU
    SIGNAL out_mul_2X1_br_ula : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- ALU
    SIGNAL out_ula_result : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL out_ula_zero : STD_LOGIC;
    SIGNAL out_overflow : STD_LOGIC;

    -- memoria ram
    SIGNAL out_MemoriaRam : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- multiplexador 2X1 8 bits, ALU e memoria ram
    SIGNAL out_mul_2X1_ram_ula : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- extensor sinal 4 bits para 8 bits
    SIGNAL out_es_4_8 : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- porta and
    SIGNAL out_and_gate : STD_LOGIC;

    -- multiplexador 2X1 8 bits, somador do PC e extensor de sinal 4 bits para 8 bits do jump
    SIGNAL out_mul_2X1_add_pc_jump : STD_LOGIC_VECTOR (7 DOWNTO 0);

    -- multiplexador 2X1 8 bits, saida do multiplexador anterior e e extensor de sinal 4 bits para 8 bits do jump
    SIGNAL out_port_map_mul_2X1_jump : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
    port_map_CounterPc : CounterPc PORT MAP(Clock, out_pc, out_CounterPc);

    port_map_pc : PC PORT MAP(Clock, out_port_map_mul_2X1_jump, out_pc);

    port_map_MemoriaRom : MemoriaRom PORT MAP(Clock, out_pc, out_rom);

    port_map_DivisaoInstrucao : DivisaoInstrucao PORT MAP(out_rom, out_di_7_4, out_di_3_2, out_di_1_0, out_di_3_0);

    port_map_UnidadeControle : UnidadeControle PORT MAP(Clock, out_di_7_4, out_uc_jump, out_uc_branch, out_uc_mem_read, out_uc_mem_to_reg, out_uc_ula_op, out_uc_mem_write, out_uc_ula_src, out_uc_reg_write);

    port_map_BancoRegistradores : BancoRegistradores PORT MAP(Clock, out_uc_reg_write, out_di_3_2, out_di_1_0, out_mul_2X1_ram_ula, out_br_reg_A, out_br_reg_B);

    port_map_ExtensorSinal2to8 : ExtensorSinal2to8 PORT MAP(out_di_1_0, out_es_2_8);

    port_map_mul_2X1_br_ula : Mux2to1 PORT MAP(out_uc_ula_src, out_br_reg_B, out_es_2_8, out_mul_2X1_br_ula);

    port_map_ula : ALU PORT MAP(Clock, out_uc_ula_op, out_br_reg_A, out_mul_2X1_br_ula, out_ula_result, out_ula_zero, out_overflow);

    port_map_MemoriaRam : MemoriaRam PORT MAP(Clock, out_uc_mem_write, out_uc_mem_read, out_es_2_8, out_ula_result, out_MemoriaRam);

    port_map_mul_2X1_ram_ula : Mux2to1 PORT MAP(out_uc_mem_to_reg, out_ula_result, out_MemoriaRam, out_mul_2X1_ram_ula);

    port_map_ExtensorSinal4to8 : ExtensorSinal4to8 PORT MAP(out_di_3_0, out_es_4_8);

    port_map_and_gate : and_gate PORT MAP(out_uc_branch, out_ula_zero, out_and_gate);

    port_map_mul_2X1_add_pc_jump : Mux2to1 PORT MAP(out_and_gate, out_CounterPc, out_es_4_8, out_mul_2X1_add_pc_jump);

    port_map_mul_2X1_jump : Mux2to1 PORT MAP(out_uc_jump, out_mul_2X1_add_pc_jump, out_es_4_8, out_port_map_mul_2X1_jump);

    -- Resultados Saidas
    out_out_pc <= out_pc;
    out_out_rom <= out_rom;
    out_opcode <= out_di_7_4;
    out_rs <= out_di_3_2;
    out_rt <= out_di_1_0;
    out_endereco <= out_di_3_0;
    out_out_br_reg_A <= out_br_reg_A;
    out_out_br_reg_B <= out_br_reg_B;
    out_out_ula_result <= out_ula_result;
    out_out_overflow <= out_overflow;
    out_out_MemoriaRam <= out_MemoriaRam;
    out_out_mul_2X1_ram_ula <= out_mul_2X1_ram_ula;
END Behavior;
