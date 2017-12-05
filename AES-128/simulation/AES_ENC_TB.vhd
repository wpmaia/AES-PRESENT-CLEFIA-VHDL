----------------------------------------------------------------------------------
-- Mestrado em Engenharia Elétrica
-- Autor: William Pedrosa Maia
-- E-mail: wmaia.eng@gmail.com
-- Prof. Orientador: Edward David Moreno
-- Data: Fev/2017
--
-- Projeto: AES - Cifra Ultraleve de Bloco                                                                                                                                                                                       
--
-- Descrição:                                                 
-- Test Bench do Present-80 conforme test vector de (Bogdanov et al, 2007)
-- Versão: 1
--                                                                                                                                                          
-- Adaptado de (Krzysztof Gajewski, 2014)                                                                 
-- E-mail: k.gajewski@gmail.com                    
--
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY AES_ENC_TB IS
END AES_ENC_TB;
 
ARCHITECTURE behavior OF AES_ENC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AES_ENC
    PORT(
         plaintext : in STD_LOGIC_VECTOR (127 downto 0);
         key : in STD_LOGIC_VECTOR (127 downto 0);
         ciphertext : out STD_LOGIC_VECTOR (127 downto 0);
         clk, reset, encrypt : in STD_LOGIC;
         ready : out STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal plaintext : std_logic_vector(127 downto 0) := (others => '0');
   signal key : std_logic_vector(127 downto 0) := (others => '0');
   signal encrypt : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal ciphertext : std_logic_vector(127 downto 0);
   signal ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AES_ENC PORT MAP (
          plaintext => plaintext,
          key => key,
          ciphertext => ciphertext,
          encrypt => encrypt,
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
        encrypt <= '0';
		wait for 10 ns;	
		reset <= '0';

		
---- Preparation for test case 1 -----------------
--   plaintext <= x"3243f6a8885a308d313198a2e0370734";
--   key <= x"2b7e151628aed2a6abf7158809cf4f3c";
--   expected_ciphertext <= x"3925841d02dc09fbdc118597196a0b32";
--------------------------------------------------
		encrypt <= '1';
		
		plaintext <= X"3243f6a8885a308d313198a2e0370734";
		key <= X"2b7e151628aed2a6abf7158809cf4f3c";
		
      
		wait until ready = '1';
		
--		if ciphertext /= x"3925841d02dc09fbdc118597196a0b32" then
--			report "RESULT MISMATCH! Test case 1 failed" severity ERROR;
--			assert false severity failure;
--		else
--			report "Test case 1 successful" severity note;	
--		end if;
		

			
------ Preparation for test case 2 -----------------
----   plaintext <= x"00112233445566778899aabbccddeeff";
----   key <= x"000102030405060708090a0b0c0d0e0f";
----   expected_ciphertext <= x"69c4e0d86a7b0430d8cdb78070b4c55a";
----------------------------------------------------		
		
		
		plaintext <= X"00112233445566778899aabbccddeeff";
		key <=  X"000102030405060708090a0b0c0d0e0f";
--		start <= '1';
      wait until ready = '1' and clk = '0';
		
      if ciphertext /= x"69c4e0d86a7b0430d8cdb78070b4c55a" then
			report "RESULT MISMATCH! Test case 2 failed" severity ERROR;
			assert false severity failure;
		else
			report "Test case 2 successful" severity note;	
		end if;

------ Preparation for test case 3 -----------------
----   plaintext <= x"a112ffc72f68417b";
----   key <= x"00000000000000000000";
----   expected_ciphertext <= x"ffffffffffffffff";
----------------------------------------------------
		
		
--		plaintext <= (others => '1');
--		key <= (others => '0');
--		start <= '1';
--        wait until ready = '1' and clk = '0';
		
--		if ciphertext /= x"a112ffc72f68417b" then
--			report "RESULT MISMATCH! Test case 3 failed" severity ERROR;
--			assert false severity failure;
--		else
--			report "Test case 3 successful" severity note;	
--		end if;

------ Preparation for test case 4 -----------------
----   plaintext <= x"ffffffffffffffff";
----   key <= x"ffffffffffffffffffff";
----   expected_ciphertext <= x"3333dcd3213210d2";
----------------------------------------------------
		
--		start <= '0';
--		wait for clk_period;
		
--		plaintext <= (others => '1');
--		key <= (others => '1');
--		start <= '1';
--      wait until ready = '1' and clk = '0';
		
--		if ciphertext /= x"3333dcd3213210d2" then
--			report "RESULT MISMATCH! Test case 4 failed" severity ERROR;
--			assert false severity failure;
--		else
--			report "Test case 4 successful" severity note;	
--		end if;
		
--		assert false severity failure;

   end process;

END;
