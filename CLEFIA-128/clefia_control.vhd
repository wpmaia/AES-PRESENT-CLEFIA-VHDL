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
-- Descrição: clefia_control (Controle dos Estados)
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

entity clefia_control is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           round : in STD_LOGIC_VECTOR (4 downto 0);
           en_count : out STD_LOGIC;
           en_const : out STD_LOGIC;
           ready    : out STD_LOGIC
           );
end clefia_control;

architecture Behavioral of clefia_control is

	type estados is (
					 SM_STOP, SM_LOAD, SM_L_KEY, SM_ENC, SM_READY
					 );
	signal state, next_state : estados;

begin
	States : process (state, start, round)
		begin
			case state is
				when SM_STOP =>
					en_count <= '0';
					ready <=    '0';
					if (start='1') then
					en_const <= '1';
					next_state <= SM_LOAD;
					else 
					next_state <= SM_STOP;
					end if;

				when SM_LOAD =>
					en_count <= '1';
					en_const <= '1';
					ready <=    '0';
					next_state <= SM_L_KEY;

				when SM_L_KEY =>
					en_count <= '1';
					en_const <= '1';
					ready <=    '0';
					if (round = "01100") then -- 12 rodadas para geração de L_key
					next_state <= SM_ENC;
					else
					next_state <= SM_L_KEY;
					end if;

				when SM_ENC =>
					en_count <= '1';
					en_const <= '1';
					ready <=    '0';
					if (round = "11110") then -- 30 (30 - 12 = 18) 18 rodadas de encriptação
					next_state <= SM_READY;
					else
					next_state <= SM_ENC;
					end if;

				when SM_READY =>
					en_count <= '1';
					en_const <= '1';
					ready <=    '1';
					if (start = '1') then 
					next_state <= SM_LOAD;
					else 
					next_state <= SM_STOP;
					end if;
				end case;
			end process States;
			
	SM : process (clk, reset)
		begin
			if (reset = '1') then
				state <= SM_STOP;				
			elsif (clk'Event and clk = '1') then --borda de subida do clock
				state <= next_state;
			end if;
		end process SM;
											
end Behavioral;
