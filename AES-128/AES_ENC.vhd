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
-- Descrição: AES_ENC (TOP)
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

entity AES_ENC is
    Port ( 
           clk   : in STD_LOGIC;
           reset : in STD_LOGIC; 
           start : in STD_LOGIC;
    	   plaintext : in STD_LOGIC_VECTOR (127 downto 0); --texto_plano
           key : in STD_LOGIC_VECTOR (127 downto 0); -- chave
           ciphertext : out STD_LOGIC_VECTOR (127 downto 0); --texto_encriptado
		   --round_count : out STD_LOGIC_VECTOR (3 downto 0); -- contador de rodadas
           ready : out STD_LOGIC); -- pronto
end AES_ENC;

architecture Behavioral of AES_ENC is
	
	--componentes
	component Reg is
		port(
			 r_in : in STD_LOGIC_VECTOR (127 downto 0);
		     r_out : out STD_LOGIC_VECTOR (127 downto 0);
		     clk : in STD_LOGIC;
		     reset : in STD_LOGIC;
		     enable : in STD_LOGIC
			 );
		end component Reg;

	component mux is
	port ( 
		  input0 : in  STD_LOGIC_VECTOR(127 downto 0);
		  input1 : in  STD_LOGIC_VECTOR(127 downto 0);
		  ctrl   : in  STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(127 downto 0)
	     );
	end component mux;

	component AES_MaqEst is
		port (			
				clk, reset, start : in std_logic;
				round : std_logic_vector (3 downto 0);
				ready, ctrl_mux, reg_enable, sel_mux : out std_logic
			  );	
	end component;

	component s_box is
		port (
		 	  s_in    :	in std_logic_vector (7 downto 0);
			  s_out   :	out std_logic_vector (7 downto 0)
		      );
	end component;

	component shift_row is
		port (
		 	  sr_in : in STD_LOGIC_VECTOR (127 downto 0);
		      sr_out : out STD_LOGIC_VECTOR (127 downto 0)
		      );
	end component;

	component mix_column is
		port (
		 	  m_in : in STD_LOGIC_VECTOR (127 downto 0);
		      m_out : out STD_LOGIC_VECTOR (127 downto 0)
		      );
	end component;

	component key_shedule is
		port (
			  clk    : in STD_LOGIC;
		   	  reset   : in STD_LOGIC;
			  en_rcon : in STD_LOGIC;
			  key_in : in STD_LOGIC_VECTOR (127 downto 0);
		      key_out : out STD_LOGIC_VECTOR (127 downto 0)
		      );
	end component;

	component contador is
		port ( 
			clk   : in std_logic;
			reset : in std_logic;
			cnt_res : in std_logic;
			round : out std_logic_vector (3 downto 0)
			);
	end component contador;
		
	-- sinais
	signal toXor, ciph, Pout, textToReg : std_logic_vector (127 downto 0);
	signal keyfout, key_expansion, keyToReg : std_logic_vector (127 downto 0);
	signal ready_sig, mux_ctrl, sig_enable : std_logic;
	signal sig_sbox, sig_shiftrow, sig_mixcolumns : std_logic_vector (127 downto 0);
	signal sel : std_logic;
	signal sig_round : std_logic_vector (3 downto 0);
	
begin

	-- conexões
		
		mux_reg : mux port map(
			input0 => plaintext, 
			input1 => Pout, 
			ctrl => mux_ctrl, 
			output => textToReg
		);
		
		regText : Reg port map(
			r_in  => textToReg,
			r_out  => toXor, 
			enable  => sig_enable, 
			clk  => clk, 
			reset  => reset
		);
		
		mux_key : mux port map(
			input0 => key, 
			input1 => key_expansion, 
			ctrl => mux_ctrl, 
			output => keyToReg
		);
		regKey : Reg port map(
			r_in  => keyToReg, 
			r_out  => keyfout, 
			enable  => sig_enable, 
			clk  => clk, 
			reset  => reset
		);
		
		s_boxes: for N in 15 downto 0 generate 
			s_x: s_box port map(
				s_in => ciph(8*N+7 downto 8*N), 
				s_out => sig_sbox (8*N+7 downto 8*N)
			);
		end generate s_boxes;
		
		shift : shift_row port map(
			sr_in => sig_sbox, 
			sr_out => sig_shiftrow
		);
		
		mix_C : mix_column port map(
			m_in => sig_shiftrow, 
			m_out => sig_mixcolumns 
		);
		
		--round10 não se executa mix_column (mix_in = saída do shift_row)
		WITH sel SELECT
				Pout <= sig_mixcolumns WHEN '0',
						sig_shiftrow WHEN OTHERS;	
		
		SM: AES_MaqEst port map(
			clk => clk,
			reset => reset, 
			start => start, 
			ready => ready_sig, 
			round => sig_round,
			ctrl_mux => mux_ctrl,
			reg_enable => sig_enable,
			sel_mux => sel
		);
		
		key_S : key_shedule port map(
			clk   => clk,
			reset => reset,
			en_rcon => sig_enable,
			key_in => keyfout, 
			key_out => key_expansion
		);		
		
		RD : contador port map(
			clk => clk,
			reset => reset, 
			cnt_res => sig_enable,
			round => sig_round
		);		
		
		--operação AddRoudKey
		ciph <= toXor XOR keyfout; -- Texto XOR Chave rodada
		
		-- saída texto cifrado
		ciphertext <= ciph;
		ready <= ready_sig; -- pronto
		--round_count <= sig_round; -- contador de rodadas
		
end Behavioral;
