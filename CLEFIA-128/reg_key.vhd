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
-- Descrição: reg_key (Registrador da Chave)
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

entity reg_key is
    Port ( clk     : in STD_LOGIC;
           reset   : in STD_LOGIC;
    	   enable  : in STD_LOGIC;
    	   key_in  : in STD_LOGIC_VECTOR (127 downto 0);
           key_out : out STD_LOGIC_VECTOR (127 downto 0)
           );
end reg_key;

architecture Behavioral of reg_key is

signal reg_key : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');

begin
	clock : process(clk, reset, enable)
		begin
			if (reset = '1') then
				reg_key <= (others => '0');
			elsif (clk = '1' and clk'Event) then
				if (enable = '1') then
					reg_key <= key_in;
				end if;
			end if;				
		end process clock;
	
	key_out <= reg_key;

	
end Behavioral;