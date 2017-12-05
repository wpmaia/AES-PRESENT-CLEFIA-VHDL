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
-- Descri��o: contador (counter)
-- Vers�o: 1
                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador is
	port (
		clk, reset, cnt_res : in std_logic;
		round : out std_logic_vector (4 downto 0)
	);
end contador;

architecture Behavioral of contador is
	signal cnt : std_logic_vector(4 downto 0) := (others => '0');
	begin
		contador : process (clk, reset, cnt)
			begin
				if (reset = '1') then
					cnt <= (others => '0');
				elsif (clk'Event and clk = '1') then
					if (cnt_res = '1') then
						cnt <= cnt + 1;
				else
						cnt <= (others => '0');
					end if;
				end if;
			end process contador;
			round <= cnt;
	end Behavioral;
