--! @file
--! @brief Testbench for OpenCpu top design

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
--! Use CPU Definitions package
use work.pkgOpenCPU32.all;

--! Adding library for File I/O (Synposys Text I/O package)
use std.textio.ALL;
use ieee.std_logic_textio.all;
 
ENTITY testOpenCpu IS
END testOpenCpu;
 
--! @brief openCpu Testbench file
--! @details This is the top-level test...
ARCHITECTURE behavior OF testOpenCpu IS 
 
    --! Component declaration to instantiate the Multiplexer circuit			
    COMPONENT openCpu
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         mem_rd : OUT  std_logic;
         mem_rd_addr : OUT  std_logic_vector(31 downto 0);
         mem_wr : OUT  std_logic;
         mem_wr_addr : OUT  std_logic_vector(31 downto 0);
         mem_data_in : IN  std_logic_vector(31 downto 0);
         mem_data_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal mem_data_in : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal mem_rd : std_logic;
   signal mem_rd_addr : std_logic_vector(31 downto 0);
   signal mem_wr : std_logic;
   signal mem_wr_addr : std_logic_vector(31 downto 0);
   signal mem_data_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	--!Instantiate the Unit Under Test (openCpu) (Doxygen bug if it's not commented!)
   uut: openCpu PORT MAP (
          rst => rst,
          clk => clk,
          mem_rd => mem_rd,
          mem_rd_addr => mem_rd_addr,
          mem_wr => mem_wr,
          mem_wr_addr => mem_wr_addr,
          mem_data_in => mem_data_in,
          mem_data_out => mem_data_out
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
      -- Reset operation
		REPORT "RESET" SEVERITY NOTE;
		rst <= '1';
      wait for 2 ns;	     
		rst <= '0';
		wait for 2 ns;	     	

      wait for clk_period*10;

      -- insert stimulus here 

      -- Finish simulation
		assert false report "NONE. End of simulation." severity failure;
		wait;
   end process;

END;
