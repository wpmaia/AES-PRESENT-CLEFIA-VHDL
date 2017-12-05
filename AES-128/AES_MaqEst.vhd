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
-- Descrição: Máquina de Estados (Controle)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Palmeira et al., 2014)                                                                                    
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

	entity AES_MaqEst is

	port (
		clk, reset, start : in std_logic;
		round               : in std_logic_vector (3 downto 0);
		ready, reg_enable, ctrl_mux, sel_mux : out std_logic
	     );
	end AES_MaqEst;

	architecture Behavioral of AES_MaqEst is
	
	type estados is (SM_STOP, SM_LOAD, SM_ENC, SM_READY);
	signal state, next_state : estados;	
	
	begin
		States : process(state, start, round)
			begin
				case state is
				    -- Aguardando o início do processo
					when SM_STOP =>
				    	ready <= '0';
				    	reg_enable <= '0';
				    	ctrl_mux <= '0';
				    	sel_mux <= '0';
				    	if (start = '1') then 
				    	next_state <= SM_LOAD;
				    	else 
				    	next_state <= SM_STOP;
				    	end if;
					
					-- Carregando texto e chave
					when SM_LOAD =>
						ready <= '0';
						reg_enable <= '1';
						ctrl_mux <= '0';
						sel_mux <= '0';
						next_state <= SM_ENC;
					
					--Encriptação			
					when SM_ENC =>	
						 ready <= '0';	
						 reg_enable <= '1';
						 ctrl_mux <= '1';
						 sel_mux <= '0';
						 if (round = "0001") then
						 next_state <= SM_ENC;
						 elsif (round = "1010") then
						 sel_mux <= '1';					     
						 next_state <= SM_READY;
						 else
						 next_state <= SM_ENC;
						 end if;
						 
					--Sinalização de encriptação finalizada	
					when SM_READY =>
						ready <= '1';
						reg_enable <= '0';
						ctrl_mux <= '1';
						sel_mux <='0';
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

