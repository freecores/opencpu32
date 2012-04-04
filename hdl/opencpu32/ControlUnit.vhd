--! @file
--! @brief ControlUnit http://en.wikipedia.org/wiki/Control_unit

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--! Use CPU Definitions package
use work.pkgOpenCPU32.all;

--! The control unit coordinates the input and output devices of a computer system. It fetches the code of all of the instructions \n
--! in the microprograms. It directs the operation of the other units by providing timing and control signals. \n
--! all computer resources are managed by the Control Unit.It directs the flow of data between the cpu and the other devices.\n
--! The outputs of the control unit control the activity of the rest of the device. A control unit can be thought of as a finite-state machine.

--! The purpose of datapaths is to provide routes for data to travel between functional units.
entity ControlUnit is
    generic (n : integer := nBits - 1);									--! Generic value (Used to easily change the size of the Alu on the package)
	 Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           FlagsDp : in  STD_LOGIC_VECTOR (n downto 0);
           DataDp : in  STD_LOGIC_VECTOR (n downto 0);
           MuxDp : out  STD_LOGIC_VECTOR (2 downto 0);
           ImmDp : out  STD_LOGIC_VECTOR (n downto 0);
           DpRegFileWriteAddr : out  STD_LOGIC;
           DpRegFileWriteEn : out  STD_LOGIC;
           DpRegFileReadAddrA : out  STD_LOGIC;
           DpRegFileReadAddrB : out  STD_LOGIC;
           DpRegFileReadEnA : out  STD_LOGIC;
           DpRegFileReadEnB : out  STD_LOGIC;
           MemoryDataRead   : out std_logic;
			  MemoryDataWrite  : out std_logic;
			  MemoryDataInput : in  STD_LOGIC_VECTOR (n downto 0);
           MemoryDataAddr : out  STD_LOGIC_VECTOR (n downto 0);
           MemoryDataOut : out  STD_LOGIC_VECTOR (n downto 0));
end ControlUnit;

--! @brief ControlUnit http://en.wikipedia.org/wiki/Control_unit
--! @details The control unit receives external instructions or commands which it converts into a sequence of control signals that the control \n
--! unit applies to data path to implement a sequence of register-transfer level operations.
architecture Behavioral of ControlUnit is
signal currentCpuState : controlUnitStates;					-- CPU states
signal nextCpuState    : controlUnitStates;					-- CPU states
signal PC              : std_logic_vector(n downto 0);	-- Program Counter
signal IR              : std_logic_vector(n downto 0);	-- Intruction register
signal currInstruction : std_logic_vector(n downto 0);	-- Current Intruction
begin

	-- Next state logic
	process (clk, reset)
	begin
		if (reset = '1') then
			currentCpuState <= initial;
			MemoryDataAddr <= (others => '0');
		elsif rising_edge(clk) then
			currentCpuState <= nextCpuState;
		end if;
	end process;
	
	-- States Fetch, decode, execute from the processor
	process (currentCpuState)
	variable cyclesExecute : integer range 0 to 20; -- Cycles to wait while executing instruction
	begin
		case currentCpuState is			
			-- Initial state left from reset ...
			when initial =>
				cyclesExecute := 0;
				PC <= (others => '0');
				IR <= (others => '0');
				MemoryDataRead <= (others => '0');
				MemoryDataWrite <= (others => '0');
				MemoryDataAddr <= (others => '0');
				nextCpuState <= fetch;
			
			-- Fetch state (Go to memory and get a instruction)
			when fetch =>
				-- Increment program counter (Remember that PC will be update only on the next cycle...
				PC <= PC + conv_std_logic_vector(1, nBits);
				MemoryDataAddr <= PC;	-- Warning PC is not 1 yet...
				IR <= MemoryDataInput;
				MemoryDataRead <= '1';
				nextCpuState <= decode;
			
			-- Detect with instruction came from memory, set the number of cycles to execute...
			when decode =>
				MemoryDataRead <= '0';
				MemoryDataWrite <= '0';
				
				-- The high attribute points to the highes bit position
				case IR((IR'HIGH) downto (IR'HIGH - 5)) is
					when mov_reg =>
							nextCpuState <= execute;
							cyclesExecute := 2;
							currInstruction <= IR;
					-- Invalid instruction (Now will be ignored, but latter shoud rais a trap
					when others =>						
				end case;
			
			-- Wait while the process that handles the execution works..
			when execute =>
				if cyclesExecute > 1 then
					cyclesExecute := cyclesExecute - 1;
				else 	
					nextCpuState <= fetch;
				end if;
			when others =>
				null;
		end case;
	end process;
	
	-- Process that handles the execution of each instruction
	process (currInstruction)
	begin
	
	end process;

end Behavioral;

