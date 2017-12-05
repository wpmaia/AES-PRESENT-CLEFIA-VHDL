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
-- Descrição: Testbench CLEFIA-128
-- Versão: 1
--                                                                                                                                                                                                                                       
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CLEFIA_ENC_TB IS
END CLEFIA_ENC_TB;
 
ARCHITECTURE behavior OF CLEFIA_ENC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CLEFIA_ENC
    PORT(
         plaintext : in STD_LOGIC_VECTOR (127 downto 0);
         key : in STD_LOGIC_VECTOR (127 downto 0);
         ciphertext : out STD_LOGIC_VECTOR (127 downto 0);
         clk, reset, start : in STD_LOGIC;
         ready : out STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal plaintext : std_logic_vector(127 downto 0) := (others => '0');
   signal key : std_logic_vector(127 downto 0) := (others => '0');
   signal start : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal ciphertext : std_logic_vector(127 downto 0);
   signal ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CLEFIA_ENC PORT MAP (
          plaintext => plaintext,
          key => key,
          ciphertext => ciphertext,
          start => start,
          clk => clk,
          reset => reset,
          ready => ready
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   
   begin		

		reset <= '1';
        start <= '0';
		wait for 10 ns;	
		reset <= '0';
			
------ Preparation for test case 1 -----------------
----   plaintext <= x"000102030405060708090a0b0c0d0e0f";
----   key <= x"ffeeddccbbaa99887766554433221100";
----   expected_ciphertext <= x"de2bf2fd9b74aacdf1298555459494fd";
----------------------------------------------------		
		
		plaintext <= X"000102030405060708090a0b0c0d0e0f";
		key <=  X"ffeeddccbbaa99887766554433221100";
		start <= '1';
      wait until ready = '1' and clk='0';
		
      if ciphertext /= x"de2bf2fd9b74aacdf1298555459494fd" then
			report "RESULT MISMATCH! Test case 1 failed" severity ERROR;
			assert false severity failure;
		else
			report "Test case 1 successful" severity note;	
		end if;

   end process;

END;
