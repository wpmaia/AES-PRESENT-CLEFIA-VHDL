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
-- Descrição: PRESENT (TOP)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Present_Enc is
	generic (
			w_64: integer := 64;
			w_80: integer := 80
			);
	port(
		clk, reset, start : in std_logic;
		plaintext : in std_logic_vector(63 downto 0); -- texto plano
		key		  : in std_logic_vector(79 downto 0); -- chave
		ciphertext : out std_logic_vector(63 downto 0); -- texto encriptado		
		ready : out std_logic -- pronto		
	);
end Present_Enc;

architecture Behavioral of Present_Enc is

	component Reg is
	generic(largura : integer := w_64);
	port(
		input  : in  STD_LOGIC_VECTOR(largura - 1 downto 0);
		output : out STD_LOGIC_VECTOR(largura - 1 downto 0);
		enable : in  STD_LOGIC;
		clk    : in  STD_LOGIC;
		reset  : in  STD_LOGIC
	);
	end component Reg;

	component mux is
		generic (
		largura : integer := 64
				);
	port ( 
		input0 : in  STD_LOGIC_VECTOR(largura - 1 downto 0);
		input1 : in  STD_LOGIC_VECTOR(largura - 1 downto 0);
		ctrl   : in  STD_LOGIC;
		output : out STD_LOGIC_VECTOR(largura - 1 downto 0)
		);
	end component mux;

	component maqEstados is
		port (			
			clk, reset, start : in std_logic;
			pronto, cnt_res, ctrl_mux, RegEn: out std_logic;
			round : in std_logic_vector (4 downto 0)
		);
	end component;

	-- Camada de substituição
	component sBoxLayer is
		port (
			input : in std_logic_vector(3 downto 0);
			output : out std_logic_vector(3 downto 0)
		);
	end component;

	-- camada de permutação
	component pLayer is
		port(
			input : in std_logic_vector(63 downto 0);
			output : out std_logic_vector(63 downto 0)
		);
	end component;

	-- Atualização da chave (Keyupd)
	component Keyupd is
		port(
			round : in std_logic_vector(4 downto 0);
			key : in std_logic_vector(79 downto 0);			
			keyout : out std_logic_vector(79 downto 0)
		);
	end component;

	-- contador
	component Contador is
		port (
			clk, reset, cnt_res : in std_logic;
			round : out std_logic_vector (4 downto 0)
		);
	end component;
	
	-- sinais
	
	signal keyround : std_logic_vector (4 downto 0);
	signal toXor, ciph, sig_sBoxLayer, sig_pLayer, textToReg : std_logic_vector (63 downto 0);
	signal keyfout, sig_kupd, keyToReg : std_logic_vector (79 downto 0);
	signal ready_sig, mux_ctrl,  cnt_res, RegEn : std_logic;
	
	begin
	    
		-- conexões (essencial)
		
		mux_64: mux generic map(largura => w_64) port map(
			input0 => plaintext, 
			input1 => sig_pLayer, 
			ctrl => mux_ctrl, 
			output => textToReg
		);
		regText : Reg generic map(largura => w_64) port map(
			input  => textToReg,
			output  => toXor, 
			enable  => RegEn, 
			clk  => clk, 
			reset  => reset
		);
		mux_80: mux generic map(largura => w_80) port map(
			input0 => key, 
			input1 => sig_kupd, 
			ctrl => mux_ctrl, 
			output => keyToReg
		);
		regKey : Reg generic map(largura => w_80) port map(
			input  => keyToReg, 
			output  => keyfout, 
			enable  => RegEn, 
			clk  => clk, 
			reset  => reset
		);
		
		sBoxLayers : for N in 15 downto 0 generate 
			s_x: sBoxLayer port map(
				input => ciph(4*N+3 downto 4*N), 
				output => sig_sBoxLayer (4*N+3 downto 4*N)
			);
		end generate sBoxLayers;
		
		p1: pLayer port map(
			input => sig_sBoxLayer, 
			output => sig_pLayer
		);
		
		mixer: keyupd port map(
			key => keyfout, 
			round => keyround, 
			keyout => sig_kupd
		);
				
		SM: maqEstados port map(
			start => start, 
			reset => reset, 
			pronto => ready_sig, 
			cnt_res => cnt_res, 
			ctrl_mux => mux_ctrl,
			clk => clk,
			round => keyround,
			RegEn => RegEn
		);
		
		count: Contador port map( 
			clk => clk, 
			reset => reset, 
			cnt_res => cnt_res, 
			round => keyround
		);
			
		ciph <= toXor XOR keyfout(79 downto 16); -- Texto Cifrado XOR Chave rodada
		
		ciphertext <= ciph; -- texto_encriptado
		ready <= ready_sig; -- pronto

end Behavioral;
	