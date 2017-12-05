----------------------------------------------------------------------------------
-- Mestrado em Engenharia El�trica (Universidade Federal de Sergipe UFS - Brasil)
-- Disserta��o: Projeto, Implementa��o e Desempenho dos Algoritmos Criptogr�ficos
-- AES, PRESENT e CLEFIA em FPGA
-- Autor: William Pedrosa Maia
-- E-mail: wmaia.eng@gmail.com
-- Prof. Orientador: Edward David Moreno
-- Data: Julho/2017
--
-- Projeto: CLEFIA-128                                                                                                                                                                                       
--
-- Descri��o: mux3_1 (Multiplexador 3 x 1)
-- Vers�o: 1
                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux3_1 is
	port ( 
		input0 : in  STD_LOGIC_VECTOR(127 downto 0);
		input1 : in  STD_LOGIC_VECTOR(127 downto 0);
		input2 : in  STD_LOGIC_VECTOR(127 downto 0);
		ctrl   : in  STD_LOGIC_VECTOR (1 downto 0);
		output : out STD_LOGIC_VECTOR(127 downto 0)
	);
end mux3_1;


	
architecture Behavioral of mux3_1 is
	
	signal sig_out : std_logic_vector (127 downto 0);
begin
	sig_out <= input0 when (ctrl = "01") else
		      input1 when (ctrl = "10") else
		      input2 when (ctrl = "00") else
		      (others => '0');

	output <= sig_out;
			      
end Behavioral;

