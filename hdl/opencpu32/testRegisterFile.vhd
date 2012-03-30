--! @file
--! @brief Testbench for Alu

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
--! Use CPU Definitions package
use work.pkgOpenCPU32.all;
 
ENTITY testRegisterFile IS
END testRegisterFile;
 
--! @brief testRegisterFile Testbench file
--! @details Test read/write on the registers, testing also the dual port reading feature...
ARCHITECTURE behavior OF testRegisterFile IS 
    
	--! Component declaration to instantiate the testRegisterFile circuit
    COMPONENT RegisterFile
    generic (n : integer := nBits - 1);						--! Generic value (Used to easily change the size of the registers)
	 Port ( clk : in  STD_LOGIC;									--! Clock signal
           writeEn : in  STD_LOGIC;								--! Write enable
           writeAddr : in  generalRegisters;					--! Write Adress
           input : in  STD_LOGIC_VECTOR (n downto 0);		--! Input 
           Read_A_En : in  STD_LOGIC;							--! Enable read A
           Read_A_Addr : in  generalRegisters;				--! Read A adress
           Read_B_En : in  STD_LOGIC;							--! Enable read A
           Read_B_Addr : in  generalRegisters;  			--! Read B adress
           A_Out : out  STD_LOGIC_VECTOR (n downto 0);	--! Output A
           B_Out : out  STD_LOGIC_VECTOR (n downto 0));	--! Output B
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';															--! Wire to connect Test signal to component
   signal writeEn : std_logic := '0';														--! Wire to connect Test signal to component
   signal writeAddr : generalRegisters := r0;											--! Wire to connect Test signal to component
   signal input : std_logic_vector((nBits - 1) downto 0) := (others => '0');	--! Wire to connect Test signal to component
   signal Read_A_En : std_logic := '0';													--! Wire to connect Test signal to component
   signal Read_A_Addr : generalRegisters := r0;											--! Wire to connect Test signal to component
   signal Read_B_En : std_logic := '0';													--! Wire to connect Test signal to component
   signal Read_B_Addr : generalRegisters := r0;											--! Wire to connect Test signal to component

 	--Outputs
   signal A_Out : std_logic_vector((nBits - 1) downto 0);							--! Wire to connect Test signal to component
   signal B_Out : std_logic_vector((nBits - 1) downto 0);   						--! Wire to connect Test signal to component
	
	constant num_cycles : integer := 320;													--! Number of clock iterations
 
BEGIN
 
	--! Instantiate the Unit Under Test (RegisterFile) (Doxygen bug if it's not commented!)
   uut: RegisterFile PORT MAP (
          clk => clk,
          writeEn => writeEn,
          writeAddr => writeAddr,
          input => input,
          Read_A_En => Read_A_En,
          Read_A_Addr => Read_A_Addr,
          Read_B_En => Read_B_En,
          Read_B_Addr => Read_B_Addr,
          A_Out => A_Out,
          B_Out => B_Out
        );

   --! Process that will stimulate all register assignments, and reads...
   stim_proc: process
   begin		      		
		-- r0=1 ... r15=16---------------------------------------------------------------------------
		clk <= '0';		
		REPORT "Write r0 := 1" SEVERITY NOTE;
		writeEn <= '1';
		writeAddr <= r0;
		input <= conv_std_logic_vector(1, nBits);		
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;  -- Wait to stabilize the response

		clk <= '0';		
		REPORT "Write r1 := 2" SEVERITY NOTE;
		writeEn <= '1';
		writeAddr <= r1;
		input <= conv_std_logic_vector(2, nBits);		
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;  -- Wait to stabilize the response
		
		clk <= '0';		
		REPORT "Write r2 := 3" SEVERITY NOTE;
		writeEn <= '1';
		writeAddr <= r2;
		input <= conv_std_logic_vector(3, nBits);		
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;  -- Wait to stabilize the response
		
		clk <= '0';		
		REPORT "Write r3 := 4" SEVERITY NOTE;
		writeEn <= '1';
		writeAddr <= r3;
		input <= conv_std_logic_vector(4, nBits);		
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;  -- Wait to stabilize the response
		
		clk <= '0';		
		REPORT "Write r4 := 5" SEVERITY NOTE;
		writeEn <= '1';
		writeAddr <= r4;
		input <= conv_std_logic_vector(5, nBits);		
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;  -- Wait to stabilize the response
		
		clk <= '0';
		writeEn <= '0';
		wait for 1 ns;  -- Wait to stabilize the response		
		-- Read r0..r15 PortA-------------------------------------------------------------------------
		REPORT "Check r0 = 1" SEVERITY NOTE;
		Read_A_En <= '1';
		Read_A_Addr <= r0;
		wait for 1 ns;  -- Wait to stabilize the response
		assert A_Out = conv_std_logic_vector(1, nBits) report "Invalid value r0" severity FAILURE;		
		
		REPORT "Check r1 = 2" SEVERITY NOTE;
		Read_A_En <= '1';
		Read_A_Addr <= r1;
		wait for 1 ns;  -- Wait to stabilize the response
		assert A_Out = conv_std_logic_vector(2, nBits) report "Invalid value r1" severity FAILURE;		
		
		REPORT "Check r2 = 3" SEVERITY NOTE;
		Read_A_En <= '1';
		Read_A_Addr <= r2;
		wait for 1 ns;  -- Wait to stabilize the response
		assert A_Out = conv_std_logic_vector(3, nBits) report "Invalid value r2" severity FAILURE;
		
		REPORT "Check r3 = 4" SEVERITY NOTE;
		Read_A_En <= '1';
		Read_A_Addr <= r3;
		wait for 1 ns;  -- Wait to stabilize the response
		assert A_Out = conv_std_logic_vector(4, nBits) report "Invalid value r3" severity FAILURE;
		
		REPORT "Check r4 = 5" SEVERITY NOTE;
		Read_A_En <= '1';
		Read_A_Addr <= r4;
		wait for 1 ns;  -- Wait to stabilize the response
		assert A_Out = conv_std_logic_vector(5, nBits) report "Invalid value r4" severity FAILURE;

      wait;
   end process;

END;
