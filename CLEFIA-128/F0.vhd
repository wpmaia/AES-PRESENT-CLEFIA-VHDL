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
-- Descri��o: F0 (Top Fun��o F0)
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

entity F0 is
    Port ( r_key : in STD_LOGIC_VECTOR (31 downto 0);
           f0_in : in STD_LOGIC_VECTOR (31 downto 0);
           f0_out : out STD_LOGIC_VECTOR (31 downto 0));
end F0;

architecture Behavioral of F0 is

	component S0 is
			port (
				s0_in : in STD_LOGIC_VECTOR (7 downto 0);
			    s0_out : out STD_LOGIC_VECTOR (7 downto 0)
			      );
	end component S0;
	
	component S1 is
			port (
				s1_in : in STD_LOGIC_VECTOR (7 downto 0);
			    s1_out : out STD_LOGIC_VECTOR (7 downto 0)
			      );
	end component S1;

	component M0 is
			port (
				m0_in : in STD_LOGIC_VECTOR (31 downto 0);
			    m0_out : out STD_LOGIC_VECTOR (31 downto 0)
			      );
	end component M0;

	signal x0,x1,x2,x3 : std_logic_vector (7 downto 0);
	signal k0,k1,k2,k3 : std_logic_vector (7 downto 0);
	signal y0,y1,y2,y3 : std_logic_vector (7 downto 0);
	signal sb0_in, sb0_out : std_logic_vector (15 downto 0);
	signal sb1_in, sb1_out : std_logic_vector (15 downto 0);
	signal sig_m0_in : std_logic_vector (31 downto 0);
	
begin
	x0 <= f0_in (31 downto 24);
	x1 <= f0_in (23 downto 16);
	x2 <= f0_in (15 downto 8);
	x3 <= f0_in (7 downto 0);

	k0 <= r_key (31 downto 24);
	k1 <= r_key (23 downto 16);
	k2 <= r_key (15 downto 8);
	k3 <= r_key (7 downto 0);
	
	--Add round key
	sb0_in <= (x0 xor k0) & (x2 xor k2);
	sb1_in <= (x1 xor k1) & (x3 xor k3);
	
	-- 2 instancias de S0 e conex�es
	s0_Boxs : for N in 1 downto 0 generate 
		s0_x: S0 port map(
			s0_in => sb0_in(8*N+7 downto 8*N), 
			s0_out => sb0_out (8*N+7 downto 8*N)
			);
		end generate s0_Boxs;

	-- 2 instancias de S1 e conex�es
	s1_Boxs : for N in 1 downto 0 generate 
		s1_x: S1 port map(
			s1_in => sb1_in(8*N+7 downto 8*N), 
			s1_out => sb1_out (8*N+7 downto 8*N)
			);
		end generate s1_Boxs;
	
	--entrada de M0
	sig_m0_in <= sb0_out (15 downto 8) & 
				 sb1_out (15 downto 8) & 
				 sb0_out (7 downto 0)  & 
				 sb1_out (7 downto 0);
				 	
	-- conex�es de M0
	m_0 : M0 port map(
			m0_in => sig_m0_in, 
			m0_out => f0_out
		);
end Behavioral;
