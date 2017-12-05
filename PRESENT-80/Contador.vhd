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
-- Descrição: Contador
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Contador is
	generic (
		w_5 : integer := 5
	);
	port (
		clk, reset, cnt_res : in std_logic;
		round : out std_logic_vector (w_5-1 downto 0)
	);
end Contador;

architecture Behavioral of Contador is
	signal cnt : std_logic_vector(w_5-1 downto 0) := (others => '0');
	begin
		contador : process (clk, reset, cnt)
			begin
				if (reset = '1') then
					cnt <= (others => '0');
				elsif (clk'Event and clk = '1') then
					if (cnt_res = '1') then
						cnt <= cnt + 1;
					end if;
				end if;
			end process contador;
			round <= cnt;
	end Behavioral;
