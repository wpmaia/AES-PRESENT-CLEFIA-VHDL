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
-- Descrição: CLEFIA_ENC (TOP CLEFIA Encriptação)
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

entity CLEFIA_ENC is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           plaintext : in STD_LOGIC_VECTOR (127 downto 0); --texto_plano
           key : in STD_LOGIC_VECTOR (127 downto 0);
           ciphertext : out STD_LOGIC_VECTOR (127 downto 0); -- texto_cifrado
           --round_count :  out STD_LOGIC_VECTOR (4 downto 0); -- contador de rodadas
           ready : out STD_LOGIC -- pronto
           );
end CLEFIA_ENC;

architecture Behavioral of CLEFIA_ENC is

	component key_shedule is
    	Port (
			clk  	   : in STD_LOGIC;
    	    reset 	   : in STD_LOGIC;
    	    K_in      : in STD_LOGIC_VECTOR (127 downto 0);
    	    L_in        : in STD_LOGIC_VECTOR (127 downto 0);
    	    en_regL     : in STD_LOGIC;
    	    en_constant : in STD_LOGIC;
    	    sel_T       : in STD_LOGIC;
    	    sel_muxKL   : in STD_LOGIC;
    	    sel_muxRK   : in STD_LOGIC;
    	    sel_muxL  : in STD_LOGIC;
    	    L_out     : out STD_LOGIC_VECTOR (127 downto 0);
    	    WK    	   : out STD_LOGIC_VECTOR (63 downto 0);
    	    RK    	   : out STD_LOGIC_VECTOR (63 downto 0)
           );
	end component key_shedule;
	
	component GF4N is
	    Port (     	
	    	clk			: in STD_LOGIC;
	    	reset	    : in STD_LOGIC;
	    	enable      : in STD_LOGIC;
	    	P 		   : in STD_LOGIC_VECTOR (127 downto 0);
	        round_key   : in STD_LOGIC_VECTOR (63 downto 0);
	        w_key	   : in STD_LOGIC_VECTOR (63 downto 0);
	        sel_mux_gf_wk : in STD_LOGIC;
	        sel_mux_shift : in STD_LOGIC;
	        sel_mux_out : in STD_LOGIC;
	        C           : out STD_LOGIC_VECTOR (127 downto 0)
	        );
	end component GF4N;
	
	component contador is
		Port (
			clk, reset, cnt_res : in std_logic;
			round : out std_logic_vector (4 downto 0)
		);
	end component contador;

	component SM_CLEFIA is
    	Port ( 
    		clk   	: in STD_LOGIC;
    	    reset 	: in STD_LOGIC;
    	    round 	: in STD_LOGIC_VECTOR (4 downto 0);
    	    start 	: in STD_LOGIC;
            --control TOP
            en_TXT   : out STD_LOGIC;
            en_count : out STD_LOGIC;
            sel_P    : out STD_LOGIC_VECTOR (1 downto 0);
            ready    : out STD_LOGIC;
            --control GF4N
            sel_GF_WK : out STD_LOGIC;
            sel_shift : out STD_LOGIC;
            sel_OUT  : out STD_LOGIC;
            --control Key Shedule
            en_K     : out STD_LOGIC;
            en_L 	: out STD_LOGIC;
            en_C 	: out STD_LOGIC;
            sel_KLC : out STD_LOGIC;
            sel_RK 	: out STD_LOGIC;
            sel_T 	: out STD_LOGIC;
            sel_L : out STD_LOGIC
		    );
	end component SM_CLEFIA;

	component reg_text is
    	Port ( 
    		clk     : in STD_LOGIC;
            reset   : in STD_LOGIC;
    	    enable  : in STD_LOGIC;
    	    text_in  : in STD_LOGIC_VECTOR (127 downto 0);
            text_out : out STD_LOGIC_VECTOR (127 downto 0)
            );
	end component reg_text;
	
		component reg_key is
		Port (
			clk     : in STD_LOGIC;
		    reset   : in STD_LOGIC;
		    enable  : in STD_LOGIC;
		    key_in  : in STD_LOGIC_VECTOR (127 downto 0);
		    key_out : out STD_LOGIC_VECTOR (127 downto 0)
		    );
	end component reg_key;
	
	component mux3_1 is
		port ( 
			input0 : in  STD_LOGIC_VECTOR(127 downto 0);
			input1 : in  STD_LOGIC_VECTOR(127 downto 0);
			input2 : in  STD_LOGIC_VECTOR(127 downto 0);
			ctrl   : in  STD_LOGIC_VECTOR (1 downto 0);
			output : out STD_LOGIC_VECTOR(127 downto 0)
		);
	end component mux3_1;

	--sinais
	signal sig_C, sig_P                            : std_logic_vector (127 downto 0);
	signal sig_sel_P                               : std_logic_vector (1 downto 0);
	signal sig_K, sig_L, sig_text_in, sig_text_out : std_logic_vector (127 downto 0); 
	signal sig_en_txt, sig_en_cont                 : std_logic;
	signal sig_round                               : std_logic_vector (4 downto 0);
	signal sig_sel_GF_WK, 
		   sig_sel_shift, sig_sel_OUT              : std_logic;
	signal sig_WK, sig_RK                          : std_logic_vector (63 downto 0);
	signal sig_en_K, sig_en_L, sig_en_C, 
		   sig_sel_LKC, sig_sel_RK, sig_sel_T, sig_sel_L    : std_logic;

begin

		KS : key_shedule port map(
    	 	clk  	    => clk,
			reset       => reset,
			K_in        => key,
           	L_in        => sig_C,
           	en_regL     => sig_en_L,
           	en_constant => sig_en_C,
           	sel_T       => sig_sel_LKC,
           	sel_muxKL   => sig_sel_T,
           	sel_muxRK   => sig_sel_RK,
           	sel_muxL    => sig_sel_L,
           	L_out       => sig_L,
           	WK    	    => sig_WK,
           	RK    	    => sig_RK
           	);	

		GF : GF4N port map (
			clk => clk,
			reset => reset,
			enable => sig_en_C,
			P 		     => sig_P,
	        round_key    => sig_RK,
	        w_key	     => sig_WK,
	        --sel_mux_wk   => sig_sel_WK,
	        sel_mux_gf_wk => sig_sel_GF_WK,
	        sel_mux_shift => sig_sel_shift,
	        sel_mux_out  => sig_sel_OUT,
	        C            => sig_C
	        );

		cont : contador port map (
			clk     => clk,
			reset   => reset,
			cnt_res => sig_en_cont,
			round   => sig_round
			);
			
		SM : SM_CLEFIA port map (
			clk   	 => clk,
    	    reset 	 => reset,
    	    round 	 => sig_round,
    	    start 	 => start,
            --control TOP
            en_K     => sig_en_K,
            en_TXT   => sig_en_txt,
            --sel_TXT  => sig_sel_txt,
            en_count => sig_en_cont,
            sel_P    => sig_sel_P,
            ready    => ready,
            --control GF4N
            --sel_WK   => sig_sel_WK,
            sel_GF_WK => sig_sel_GF_WK,
            sel_shift => sig_sel_shift,
            sel_OUT  => sig_sel_OUT,
            --control Key Shedule
            en_L 	 => sig_en_L,
            en_C 	 => sig_en_C,
            sel_KLC  => sig_sel_LKC,
            sel_RK 	 => sig_sel_RK,
            sel_T 	 => sig_sel_T,
            sel_L	 => sig_sel_L
		    );
		    
		txt : reg_text port map (
    		clk      => clk,
            reset    => reset,
    	    enable   => sig_en_txt,
    	    text_in  => sig_text_in,
            text_out => sig_text_out
            );
            
		reg_K :	reg_key port map (
           	clk     => clk,
           	reset   => reset,
            enable  => sig_en_K,
            key_in  => key, 
            key_out => sig_K
            );			

		mux : mux3_1 port map (
			input0 => sig_K,
			input1 => sig_L,
			input2 => sig_text_out,
			ctrl   => sig_sel_P,
			output => sig_P
			);
		
		-- mux do registrador de texto
		WITH sig_en_K SELECT
			sig_text_in <= sig_C WHEN '0',
		         	       plaintext WHEN OTHERS;


	ciphertext <= sig_text_out; -- Texto Encriptado
	--round_count <= sig_round;   -- contador de rodadas
	         	    
end Behavioral;
