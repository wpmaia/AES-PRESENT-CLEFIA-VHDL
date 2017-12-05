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
-- Descri��o: double_swap (fun��o de permuta��o)
-- Vers�o: 1
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

entity double_swap is
    Port ( ds_in  : in STD_LOGIC_VECTOR (127 downto 0);
           ds_out : out STD_LOGIC_VECTOR (127 downto 0));
end double_swap;

architecture Behavioral of double_swap is

begin
	ds_out (127 downto 71) <= ds_in (120 downto 64);
	ds_out (70 downto 64) <= ds_in (6 downto 0);
	ds_out (63 downto 57) <= ds_in (127 downto 121);
	ds_out (56 downto 0) <= ds_in (63 downto 7);
			
end Behavioral;
