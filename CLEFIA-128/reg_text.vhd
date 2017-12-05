----------------------------------------------------------------------------------
-- Mestrado em Engenharia Elétrica (Universidade Federal de Sergipe UFS - Brasil)
-- Dissertação: Projeto, Implementação e Desempenho dos Algoritmos Criptográficos
-- AES, PRESENT e CLEFIA em FPGA
-- Autor: William Pedrosa Maia
-- E-mail: wmaia.eng@gmail.com
-- Prof. Orientador: Edward David Moreno
-- Data: Julho/2017
--
-- Projeto: CLEFIA-128                                                                                                                                                                                       
--
-- Descrição: reg_text (Registrador do Texto)
-- Versão: 1
                                                                                   
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

entity reg_text is
    Port ( clk     : in STD_LOGIC;
           reset   : in STD_LOGIC;
    	   enable  : in STD_LOGIC;
    	   text_in  : in STD_LOGIC_VECTOR (127 downto 0);
           text_out : out STD_LOGIC_VECTOR (127 downto 0)
           );
end reg_text;

architecture Behavioral of reg_text is

signal sig_reg_text : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');

begin
	clock : process(clk, reset, enable)
		begin
			if (reset = '1') then
				sig_reg_text <= (others => '0');
			elsif (clk = '1' and clk'Event) then
				if (enable = '1') then
					sig_reg_text <= text_in;
				end if;
			end if;				
		end process clock;
	
	text_out <= sig_reg_text;
	
end Behavioral;
