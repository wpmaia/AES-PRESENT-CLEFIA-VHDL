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
-- Descrição: GF4N (Módulo TOP da Rede Generalizada de Feistel de 4 Ramificações)
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

entity GF4N is
    Port ( clk         : in STD_LOGIC;
           reset       : in STD_LOGIC;
           enable      : in STD_LOGIC;
    	   P 		   : in STD_LOGIC_VECTOR (127 downto 0);
           round_key   : in STD_LOGIC_VECTOR (63 downto 0);
           w_key	   : in STD_LOGIC_VECTOR (63 downto 0);
           sel_mux_gf_wk : in STD_LOGIC;
           sel_mux_shift : in STD_LOGIC;
           sel_mux_out : in STD_LOGIC;
           C           : out STD_LOGIC_VECTOR (127 downto 0)
           );
end GF4N;

architecture Behavioral of GF4N is

	component F0 is
    	Port (r_key : in STD_LOGIC_VECTOR (31 downto 0);
       	      f0_in : in STD_LOGIC_VECTOR (31 downto 0);
       	      f0_out : out STD_LOGIC_VECTOR (31 downto 0)
       	      );
	end component F0;

	component F1 is
    	Port (r_key : in STD_LOGIC_VECTOR (31 downto 0);
       	      f1_in : in STD_LOGIC_VECTOR (31 downto 0);
       	      f1_out : out STD_LOGIC_VECTOR (31 downto 0)
       	      );
	end component F1;
	
	component WKs is
		Port (
			  wk_in : in STD_LOGIC_VECTOR (127 downto 0);
		      wk_out : out STD_LOGIC_VECTOR (127 downto 0);
		      keys_w : in STD_LOGIC_VECTOR (63 downto 0)
	           	      );
	end component WKs;
		
	component shift is  
		Port (
			  shift_in : in STD_LOGIC_VECTOR (127 downto 0);
		      shift_out : out STD_LOGIC_VECTOR (127 downto 0)
		     	);
	end component shift;
	
--	component reg is
--			Port ( 
--			   clk : in STD_LOGIC;
--		       reset: in STD_LOGIC;
--		       enable : in STD_LOGIC;
--		       reg_in : in STD_LOGIC_VECTOR (31 downto 0);
--		       reg_out : out STD_LOGIC_VECTOR (31 downto 0)
--		       );
--		end component reg;
	
	--Signals outside of GF4N
	signal sig_gf4n_in, sig_gf4n_out, sig_wk_in, sig_wk_out : std_logic_vector (127 downto 0);
	signal sig_shift_out : std_logic_vector (127 downto 0);
	--Signals inside of GF4N	
	signal p0,p1,p2,p3 : std_logic_vector (31 downto 0);
	signal p1_out, p3_out : std_logic_vector (31 downto 0);
	signal rk1, rk2 : std_logic_vector (31 downto 0);
	signal f0_out, f1_out : std_logic_vector (31 downto 0);
	signal sig_shift : std_logic_vector (127 downto 0) := (others => '0');
	signal sig_P, sig_C : std_logic_vector (127 downto 0) := (others => '0');
--	signal regf0_out, regf1_out : std_logic_vector (31 downto 0);
	
begin
		
		function_0 : F0 port map(
			r_key => rk1, 
			f0_in => p0, 
			f0_out => f0_out
		);

		function_1 : F1 port map(
			r_key => rk2, 
			f1_in => p2, 
			f1_out => f1_out
		);
	
		whitening_keys : WKs port map(
	        wk_in  => sig_wk_in,
	        wk_out => sig_wk_out,
            keys_w =>  w_key
		);
		
		SFT : shift port map (
			shift_in => sig_gf4n_out,
			shift_out => sig_shift_out
		);
		
--		regf0 : reg port map (
--			clk => clk,
--			reset => reset,
--			enable => enable,
--			reg_in => f0_out,
--			reg_out => regf0_out
--			);

--		regf1 : reg port map (
--			clk => clk,
--			reset => reset,
--			enable => enable,
--			reg_in => f1_out,
--			reg_out => regf1_out
--			);			
			
		-- mux de GF4N
		WITH sel_mux_gf_wk SELECT
			sig_gf4n_in <= P WHEN '0',
		         sig_wk_out WHEN OTHERS;
		         	 
		-- mux do WK
		WITH sel_mux_gf_wk SELECT
		    sig_wk_in <= P WHEN '1',
		         	     sig_gf4n_out WHEN OTHERS;         	 
		
		-- mux da saída - C 
		WITH sel_mux_out SELECT
		    C <= sig_wk_out WHEN '1',
		             	sig_shift WHEN OTHERS;
		         
		-- mux do Shift
		WITH sel_mux_shift SELECT
		    sig_shift <= sig_gf4n_out WHEN '1',
		                 sig_shift_out WHEN OTHERS;
		         
	--RKs (Chaves da rodada)
	rk1 <= round_key (63 downto 32);
	rk2 <= round_key (31 downto 0);

	--p0,p1,p2,p3 (interno GF4N)
	p0 <= sig_gf4n_in (127 downto 96);
	p1 <= sig_gf4n_in(95 downto 64);
	p2 <= sig_gf4n_in (63 downto 32);
	p3 <= sig_gf4n_in (31 downto 0);

	-- add F0 XOR "P1"
	p1_out <= f0_out xor p1;
	-- add F1 XOR "P3"
	p3_out <= f1_out xor p3;

	--saída de GF4N
	sig_gf4n_out <= p0 & p1_out & p2 & p3_out;

	
end Behavioral;
