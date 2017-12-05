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
-- Descrição: Keyupd (Atualização da chave)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keyupd is
	port(
		key : in std_logic_vector(79 downto 0);
		round : in std_logic_vector(4 downto 0);
		keyout : out std_logic_vector(79 downto 0)
	);
end Keyupd;

architecture Behavioral of Keyupd is

	component sBoxLayer is
		port(
			input : in std_logic_vector(3 downto 0);
			output : out std_logic_vector(3 downto 0)
		);
	end component;

	signal sbox_in   : std_logic_vector(3 downto 0);
	signal sbox_out  : std_logic_vector(3 downto 0);
	signal keytemp : std_logic_vector(79 downto 0);

	begin

		--chave em processo de atualização
		--Permutação dos 19 bits LSB para MSB
		keytemp <= key(18 downto 0) & key(79 downto 19);
		
		--bits que passam pela substituição
		sbox_in <= keytemp(79 downto 76);
		
		-- instanciamento de uma sBoxLayer
		s1: sBoxLayer port map(
		input => sbox_in, 
		output => sbox_out
		);
		
		--Saída da chave atualizada
		keyout(79 downto 76)<= sbox_out;
		keyout(75 downto 20)<= keytemp(75 downto 20);
		keyout(19 downto 15)<= keytemp(19 downto 15) xor round; -- XOR com contador de rodadas
		keyout(14 downto 0) <= keytemp(14 downto 0);
	
	end Behavioral;