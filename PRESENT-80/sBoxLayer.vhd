----------------------------------------------------------------------------------
-- Mestrado em Engenharia Elétrica (Universidade Federal de Sergipe UFS - Brasil)
-- Dissertação: Projeto, Implementação e Desempenho dos Algoritmos Criptográficos
-- AES, PRESENT e CLEFIA em FPGA
-- Autor: William Pedrosa Maia
-- E-mail: wmaia.eng@gmail.com
-- Prof. Orientador: Edward David Moreno
-- Data: Julho/2017
--
-- Projeto: PRESENT-80                                                                                                                                                                                       
--
-- Descrição: SBoxLayer (Camada de Substituição)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sBoxLayer is
	port (
		input : in std_logic_vector(3 downto 0);
		output : out std_logic_vector(3 downto 0)
	);
end sBoxLayer;

architecture Behavioral of sBoxLayer is

	begin
		output <=    x"C" when input = x"0" else
					 x"5" when input = x"1" else
					 x"6" when input = x"2" else
					 x"B" when input = x"3" else
					 x"9" when input = x"4" else
					 x"0" when input = x"5" else 
					 x"A" when input = x"6" else
					 x"D" when input = x"7" else
					 x"3" when input = x"8" else
					 x"E" when input = x"9" else 
					 x"F" when input = x"A" else
					 x"8" when input = x"B" else 
					 x"4" when input = x"C" else
					 x"7" when input = x"D" else 
					 x"1" when input = x"E" else
					 x"2" when input = x"F" else
					 "ZZZZ";
	end Behavioral;