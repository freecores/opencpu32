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
generic (n : integer := nBits - 1);									--! Generic value (Used to easily change the size of the Alu on the package)
END testControlUnit;
 
--! @brief ControlUnit Testbench file
--! @details Exercise the control unit with a assembly program sample
--! for more information: http://vhdlguru.blogspot.com/2010/03/how-to-write-testbench.html
ARCHITECTURE behavior OF testControlUnit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ControlUnit
    generic (n : integer := nBits - 1);									--! Generic value (Used to easily change the size of the Alu on the package)
	 Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;												--! Main system clock
           FlagsDp : in  STD_LOGIC_VECTOR (2 downto 0);				--! Flags comming from the Datapath
           DataDp : in  STD_LOGIC_VECTOR (n downto 0);				--! Data comming from the Datapath
			  outEnDp : out  typeEnDis;										--! Enable/Disable datapath output
           MuxDp : out  STD_LOGIC_VECTOR (2 downto 0);				--! Select on datapath data from (Memory, Imediate, RegFileA, RegFileB, AluOut)
			  MuxRegDp : out STD_LOGIC_VECTOR(1 downto 0);				--! Select Alu InputA (Memory,Imediate,RegFileA)
           ImmDp : out  STD_LOGIC_VECTOR (n downto 0);				--! Imediate value passed to the Datapath
           DpAluOp : out  aluOps;											--! Alu operations
			  DpRegFileWriteAddr : out  generalRegisters;				--! General register address to write
           DpRegFileWriteEn : out  STD_LOGIC;							--! Enable register write
           DpRegFileReadAddrA : out  generalRegisters;				--! General register address to read
           DpRegFileReadAddrB : out  generalRegisters;				--! General register address to read
           DpRegFileReadEnA : out  STD_LOGIC;							--! Enable register read (PortA)
           DpRegFileReadEnB : out  STD_LOGIC;							--! Enable register read (PortB)
           MemoryDataReadEn : out std_logic;								--! Enable Main memory read
			  MemoryDataWriteEn: out std_logic;								--! Enable Main memory write
			  MemoryDataInput : in  STD_LOGIC_VECTOR (n downto 0);	--! Incoming data from main memory
           MemoryDataRdAddr : out  STD_LOGIC_VECTOR (n downto 0);	--! Main memory Read address
			  MemoryDataWrAddr : out  STD_LOGIC_VECTOR (n downto 0);	--! Main memory Write address
           MemoryDataOut : out  STD_LOGIC_VECTOR (n downto 0));	--! Data to write on main memory
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';															--! Wire to connect Test signal to component
   signal clk : std_logic := '0';															--! Wire to connect Test signal to component
   signal FlagsDp : std_logic_vector(2 downto 0) := (others => '0');				--! Wire to connect Test signal to component
   signal DataDp : std_logic_vector(n downto 0) := (others => '0');				--! Wire to connect Test signal to component
   signal MemoryDataInput : std_logic_vector(n downto 0) := (others => '0');	--! Wire to connect Test signal to component

 	--Outputs
   signal outEnDp : typeEnDis;																--! Wire to connect Test signal to component
	signal MuxDp : std_logic_vector(2 downto 0);											--! Wire to connect Test signal to component
	signal MuxRegDp : std_logic_vector(1 downto 0);										--! Wire to connect Test signal to component
   signal ImmDp : std_logic_vector(n downto 0);											--! Wire to connect Test signal to component
	signal DpAluOp : aluOps;																	--! Wire to connect Test signal to component
   signal DpRegFileWriteAddr : generalRegisters;										--! Wire to connect Test signal to component
   signal DpRegFileWriteEn : std_logic;													--! Wire to connect Test signal to component
   signal DpRegFileReadAddrA : generalRegisters;										--! Wire to connect Test signal to component
   signal DpRegFileReadAddrB : generalRegisters;										--! Wire to connect Test signal to component
   signal DpRegFileReadEnA : std_logic;													--! Wire to connect Test signal to component
   signal DpRegFileReadEnB : std_logic;													--! Wire to connect Test signal to component
	signal MemoryDataReadEn : std_logic;													--! Wire to connect Test signal to component
	signal MemoryDataWriteEn : std_logic;													--! Wire to connect Test signal to component
	signal MemoryDataRdAddr : std_logic_vector(n downto 0);							--! Wire to connect Test signal to component
   signal MemoryDataWrAddr : std_logic_vector(n downto 0);							--! Wire to connect Test signal to component
   signal MemoryDataOut : std_logic_vector(n downto 0);								--! Wire to connect Test signal to component

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	--! Instantiate the Unit Under Test (ControlUnit)
   uut: ControlUnit PORT MAP (          
			reset => reset,
			clk => clk,
			FlagsDp => FlagsDp,
			DataDp => DataDp,
			outEnDp => outEnDp,
			MuxDp => MuxDp,
			MuxRegDp => MuxRegDp,
			ImmDp => ImmDp,
			DpAluOp => DpAluOp,
			DpRegFileWriteAddr => DpRegFileWriteAddr,
			DpRegFileWriteEn => DpRegFileWriteEn,
			DpRegFileReadAddrA => DpRegFileReadAddrA,
			DpRegFileReadAddrB => DpRegFileReadAddrB,
			DpRegFileReadEnA => DpRegFileReadEnA,
			DpRegFileReadEnB => DpRegFileReadEnB,
			MemoryDataReadEn => MemoryDataReadEn,
			MemoryDataWriteEn => MemoryDataWriteEn,
			MemoryDataInput => MemoryDataInput,
			MemoryDataRdAddr => MemoryDataRdAddr,
			MemoryDataWrAddr => MemoryDataWrAddr,
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
		-- Reset operation
		REPORT "RESET" SEVERITY NOTE;
		reset <= '1';
      wait for 2 ns;	     
		reset <= '0';
		wait for 2 ns;	     

      -- MOV r0,10d ---------------------------------------------------------------------------------
		REPORT "MOV r0,10" SEVERITY NOTE;
		wait for CLK_period;

      wait;
   end process;

END;
