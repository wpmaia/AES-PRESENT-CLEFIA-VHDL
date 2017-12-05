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
-- Descrição: reg_kL (Registrador para a chave intermediária L)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Sony Corporation, 2010)                                                                                    
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

entity reg_kL is
    Port ( clk    : in STD_LOGIC;
           reset  : in STD_LOGIC;
    	   enable : in STD_LOGIC;
    	   kL_in  : in STD_LOGIC_VECTOR (127 downto 0);
           kL_out : out STD_LOGIC_VECTOR (127 downto 0)
           );
end reg_kL;

architecture Behavioral of reg_kL is

signal reg_kL : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');

begin
	clock : process(clk, reset, enable)
		begin
			if (reset = '1') then
				reg_kL <= (others => '0');
			elsif (clk = '1' and clk'Event) then
				if (enable = '1') then
					reg_kL <= kL_in;
				end if;
			end if;				
		end process clock;
	
	kL_out <= reg_kL;
	
end Behavioral;