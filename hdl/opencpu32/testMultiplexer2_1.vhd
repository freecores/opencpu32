--! @file
--! @brief Testbench for Multiplexer2_1

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
--! Use CPU Definitions package
use work.pkgOpenCPU32.all;
 
ENTITY testMultiplexer2_1 IS
END testMultiplexer2_1;
 
--! @brief Multiplexer2_1 Testbench file
--! @details Test multiplexer operations changing the selection signal
--! for more information: http://en.wikipedia.org/wiki/Multiplexer
ARCHITECTURE behavior OF testMultiplexer2_1 IS 
 
    --! Component declaration to instantiate the Multiplexer circuit
    COMPONENT Multiplexer2_1
    generic (n : integer := nBits - 1);					--! Generic value (Used to easily change the size of the Alu on the package)
	 Port ( A   : in  STD_LOGIC_VECTOR (n downto 0);	--! First Input
           B   : in  STD_LOGIC_VECTOR (n downto 0);	--! Second Input
           sel : in  STD_LOGIC;								--! Select inputs (1 or 2)
           S   : out  STD_LOGIC_VECTOR (n downto 0));	--! Mux Output
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector((nBits - 1) downto 0) := (others => '0');
   signal B : std_logic_vector((nBits - 1) downto 0) := (others => '0');
   signal sel : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector((nBits - 1) downto 0);   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Multiplexer2_1 PORT MAP (
          A => A,
          B => B,
          sel => sel,
          S => S
        );
   
   --! Process that will change sel signal and verify the Mux outputs
   stim_proc: process
   begin		
      -- Sel 0 ---------------------------------------------------------------------------
		wait for 1 ps;
		REPORT "Select first channel" SEVERITY NOTE;
		sel <= '0';
		A <= conv_std_logic_vector(0, nBits);
		B <= conv_std_logic_vector(1000, nBits);		
		wait for 1 ns;  -- Wait to stabilize the response
		assert S = (A) report "Could not select first channel" severity FAILURE;		
		
		-- Sel 1 ---------------------------------------------------------------------------
		wait for 1 ns;
		REPORT "Select second channel" SEVERITY NOTE;
		sel <= '1';
		A <= conv_std_logic_vector(0, nBits);
		B <= conv_std_logic_vector(1000, nBits);		
		wait for 1 ns;  -- Wait to stabilize the response
		assert S = (B) report "Could not select second channel" severity FAILURE;

      wait;
   end process;

END;
