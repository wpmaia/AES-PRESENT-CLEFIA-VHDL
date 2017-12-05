----------------------------------------------------------------------------------
-- Mestrado em Engenharia Elétrica (Universidade Federal de Sergipe UFS - Brasil)
-- Dissertação: Projeto, Implementação e Desempenho dos Algoritmos Criptográficos
-- AES, PRESENT e CLEFIA em FPGA
-- Autor: William Pedrosa Maia
-- E-mail: wmaia.eng@gmail.com
-- Prof. Orientador: Edward David Moreno
-- Data: Julho/2017
--
-- Projeto: PRESENT-80                                                                                                                                                                                       
--
-- Descrição: pLayer (Camada de Permutação)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pLayer is
	port (
		input : in std_logic_vector(63 downto 0);
		output : out std_logic_vector(63 downto 0)
	);
end pLayer;

architecture Behavioral of pLayer is
begin
			output(0) <= input(0);
			output(16) <= input(1);
			output(32) <= input(2);
			output(48) <= input(3);
			output(1) <= input(4);
			output(17) <= input(5);
			output(33) <= input(6);
			output(49) <= input(7);
			output(2) <= input(8);
			output(18) <= input(9);
			output(34) <= input(10);
			output(50) <= input(11);
			output(3) <= input(12);
			output(19) <= input(13);
			output(35) <= input(14);
			output(51) <= input(15);
			output(4) <= input(16);
			output(20) <= input(17);
			output(36) <= input(18);
			output(52) <= input(19);
			output(5) <= input(20);
			output(21) <= input(21);
			output(37) <= input(22);
			output(53) <= input(23);
			output(6) <= input(24);
			output(22) <= input(25);
			output(38) <= input(26);
			output(54) <= input(27);
			output(7) <= input(28);
			output(23) <= input(29);
			output(39) <= input(30);
			output(55) <= input(31);
			output(8) <= input(32);
			output(24) <= input(33);
			output(40) <= input(34);
			output(56) <= input(35);
			output(9) <= input(36);
			output(25) <= input(37);
			output(41) <= input(38);
			output(57) <= input(39);
			output(10) <= input(40);
			output(26) <= input(41);
			output(42) <= input(42);
			output(58) <= input(43);
			output(11) <= input(44);
			output(27) <= input(45);
			output(43) <= input(46);
			output(59) <= input(47);
			output(12) <= input(48);
			output(28) <= input(49);
			output(44) <= input(50);
			output(60) <= input(51);
			output(13) <= input(52);
			output(29) <= input(53);
			output(45) <= input(54);
			output(61) <= input(55);
			output(14) <= input(56);
			output(30) <= input(57);
			output(46) <= input(58);
			output(62) <= input(59);
			output(15) <= input(60);
			output(31) <= input(61);
			output(47) <= input(62);
			output(63) <= input(63);
end Behavioral;
