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
-- Descrição: key_shedule (Geração das chaves das rodadas)	
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

entity key_shedule is
    Port ( clk  	    : in STD_LOGIC;
    	   reset 	    : in STD_LOGIC;
    	   K_in         : in STD_LOGIC_VECTOR (127 downto 0);
           L_in         : in STD_LOGIC_VECTOR (127 downto 0);
           en_regL      : in STD_LOGIC;
           en_constant  : in STD_LOGIC;
           sel_T        : in STD_LOGIC;
           sel_muxKL    : in STD_LOGIC;
           sel_muxRK    : in STD_LOGIC;
           sel_muxL     : in STD_LOGIC;
           L_out        : out STD_LOGIC_VECTOR (127 downto 0);
           WK    	    : out STD_LOGIC_VECTOR (63 downto 0);
           RK    	    : out STD_LOGIC_VECTOR (63 downto 0)
           );
end key_shedule;

architecture Behavioral of key_shedule is

	component const is
		Port (
			clk     : in std_logic;
		 	reset   : in std_logic;
		 	enable  : in std_logic;
		 	const_l : out std_logic_vector (63 downto 0)
			);
	end component const;
	
	component reg_kL is
		Port (
			clk    : in STD_LOGIC;
		    reset  : in STD_LOGIC;
		    enable : in STD_LOGIC;
		    kL_in  : in STD_LOGIC_VECTOR (127 downto 0);
		    kL_out : out STD_LOGIC_VECTOR (127 downto 0)
			);
	end component reg_kL;
	
	component double_swap is
		Port (
			ds_in  : in STD_LOGIC_VECTOR (127 downto 0);
		    ds_out : out STD_LOGIC_VECTOR (127 downto 0)
			);
	end component double_swap;
	
	component T_key is
		Port (
		    sel_KLC : in STD_LOGIC;
		    sel_KL : in STD_LOGIC;
		    K_in   : in STD_LOGIC_VECTOR (127 downto 0);
		    L_in   : in STD_LOGIC_VECTOR (127 downto 0);
		    C_in   : in STD_LOGIC_VECTOR (63 downto 0);
		    WK     : out STD_LOGIC_VECTOR (63 downto 0);
		    RK     : out STD_LOGIC_VECTOR (63 downto 0)
			);
	end component T_key;
	
	--sinais
	signal sig_L_in, sig_L_out : std_logic_vector (127 downto 0);
	signal sig_DS_out : std_logic_vector (127 downto 0);
	signal sig_const_out : std_logic_vector (63 downto 0);
	signal sig_T_out : std_logic_vector (63 downto 0);
	
begin
	
	constant_K : const port map (
			clk     => clk,
		 	reset   => reset,
		 	enable  => en_constant,
		 	const_l => sig_const_out
			);

	reg_L : reg_kL	port map (
			clk    => clk,
		    reset  => reset,
		    enable => en_regL,
		    kL_in  => sig_L_in,
		    kL_out => sig_L_out
			);
	
	D_W : double_swap port map (
			ds_in  => sig_L_out,
		    ds_out => sig_DS_out
			);
	
	T_RK : T_key port map (
			sel_KLC => sel_T,
			sel_KL => sel_muxKL,
			K_in   => K_in,
			L_in   => sig_L_out,
			C_in   => sig_const_out,
			WK     => WK,
			RK     => sig_T_out
			);
			

	-- mux RK (até rodada 12 RK <= constante, até rodada 30 RK <= T);
	WITH sel_muxRK SELECT
	  	 RK <= sig_const_out WHEN '0',
	 		   sig_T_out WHEN OTHERS; 				  

	-- mux L (recebe L_in enquanto gera L, depois <= Double Swap)
	WITH sel_muxL SELECT
	  	 sig_L_in <= L_in WHEN '0',
	 		         sig_DS_out WHEN OTHERS; 				  

 L_out <= sig_L_out;
 		
end Behavioral;
