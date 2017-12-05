----------------------------------------------------------------------------------
-- Mestrado em Engenharia El�trica (Universidade Federal de Sergipe UFS - Brasil)
-- Disserta��o: Projeto, Implementa��o e Desempenho dos Algoritmos Criptogr�ficos
-- AES, PRESENT e CLEFIA em FPGA
-- Autor: William Pedrosa Maia
-- E-mail: wmaia.eng@gmail.com
-- Prof. Orientador: Edward David Moreno
-- Data: Julho/2017
--
-- Projeto: AES-128                                                                                                                                                                                       
--
-- Descri��o: Multiplexador (128-bit)
-- Vers�o: 1
--                                                                                                                                                      
-- Adaptado de (Palmeira et al., 2014)                                                                                    
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


	entity mux is
	port ( 
		input0 : in  STD_LOGIC_VECTOR(127 downto 0);
		input1 : in  STD_LOGIC_VECTOR(127 downto 0);
		ctrl   : in  STD_LOGIC;
		output : out STD_LOGIC_VECTOR(127 downto 0)
	);
end mux;

architecture Behavioral of mux is

begin
	output <= input0 when (ctrl = '0') else
		input1;
end Behavioral;
