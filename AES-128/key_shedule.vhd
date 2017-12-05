----------------------------------------------------------------------------------
-- Mestrado em Engenharia Elétrica (Universidade Federal de Sergipe UFS - Brasil)
-- Dissertação: Projeto, Implementação e Desempenho dos Algoritmos Criptográficos
-- AES, PRESENT e CLEFIA em FPGA
-- Autor: William Pedrosa Maia
-- E-mail: wmaia.eng@gmail.com
-- Prof. Orientador: Edward David Moreno
-- Data: Julho/2017
--
-- Projeto: AES-128                                                                                                                                                                                       
--
-- Descrição: Key_Shedule (Geração das chaves das rodadas -  RoundKeys)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Palmeira et al., 2014)                                                                                    
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_shedule is
    Port ( clk    : in STD_LOGIC;
    	   reset   : in STD_LOGIC;
    	   en_rcon : in STD_LOGIC;
    	   key_in : in STD_LOGIC_VECTOR (127 downto 0);
           key_out : out STD_LOGIC_VECTOR (127 downto 0)
           );
end key_shedule;

architecture Behavioral of key_shedule is

COMPONENT s_box_n IS
	PORT(
		 s_word_in    :	in std_logic_vector (31 downto 0);
		 s_word_out   :	out std_logic_vector (31 downto 0)
		 );
END COMPONENT;

COMPONENT const_rcon IS
	PORT(
 	 	clk     : in std_logic;
		reset   : in std_logic;
		enable  : in std_logic;
		const_rcon : out std_logic_vector (7 downto 0)
		 );
END COMPONENT const_rcon;

	--SIGNALS, TYPES and SUBTYPES	
	SUBTYPE KEYBOX is std_logic_vector (31 downto 0);
	TYPE KEYMATRIX is ARRAY (15 downto 0) of std_logic_vector (31 downto 0);
	SIGNAL key_word, next_key_word : KEYMATRIX;
	SIGNAL T : KEYBOX;
	SIGNAL upperbyte_trans : std_logic_vector (7 downto 0);
	SIGNAL temp_shift, temp_sbox : std_logic_vector (31 downto 0);
	SIGNAL rcon : std_logic_vector (7 downto 0);
	
begin
	
	--constantes
	RC : const_rcon port map (
		clk        => clk,
		reset      => reset,
		enable     => en_rcon,
		const_rcon => rcon
		);

	--chave original dividida em quatro words
	key_word(0) <= key_in (127 downto 96);
	key_word(1) <= key_in (95 downto 64);
	key_word(2) <= key_in (63 downto 32);
	key_word(3) <= key_in (31 downto 0);
	
	--RotWord - deslocamento a esquerda dos bytes (Key_Word 3)
	temp_shift <= key_word(3)(23 downto 16) &
				  key_word(3)(15 downto 8) &
				  key_word(3)(7 downto 0) &
				  key_word(3)(31 downto 24);
	
	--passando pela S-Box (4 bytes)
	sbox_lookup: s_box_n PORT MAP(s_word_in => temp_shift, s_word_out => temp_sbox);
	
	--calculando RCON (Variável T)
	upperbyte_trans <= temp_sbox (31 downto 24) XOR rcon;
	
	--vetor T calculado
	T <= upperbyte_trans & temp_sbox (23 downto 0);
	
	--(XORing) calculando as próximas Key Words (formam a chave da rodada)
	next_key_word(0) <= key_word(0) XOR T;
	next_key_word(1) <= key_word(1) XOR key_word(0) XOR T;
	next_key_word(2) <= key_word(2) XOR key_word(1) XOR key_word(0) XOR T;
	next_key_word(3) <= key_word(3) XOR key_word(2) XOR key_word(1) XOR key_word(0) XOR T;
	
	--converting Words em vetor de 128 bits
    key_out <= next_key_word(0) & next_key_word(1) & next_key_word(2) & next_key_word(3);
		
end Behavioral;
