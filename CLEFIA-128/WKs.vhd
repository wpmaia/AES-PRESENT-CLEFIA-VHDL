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
-- Descrição: WKs (Clareamento de chave WK0, WK1, WK2, WK3)
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

entity WKs is
    Port ( wk_in : in STD_LOGIC_VECTOR (127 downto 0);
           wk_out : out STD_LOGIC_VECTOR (127 downto 0);
           keys_w : in STD_LOGIC_VECTOR (63 downto 0)
           );
end WKs;

architecture Behavioral of WKs is

	
begin
	
	-- p1 xor wk0,2
	wk_out (95 downto 64) <= wk_in (95 downto 64) xor keys_w (63 downto 32);
	-- p3 xor wk1,3
	wk_out (31 downto 0)  <= wk_in (31 downto 0) xor keys_w (31 downto 0);
	--output p0 and p2 not WK
	wk_out (127 downto 96) <= wk_in (127 downto 96);
	wk_out (63 downto 32)  <= wk_in (63 downto 32);
	
end Behavioral;
