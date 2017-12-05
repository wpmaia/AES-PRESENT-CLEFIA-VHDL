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
-- Descrição: ShiftRow (operações de permutação de bytes)
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

entity shift_row is
    Port ( sr_in : in STD_LOGIC_VECTOR (127 downto 0);
           sr_out : out STD_LOGIC_VECTOR (127 downto 0));
end shift_row;

architecture Behavioral of shift_row is

SUBTYPE MIN_B is STD_LOGIC_VECTOR (7 downto 0);
TYPE MATRIX   is ARRAY (15 downto 0) of MIN_B;
SIGNAL box_columns, columns_out: MATRIX;


BEGIN
	vector_to_matrix: -- converte o vetor em matriz
		
		PROCESS(sr_in)
		BEGIN
			FOR i IN 15 DOWNTO 0 LOOP
				box_columns(15-i) <= sr_in(8*i+7 DOWNTO 8*i);
			END LOOP;
		END PROCESS vector_to_matrix;
	
	--Deslocamento de linhas do AES (shift rows)
	--Matriz de entrada--       --Matriz de saída --
	----------------------    -----------------------          
	-- 0    4    8   12 --    --  0    4    8   12 -- 
	-- 1    5    9   13 --    --  5    9   13    1 --
	-- 2    6   10   14 --    -- 10   14    2    6 --
	-- 3    7   11   15 --    -- 15    3    7   11 --
	----------------------    -----------------------
    
    -- Colunas
    
    -- 1
	columns_out(0)  <=  box_columns(0);
	columns_out(1)  <=  box_columns(5);
	columns_out(2)  <=  box_columns(10);
	columns_out(3)  <=  box_columns(15);
	-- 2
	columns_out(4)  <=  box_columns(4);
	columns_out(5)  <=  box_columns(9);
	columns_out(6)  <=  box_columns(14);
	columns_out(7)  <=  box_columns(3);
	-- 3
	columns_out(8)  <=  box_columns(8);
	columns_out(9)  <=  box_columns(13);
	columns_out(10) <=  box_columns(2);
	columns_out(11) <=  box_columns(7);
	-- 4
	columns_out(12) <=  box_columns(12);
	columns_out(13) <=  box_columns(1);
	columns_out(14) <=  box_columns(6);
	columns_out(15) <=  box_columns(11);

	matrix_to_vector: -- converte a matriz em vetor
		
		PROCESS(columns_out)
		BEGIN
			FOR i IN 15 DOWNTO 0 LOOP
				sr_out(8*i+7 DOWNTO 8*i) <= columns_out(15-i);
			END LOOP;
		END PROCESS matrix_to_vector;

end Behavioral;
