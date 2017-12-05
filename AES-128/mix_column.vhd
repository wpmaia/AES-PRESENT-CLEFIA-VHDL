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
-- Descrição: MixColumns (operações multiplicação matricial)
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

entity mix_column is
    Port ( m_in : in STD_LOGIC_VECTOR (127 downto 0);
           m_out : out STD_LOGIC_VECTOR (127 downto 0));
end mix_column;

architecture Behavioral of mix_column is
    
    
    SUBTYPE HALF_B is STD_LOGIC_VECTOR (8 downto 0);
    TYPE SHIFT is ARRAY (15 downto 0) of HALF_B;
    SIGNAL shifted_2, shifted_3, xored : SHIFT; --auxiliares de processos
	-- shifted_2: auxiliar da multiplicação por 2 em GF(2^8)
	-- shifted_3: auxiliar da multiplicação por 3 em GF(2^8)
	-- xored: auxiliar 2 da multiplicação por 3
	SUBTYPE MIN_B is STD_LOGIC_VECTOR (7 downto 0);
	TYPE MATRIX is ARRAY (15 downto 0) of MIN_B;
	SIGNAL  c_in, c_out, mult_2, mult_3 : MATRIX; --resultados de processos
	-- c_in: matriz obtida da entrada
	-- c_out: matriz após operações, a ser vetorizada para a saída
	-- mult_2: matriz obtida da multiplicação por 2
	-- mult_3: matriz obtida da multiplicação por 3

begin

-- converte um vetor simples numa matriz:
	vector_to_matrix:
		PROCESS(m_in)
		BEGIN
			FOR i IN 15 DOWNTO 0 LOOP
				c_in(15-i) <= m_in(8*i+7 DOWNTO 8*i);
			END LOOP;
		END PROCESS vector_to_matrix;
	
	--multiplicação por 2 (shift_left(X))
	mul_2: 
		PROCESS(c_in, shifted_2)
		BEGIN
			FOR i IN  15 DOWNTO 0 LOOP
				shifted_2(i) <= c_in(i) & '0';	-- 2*X
				IF (shifted_2(i)(8)='1') THEN -- overflow
					 mult_2(i) <= shifted_2(i)(7 downto 0) XOR "00011011"; -- deduction mod X^8+X^4+X^3+X^1+X^0
				ELSE
					 mult_2(i) <= shifted_2(i)(7 downto 0);
				END IF;
			END LOOP;
		END PROCESS mul_2;
	
	--multiplicação por 3 (shift_left(X) xor X)
	mul_3: 
		PROCESS(c_in, shifted_3, xored)
		BEGIN
			FOR i IN  15 DOWNTO 0 LOOP
				shifted_3(i) <= c_in(i) & '0';	    -- 2*X
				xored(i) <= shifted_3(i) XOR '0' & c_in(i);  -- (2*X) xor Z
				IF (xored(i)(8)='1') THEN	-- overflow
					 mult_3(i) <= xored(i)(7 downto 0) XOR "00011011";
				ELSE
					 mult_3(i) <= xored(i)(7 downto 0);
				END IF;
			END LOOP;
		END PROCESS mul_3;
	
		--Multiplicação de Colunas do AES (Mix Columns)
        --Matriz de entrada--        --Matriz de Multiplicação --
        ------ c_in ---------        ------- mult ----------
        ----------------------       -----------------------          
        -- |0|    4    8   12 --       -- |2|  |3|   |1|  |1| -- 
        -- |1|    5    9   13 --       --  1    2     3    1 --
        -- |2|    6   10   14 --   x   --  1    1    2   3 --
        -- |3|    7   11   15 --       --  3    1    1   2 --
        ----------------------       -----------------------
	
	--Matriz de Saída c_out--
	--linha 1--
	c_out(0)  <= mult_2(0) XOR mult_3(1) XOR c_in(2) XOR c_in(3);
	c_out(4)  <= mult_2(4) XOR mult_3(5) XOR c_in(6) XOR c_in(7);
	c_out(8)  <= mult_2(8) XOR mult_3(9) XOR c_in(10) XOR c_in(11);
	c_out(12) <= mult_2(12) XOR mult_3(13) XOR c_in (14) XOR c_in(15);
	--linha 2--
	c_out(1)  <= c_in(0) XOR mult_2(1) XOR mult_3(2) XOR c_in(3); 
	c_out(5)  <= c_in(4) XOR mult_2(5) XOR mult_3(6) XOR c_in(7); 
	c_out(9)  <= c_in(8) XOR mult_2(9) XOR mult_3(10) XOR c_in(11); 
	c_out(13) <= c_in(12) XOR mult_2(13) XOR mult_3(14) XOR c_in(15); 
	--linha 3--
	c_out(2)  <= c_in(0) XOR c_in(1) XOR mult_2(2) XOR mult_3(3);
	c_out(6)  <= c_in(4) XOR c_in(5) XOR mult_2(6) XOR mult_3(7);
	c_out(10) <= c_in(8) XOR c_in(9) XOR mult_2(10) XOR mult_3(11);
	c_out(14) <= c_in(12) XOR c_in(13) XOR mult_2(14) XOR mult_3(15);
	--linha 4--
	c_out(3)  <= mult_3(0) XOR c_in(1) XOR c_in(2) XOR mult_2(3);
	c_out(7)  <= mult_3(4) XOR c_in(5) XOR c_in(6) XOR mult_2(7);
	c_out(11) <= mult_3(8) XOR c_in(9) XOR c_in(10) XOR mult_2(11);
	c_out(15) <= mult_3(12) XOR c_in(13) XOR c_in(14) XOR mult_2(15);
	
	matrix_to_vector: -- converte a matriz no vetor de saída
		PROCESS(c_out)
		BEGIN
			FOR i IN 15 DOWNTO 0 LOOP
				m_out(8*i+7 DOWNTO 8*i) <= c_out(15-i);
			END LOOP;
		END PROCESS matrix_to_vector;

end Behavioral;
