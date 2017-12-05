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
-- Descrição: Constantes das Rodadas (RCON)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Palmeira et al., 2014)                                                                                    
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

entity const_rcon is
 	Port (
 	 	  clk     : in std_logic;
 	 	  reset   : in std_logic;
 	 	  enable  : in std_logic;
 	 	  const_rcon : out std_logic_vector (7 downto 0)
 	 	  );
end const_rcon;

architecture Behavioral of const_rcon is
	
	signal sig_const : std_logic_vector (7 downto 0) := (others => '0');
	type memory is array (1 to 10) of std_logic_vector(7 downto 0);
	constant myrom : memory := (
-- Constantes Key Shedule (para chave de 128)
1  => "00000001",
2  => "00000010",
3  => "00000100",
4  => "00001000",
5  => "00010000",
6  => "00100000",
7  => "01000000",
8  => "10000000",
9  => "00011011",
10 => "00110110",
others => "00000000");

begin
	
	key_const : process (clk, reset, enable)
	variable internal_count : integer range 0 to 10;	
		begin
			if (reset = '1') then
				internal_count := 0;
				sig_const  <= (others => '0');
			elsif (clk = '1' and clk'Event) then
				if (enable = '1') then	 
				internal_count := internal_count + 1;
				sig_const <= myrom(internal_count);
				if (internal_count = 10) then                        
				    internal_count := 0;
					end if;
				end if;
			end if;
		end process key_const;	
	
const_rcon  <= sig_const;

end Behavioral;
