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
-- Descrição: T_key (Módulo que realiza as operações XOR entre K, L e Const)
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

entity T_key is
    Port ( sel_KLC : in STD_LOGIC;
    	   sel_KL : in STD_LOGIC;
    	   K_in   : in STD_LOGIC_VECTOR (127 downto 0);
           L_in   : in STD_LOGIC_VECTOR (127 downto 0);
           C_in   : in STD_LOGIC_VECTOR (63 downto 0);
           WK     : out STD_LOGIC_VECTOR (63 downto 0);
           RK     : out STD_LOGIC_VECTOR (63 downto 0)
           );
end T_key;

architecture Behavioral of T_key is

signal sig_K, sig_L : std_logic_vector (63 downto 0) := (others => '0');
signal sig_rk : std_logic_vector (63 downto 0) := (others => '0');

begin

	-- mux Key for T (XORing L,K,C)
	WITH sel_KL SELECT
		 sig_K <= K_in (127 downto 64) WHEN '0',
				  K_in (63 downto 0) WHEN OTHERS;
	
	-- mux L for T (XORing L,K,C)
	WITH sel_KL SELECT
	  	 sig_L <= L_in (127 downto 64) WHEN '0',
				  L_in (63 downto 0) WHEN OTHERS;
	
	-- mux T (L xor C or L xor K xor C)
	WITH sel_KLC SELECT
	   	 sig_rk <= sig_L xor C_in WHEN '0',
	        	   sig_L xor sig_K xor C_in WHEN OTHERS;
	
	RK <= sig_rk;
	WK <= sig_K;
	
	end Behavioral;
