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
-- Descrição: M1 (Função de multiplicação matricial M1)
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

entity M1 is
    Port ( m1_in : in STD_LOGIC_VECTOR (31 downto 0);
           m1_out : out STD_LOGIC_VECTOR (31 downto 0)
           );
end M1;

architecture Behavioral of M1 is

	signal X0, X1, X2, X3 : std_logic_vector (7 downto 0);
	signal Y0, Y1, Y2, Y3 : std_logic_vector (7 downto 0);
	signal A0, A1 : std_logic_vector (7 downto 0);
	signal B0, B1 : std_logic_vector (7 downto 0);
	signal C0, C1 : std_logic_vector (7 downto 0);
	signal D0, D1 : std_logic_vector (7 downto 0);

	
	--Função multiplicação por x02
	-- F2
	function F2 (xa : std_logic_vector (7 downto 0))
	return std_logic_vector is
	variable ya : std_logic_vector (7 downto 0);
	begin
	ya(0) := xa(7);
	ya(1) := xa(0);
	ya(2) := xa(1) xor xa(7);
	ya(3) := xa(2) xor xa(7);
	ya(4) := xa(3) xor xa(7);
	ya(5) := xa(4);
	ya(6) := xa(5);
	ya(7) := xa(6);
	return ya;
	end;
	
	--Função multiplicação por x08
	-- F8
	function F8 (xb : std_logic_vector (7 downto 0))
	return std_logic_vector is
	variable yb : std_logic_vector (7 downto 0);
	variable z : std_logic;
	begin
	z    := xb(6) xor xb(7);
	yb(0) := xb(5);
	yb(1) := xb(6);
	yb(2) := xb(5) xor xb(7);
	yb(3) := xb(0) xor xb(5) xor xb(6);
	yb(4) := xb(1) xor xb(5) xor z;
	yb(5) := xb(2) xor z;
	yb(6) := xb(3) xor xb(7);
	yb(7) := xb(4);
	return yb;
	end;

begin
			
	--entradas
	X0 <= m1_in (31 downto 24);
	X1 <= m1_in (23 downto 16);
	X2 <= m1_in (15 downto 8);
	X3 <= m1_in (7 downto 0);
	
	--A0 = X0 + X1, A1 = X2 + X3
	A0 <= X0 xor X1;
	A1 <= X2 xor X3;
	
	--B0 = X0 + X2, B1 = X1 + X3
	B0 <= X0 xor X2;
	B1 <= X1 xor X3;
	
	--C0 = {02} x A0, C1 = {02} x A1
	C0 <= F2 (A0);
	C1 <= F2 (A1);
	
	--D0 = {08} x B0, D1 = {08} x B1
	D0 <= F8 (B0);
	D1 <= F8 (B1);
	
	--Y0 = C1 + D1 + X0
	Y0 <= C1 xor D1 xor X0;
	--Y1 = C1 + D0 + X1
	Y1 <= C1 xor D0 xor X1;
	--Y2 = C0 + D1 + X2
	Y2 <= C0 xor D1 xor X2;
	--Y3 = C0 + D0 + X3
	Y3 <= C0 xor D0 xor X3;
	
	m1_out <= Y0 & Y1 & Y2 & Y3;
	
end Behavioral;