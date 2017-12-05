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
-- Descrição: Registrador
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
	generic(largura : integer := 64);
	port(
		input  : in  STD_LOGIC_VECTOR(largura - 1 downto 0);
		output : out STD_LOGIC_VECTOR(largura - 1 downto 0);
		enable : in  STD_LOGIC;
		clk    : in  STD_LOGIC;
		reset  : in  STD_LOGIC
	);
end Reg;

architecture Behavioral of Reg is

signal reg : STD_LOGIC_VECTOR(largura - 1 downto 0);

begin
	clock : process(clk, reset)
		begin
			if (reset = '1') then
				reg <= (others => '0');
			elsif (clk = '1' and clk'Event) then
				if (enable = '1') then
					reg <= input;
				end if;
			end if;				
		end process clock;
	output <= reg;
end Behavioral;
