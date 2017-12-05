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
-- Descrição: Máquina de Estados (Controle)
-- Versão: 1
--                                                                                                                                                      
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                                   
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity maqEstados is
	generic (
		w_5 : integer := 5
	);
	port (
		clk, reset, start : in std_logic;
		pronto, cnt_res, ctrl_mux, RegEn: out std_logic;
		round : in std_logic_vector (w_5-1 downto 0)
	);
end maqEstados;

architecture Behavioral of maqEstados is
	
	type estados is (SM_STOP, SM_LOAD, SM_ENC, SM_READY);
	signal state : estados;
	signal next_state : estados;	
	
	begin
		States : process(state, start, round)
			begin
				case state is
				    -- Aguardando o início do processo
					when SM_STOP =>
						pronto <= '0'; -- Encriptação finalizada (Ler)
						cnt_res <= '0'; -- gatilho do contador
						ctrl_mux <= '0'; -- seletor dos mux
						RegEn <= '0'; -- habilita registradores
						if (start = '1') then 
							next_state <= SM_LOAD;
						else 
							next_state <= SM_STOP;
						end if;

					-- carregando dados
					when SM_LOAD =>
						pronto <= '0';
						RegEn <= '1';
						cnt_res <= '1'; -- gatilho do contador
						ctrl_mux <= '0';
						next_state <= SM_ENC;
					
					
					-- codificando
					when SM_ENC =>
						pronto <= '0';
						RegEn <= '1';
						cnt_res <= '1';
						ctrl_mux <= '1'; 
							if (round = "00001") then
								next_state <= SM_ENC;
							-- última rodada
							elsif (round = "11111") then
								next_state <= SM_READY;
							else
								next_state <= SM_ENC;
							end if;

					-- fim da conversão    
					when SM_READY =>
						cnt_res <= '0';
						RegEn <= '0';
						pronto <= '1';
						ctrl_mux <= '1';
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
