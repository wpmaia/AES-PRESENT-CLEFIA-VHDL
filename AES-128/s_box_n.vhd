----------------------------------------------------------------------------------
-- Mestrado em Engenharia Elétrica (Universidade Federal de Sergipe UFS - Brasil)
-- Dissertação: Projeto, Implementação e Desempenho dos Algoritmos Criptográficos
-- AES, PRESENT e CLEFIA em FPGA
-- Autor: William Pedrosa Maia
-- E-mail: wmaia.eng@gmail.com
-- Prof. Orientador: Edward David Moreno
-- Data: Julho/2017
--
-- Projeto: AES-128                                                                                                                                                                                       
--
-- Descrição: S-Box para geração de chaves das rodadas (em Key_Shedule)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Palmeira et al., 2014)                                                                                    
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

entity s_box_n is
     Port ( 
		   s_word_in    :	in std_logic_vector (31 downto 0);
		   s_word_out   :	out std_logic_vector (31 downto 0)
		   );
end s_box_n;

architecture Behavioral of s_box_n is

	--COMPONENTS
	COMPONENT s_box 
		PORT(
			 s_in    :	IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			 s_out   :	OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		 );
	END COMPONENT;

begin
	sboxes: FOR i IN 3 DOWNTO 0 GENERATE
		 sbox_map :	s_box
			 PORT MAP(
				 s_in => s_word_in(8*i+7 DOWNTO 8*i),
				 s_out => s_word_out(8*i+7 DOWNTO 8*i)
			 );
	END GENERATE sboxes;

end Behavioral;
