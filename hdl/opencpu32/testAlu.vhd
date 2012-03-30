--! @file
--! @brief Testbench for Alu

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--! Use CPU Definitions package
use work.pkgOpenCPU32.all;
 
ENTITY testAlu IS
END testAlu;
 
--! @brief Alu Testbench file
--! @details Exercise each Alu operation to verify if the description work as planned 
--! for more information: http://vhdlguru.blogspot.com/2010/03/how-to-write-testbench.html
ARCHITECTURE behavior OF testAlu IS 
 
    
	 --! Component declaration to instantiate the Alu circuit
    COMPONENT Alu
    generic (n : integer := nBits - 1);					--! Generic value (Used to easily change the size of the Alu on the package)
	 Port ( A : in  STD_LOGIC_VECTOR (n downto 0);		--! Alu Operand 1
           B : in  STD_LOGIC_VECTOR (n downto 0);		--! Alu Operand 2
           S : out  STD_LOGIC_VECTOR (n downto 0);		--! Alu Output
           sel : in  aluOps);									--! Select operation
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector((nBits - 1) downto 0) := (others => '0');	--! Wire to connect Test signal to component
   signal B : std_logic_vector((nBits - 1) downto 0) := (others => '0');	--! Wire to connect Test signal to component
   signal sel : aluOps := alu_sum;														--! Wire to connect Test signal to component

 	--Outputs
   signal S : std_logic_vector((nBits - 1) downto 0);								--! Wire to connect Test signal to component
   
BEGIN
 
	--! Instantiate the Unit Under Test (Alu) (Doxygen bug if it's not commented!)
   uut: Alu PORT MAP (
          A => A,
          B => B,
          S => S,
          sel => sel
        );

   --! Process that will stimulate all of the Alu operations
   stim_proc: process
   begin		      
      -- Pass ---------------------------------------------------------------------------
		wait for 1 ps;
		REPORT "Pass input A to output" SEVERITY NOTE;
		sel <= alu_pass;
		A <= conv_std_logic_vector(22, nBits);
		wait for 1 ns;  -- Wait to stabilize the response
		assert S = (A ) report "Invalid Pass output" severity FAILURE;		
		
		-- AND ---------------------------------------------------------------------------
		wait for 1 ps;
		REPORT "AND without carry 2(10) AND 3(11)" SEVERITY NOTE;
		sel <= alu_and;
		A <= conv_std_logic_vector(2, nBits);
		B <= conv_std_logic_vector(3, nBits);		
		wait for 1 ns;  -- Wait to stabilize the response
		assert S = (A and B) report "Invalid AND output" severity FAILURE;		
		
		-- OR ---------------------------------------------------------------------------
		wait for 1 ns;
		REPORT "OR without carry 5 OR 7" SEVERITY NOTE;
		sel <= alu_or;
		A <= conv_std_logic_vector(5, nBits);
		B <= conv_std_logic_vector(7, nBits);		
		wait for 1 ns;  -- Wait to stabilize the response
		assert S = (A or B) report "Invalid OR output" severity FAILURE;

		-- XOR ---------------------------------------------------------------------------
		wait for 1 ns;
		REPORT "OR without carry 11 XOR 9" SEVERITY NOTE;
		sel <= alu_xor;
		A <= conv_std_logic_vector(11, nBits);
		B <= conv_std_logic_vector(9, nBits);		
		wait for 1 ns;  -- Wait to stabilize the response
		assert S = (A xor B) report "Invalid XOR output" severity FAILURE;
		
		-- NOT ---------------------------------------------------------------------------
		wait for 1 ns;
		REPORT "NOT 10" SEVERITY NOTE;
		sel <= alu_not;
		A <= conv_std_logic_vector(10, nBits);
		B <= (others => 'X');		
		wait for 1 ns;  -- Wait to stabilize the response
		assert S = (not A) report "Invalid NOT output" severity FAILURE;

      wait;
   end process;

END;
