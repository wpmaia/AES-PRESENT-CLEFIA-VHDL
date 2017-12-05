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
-- Descrição: SM_CLEFIA(TOP Máquina de Estados)
-- Versão: 1
                                                                                   
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

entity SM_CLEFIA is
	Port (
		clk       : in STD_LOGIC;
		reset     : in STD_LOGIC;
		start	  : in STD_LOGIC;
		round     : in STD_LOGIC_VECTOR (4 downto 0);
		--rom_control : in STD_LOGIC_VECTOR (12 downto 0);
		en_TXT    : out STD_LOGIC;
		en_K      : out STD_LOGIC;
		en_count  : out STD_LOGIC;
		sel_P     : out STD_LOGIC_VECTOR (1 downto 0);
		ready     : out STD_LOGIC;
		--en_GF     : out STD_LOGIC;
		sel_GF_WK  : out STD_LOGIC;
		sel_shift : out STD_LOGIC;
		sel_OUT   : out STD_LOGIC;
		en_L      : out STD_LOGIC;
		en_C      : out STD_LOGIC;
		sel_KLC   : out STD_LOGIC;
		sel_RK    : out STD_LOGIC;
		sel_T     : out STD_LOGIC;
		sel_L  : out STD_LOGIC
		);
end SM_CLEFIA;

--controle TOP
--en_TXT    <= '0';   habilita registrador de Texto
--en_K	     <= '0';   habilita registrador da chave e sel do texto
--sel_P 	  <= "11";  seletor de GF4N (recebe: K quando "01"; L quando "10"; Texto quando "00", "000"... quando outros)
--ready     <= '0'; sinaliza para encriptação pronta, ler saída;
--controle de  GF4N
--sel_GF_WK  <= '0';   controla seletor WK e entrada GF4N( WK_out quando '1'; ou P quando '0') 
--sel_shift <= '0';   controla seletor saída GF4N: Shift_out quando '0' ou GF4N_out quando '1';
--sel_OUT   <= '0';   controla seletor de saída de GF4N : Shift_out quando '0'; ou WK_out quando '1';
--controle KEY_SHEDULE
--en_L      <= '0';   habilita registrador L
--en_C      <= '0';   habilita ROM constantes
--sel_KLC   <= '0';   seletor de T: L xor C quando '0', out L xor K xor C when '1'
--sel_RK    <= '0';   seletor da RK: T quando '1' ou Constant quando '0'
--sel_T     <= '0';   seletor de T : primeira parte da chave (K e L) quando '0', '1' segunda parte;
--sel_L     <= '0';   seletor de L: L_in quando '0' ou DS_out(double_swap) quando '1';


architecture Behavioral of SM_CLEFIA is

	component ROM_SM is
 		Port (
	 	  	clk     : in std_logic;
	 	  	reset   : in std_logic;
	 	  	enable  : in std_logic;
	 	  	control : out std_logic_vector (12 downto 0)
	 	  	);
	end component ROM_SM;

	component clefia_control is
    	Port ( 
    		clk : in STD_LOGIC;
	       	reset : in STD_LOGIC;
	       	start : in STD_LOGIC;
	       	round : in STD_LOGIC_VECTOR (4 downto 0);
	       	en_count : out STD_LOGIC;
	       	en_const : out STD_LOGIC;
	       	ready    : out STD_LOGIC
	      	 );
	end component clefia_control;
	
	signal sig_control : std_logic_vector (12 downto 0);
	signal sig_en_const : std_logic;
	
begin

	control_SM : ROM_SM port map(
		clk     => clk,
		reset   => reset,
		enable  => sig_en_const,
		control => sig_control
		);

	MaqEst : clefia_control port map (
    	clk 	 => clk,
	    reset 	 => reset,
	    start 	 => start,
	    round    => round,
	    en_count => en_count,
	    en_const => sig_en_const,
	    ready    =>	ready
	    );

--controle TOP
en_TXT     <= sig_control (12);
en_K	     <= sig_control (11);
sel_P 	 <= sig_control (10 downto 9);
--controle de  GF4N
sel_GF_WK  <= sig_control (8);
sel_shift  <= sig_control (7);
sel_OUT    <= sig_control (6);
--controle KEY_SHEDULE
en_L       <= sig_control (5);
en_C       <= sig_control (4);
sel_KLC    <= sig_control (3);
sel_RK     <= sig_control (2);
sel_T      <= sig_control (1);
sel_L      <= sig_control (0);

--en_GF <= sig_en_const;
													
end Behavioral;