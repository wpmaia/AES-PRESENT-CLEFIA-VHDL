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
-- Descrição: ROM(Variáveis de Controle dos processos durante encriptação
-- Versão: 1
                                                                                   
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM_SM is
 	Port (
 	 	  clk     : in std_logic;
 	 	  reset   : in std_logic;
 	 	  enable  : in std_logic;
 	 	  control : out std_logic_vector (12 downto 0)
 	 	  );
end ROM_SM;

architecture Behavioral of ROM_SM is
	
	signal sig_const : std_logic_vector (12 downto 0) := (others => '0');
	type memory is array (0 to 32) of std_logic_vector(12 downto 0);
	constant myrom : memory := (

-- Variaveis de controle do CLEFIA (em ordem MSB para LSB)
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

--0  =>  "000110000000000", --stop
1  =>  "1111000010000", -- LOAD
2  =>  "0001000110000", --L1 
3  =>  "0010000110000", -- L (2 até 11) 2
4  =>  "0010000110000", -- L (2 até 11) 3
5  =>  "0010000110000", -- L (2 até 11) 4
6  =>  "0010000110000", -- L (2 até 11) 5
7  =>  "0010000110000", -- L (2 até 11) 6
8  =>  "0010000110000", -- L (2 até 11) 7
9 =>   "0010000110000", -- L (2 até 11) 8
10  => "0010000110000", -- L (2 até 11) 9
11  => "0010000110000", -- L (2 até 11) 10
12  => "0010000110000", -- L (2 até 11) 11
13  => "0010010110000", -- L12
14  => "1000100010100", -- R1_WK
15  => "1000000110111", -- R2 
16  => "1000000011101", -- R3
17  => "1000000111111", -- R4
18  => "1000000010101", -- R5
19  => "1000000110111", -- R6=R2 
20  => "1000000011101", -- R7=R3
21  => "1000000111111", -- R8=R4
22  => "1000000010101", -- R9=R5
23  => "1000000110111", -- R10=R2 
24  => "1000000011101", -- R11=R3
25  => "1000000111111", -- R12=R4
26  => "1000000010101", -- R13=R5
27  => "1000000110111", -- R14=R2 
28  => "1000000011101", -- R15=R3
29  => "1000000111111", -- R16=R4
30  => "1000000010101", -- R17=R5
31 =>  "1000001000110", --R18
32 =>  "0011001000000", --READY
others => "0011000000000");

begin
	
	control_rom : process (clk, reset, enable)
	variable internal_count : integer range 0 to 32;	
		begin
			if (reset = '1') then
				internal_count := 0;
				sig_const  <= (others => '0');
			elsif (clk = '1' and clk'Event) then
				if (enable = '1') then	 
				internal_count := internal_count + 1;
				sig_const <= myrom(internal_count);
				if (internal_count = 32) then                        
				    internal_count := 0;
					end if;
				end if;
			end if;
		end process control_rom;	
	
control  <= sig_const;

end Behavioral;