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
-- Descrição: shift (Função deslocamento na saída da rede de Feistel)
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

entity shift is
    Port ( shift_in : in STD_LOGIC_VECTOR (127 downto 0);
           shift_out : out STD_LOGIC_VECTOR (127 downto 0));
end shift;

architecture Behavioral of shift is

begin
    -- shift output GF4N (F0 and F1) // not shift last round 
	shift_out (127 downto 32) <= shift_in (95 downto 0);
	shift_out (31 downto 0)   <= shift_in (127 downto 96);
	
end Behavioral;
