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
-- Descrição: Multiplexador
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux is
	generic (
		largura : integer := 64 -- widht (largura)
	);
	port ( 
		input0 : in  STD_LOGIC_VECTOR(largura - 1 downto 0);
		input1 : in  STD_LOGIC_VECTOR(largura - 1 downto 0);
		ctrl   : in  STD_LOGIC;
		output : out STD_LOGIC_VECTOR(largura - 1 downto 0)
	);
end mux;

architecture Behavioral of mux is

begin
	output <= input0 when (ctrl = '0') else
		input1;
end Behavioral;
