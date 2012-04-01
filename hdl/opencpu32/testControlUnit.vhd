--! @file
--! @brief Testbench for ControlUnit

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
--! Use CPU Definitions package
use work.pkgOpenCPU32.all;
 
ENTITY testControlUnit IS
END testControlUnit;
 
--! @brief ControlUnit Testbench file
--! @details Exercise the control unit with a assembly program sample
--! for more information: http://vhdlguru.blogspot.com/2010/03/how-to-write-testbench.html
ARCHITECTURE behavior OF testControlUnit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ControlUnit
    PORT(
         reset : IN  std_logic;															
         clk : IN  std_logic;
         FlagsDp : IN  std_logic_vector(7 downto 0);
         DataDp : IN  std_logic_vector(7 downto 0);
         MuxDp : OUT  std_logic_vector(2 downto 0);
         ImmDp : OUT  std_logic_vector(7 downto 0);
         DpRegFileWriteAddr : OUT  std_logic;
         DpRegFileWriteEn : OUT  std_logic;
         DpRegFileReadAddrA : OUT  std_logic;
         DpRegFileReadAddrB : OUT  std_logic;
         DpRegFileReadEnA : OUT  std_logic;
         DpRegFileReadEnB : OUT  std_logic;
         MemoryDataInput : IN  std_logic_vector(7 downto 0);
         MemoryDataAddr : OUT  std_logic_vector(7 downto 0);
         MemoryDataOut : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';															--! Wire to connect Test signal to component
   signal clk : std_logic := '0';															--! Wire to connect Test signal to component
   signal FlagsDp : std_logic_vector(7 downto 0) := (others => '0');				--! Wire to connect Test signal to component
   signal DataDp : std_logic_vector(7 downto 0) := (others => '0');				--! Wire to connect Test signal to component
   signal MemoryDataInput : std_logic_vector(7 downto 0) := (others => '0');	--! Wire to connect Test signal to component

 	--Outputs
   signal MuxDp : std_logic_vector(2 downto 0);											--! Wire to connect Test signal to component
   signal ImmDp : std_logic_vector(7 downto 0);											--! Wire to connect Test signal to component
   signal DpRegFileWriteAddr : std_logic;													--! Wire to connect Test signal to component
   signal DpRegFileWriteEn : std_logic;													--! Wire to connect Test signal to component
   signal DpRegFileReadAddrA : std_logic;													--! Wire to connect Test signal to component
   signal DpRegFileReadAddrB : std_logic;													--! Wire to connect Test signal to component
   signal DpRegFileReadEnA : std_logic;													--! Wire to connect Test signal to component
   signal DpRegFileReadEnB : std_logic;													--! Wire to connect Test signal to component
   signal MemoryDataAddr : std_logic_vector(7 downto 0);								--! Wire to connect Test signal to component
   signal MemoryDataOut : std_logic_vector(7 downto 0);								--! Wire to connect Test signal to component

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	--! Instantiate the Unit Under Test (ControlUnit)
   uut: ControlUnit PORT MAP (
          reset => reset,
          clk => clk,
          FlagsDp => FlagsDp,
          DataDp => DataDp,
          MuxDp => MuxDp,
          ImmDp => ImmDp,
          DpRegFileWriteAddr => DpRegFileWriteAddr,
          DpRegFileWriteEn => DpRegFileWriteEn,
          DpRegFileReadAddrA => DpRegFileReadAddrA,
          DpRegFileReadAddrB => DpRegFileReadAddrB,
          DpRegFileReadEnA => DpRegFileReadEnA,
          DpRegFileReadEnB => DpRegFileReadEnB,
          MemoryDataInput => MemoryDataInput,
          MemoryDataAddr => MemoryDataAddr,
          MemoryDataOut => MemoryDataOut
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
