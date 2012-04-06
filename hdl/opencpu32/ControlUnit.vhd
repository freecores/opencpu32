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
			  MuxRegDp : out STD_LOGIC_VECTOR(1 downto 0);				--! Select Alu InputA (Memory,Imediate,RegFileA)
           ImmDp : out  STD_LOGIC_VECTOR (n downto 0);
           DpAluOp : out  aluOps;											--! Alu operations
			  DpRegFileWriteAddr : out  generalRegisters;
           DpRegFileWriteEn : out  STD_LOGIC;
           DpRegFileReadAddrA : out  generalRegisters;
           DpRegFileReadAddrB : out  generalRegisters;
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

signal currentExState  : executionStates;						-- Execution states
signal nextExState     : executionStates;						-- Execution states

signal PC              : std_logic_vector(n downto 0);	-- Program Counter
signal IR              : std_logic_vector(n downto 0);	-- Intruction register
signal currInstruction : std_logic_vector(n downto 0);	-- Current Intruction
begin

	-- Next state logic (CPU, fetch, decode, execute states)
	process (clk, reset)
	begin
		if (reset = '1') then
			currentCpuState <= initial;			
		elsif rising_edge(clk) then
			currentCpuState <= nextCpuState;
		end if;
	end process;
	
	-- Next state logic (Execution states)
	process (clk, currentCpuState)
	begin
		if ( (currentCpuState /= execute) and (currentCpuState /= executing) ) then
			currentExState <= initInstructionExecution;
		elsif rising_edge(clk) then
			currentExState <= nextExState;
		end if;
	end process;
	
	-- States Fetch, decode, execute from the processor
	process (currentCpuState)
	variable cyclesExecute : integer range 0 to 20; -- Cycles to wait while executing instruction
	variable opcodeIR : std_logic_vector(5 downto 0);
	begin
		opcodeIR := IR((IR'HIGH) downto (IR'HIGH - 5));
		case currentCpuState is			
			-- Initial state left from reset ...
			when initial =>
				cyclesExecute := 0;
				PC <= (others => '0');
				IR <= (others => '0');
				MemoryDataAddr <= (others => '0');
				MemoryDataRead <= '0';
				MemoryDataWrite <= '0';
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
				case opcodeIR is
					when mov_reg | mov_val | add_reg | sub_reg | and_reg | or_reg | xor_reg =>
							nextCpuState <= execute;
							cyclesExecute := 3;	-- Wait 3 cycles for mov operation
							currInstruction <= IR;
					-- Invalid instruction (Now will be ignored, but latter should raise a trap
					when others =>						
				end case;
			
			-- Wait while the process that handles the execution works..
			when execute =>
				if cyclesExecute = 0 then
					-- Finish the instruction execution get next
					nextCpuState <= fetch;
				else
					nextCpuState <= executing;
				end if;				
			
			-- Just wait a cycle and back again to execute state which verify if still need to wait some cycles
			when executing =>
				cyclesExecute := cyclesExecute - 1;				
				nextCpuState <= execute;
			
			when others =>
				null;
		end case;
	end process;
	
	-- Process that handles the execution of each instruction
	process (currentExState)	
	--variable operando1_reg : std_logic_vector(generalRegisters'range);
	variable opcodeIR     : std_logic_vector(5 downto 0);
	variable operand_reg1 : std_logic_vector(3 downto 0);
	variable operand_reg2 : std_logic_vector(3 downto 0);
	variable operand_imm  : std_logic_vector(21 downto 0);
	begin
		-- Parse the common operands
		opcodeIR := IR((IR'HIGH) downto (IR'HIGH - 5));					-- 6 Bits opcode (Max 64 instructions)
		operand_reg1 := IR((IR'HIGH - 6) downto (IR'HIGH - 9));		-- 4 bits register operand1 (Max 16 registers)
		operand_reg2 := IR((IR'HIGH - 10) downto (IR'HIGH - 13));   -- 4 bits register operand2 (Max 16 registers
		operand_imm  := IR((IR'HIGH - 10) downto (IR'LOW));			-- 22 bits imediate value (Max value 4194304)
		
		-- Select the instruction and init it's execution
		case currentExState is
			when initInstructionExecution =>
				case opcodeIR is					
					-- MOV r2,r1 (See the testDatapath to see how to drive the datapath for this function)
					when mov_reg =>						
						MuxDp <= muxPos(fromRegFileB);						
						DpRegFileReadAddrB <= Num2reg(conv_integer(UNSIGNED(operand_reg2)));
						DpRegFileWriteAddr <= Num2reg(conv_integer(UNSIGNED(operand_reg1)));						
						DpRegFileReadEnB <= '1';
						nextExState <= writeRegister;
					
					-- ADD r2,r0 (See the testDatapath to see how to drive the datapath for this function)
					when add_reg | sub_reg | and_reg | or_reg | xor_reg =>
						MuxDp <= muxPos(fromAlu);
						MuxRegDp <= muxRegPos(fromRegFileA);
						DpRegFileReadAddrA <= Num2reg(conv_integer(UNSIGNED(operand_reg1)));	-- Read first operand
						DpRegFileReadAddrB <= Num2reg(conv_integer(UNSIGNED(operand_reg2))); -- Read second operand
						DpRegFileReadEnA <= '1';
						DpRegFileReadEnB <= '1';												
						DpRegFileWriteAddr <= Num2reg(conv_integer(UNSIGNED(operand_reg1)));	-- Point to write in first operand (pointing to register)					
						DpAluOp <= opcode2AluOp(opcodeIR);	-- Select the alu operation from the operand
						nextExState <= writeRegister;
						
					-- MOV r0,10d (See the testDatapath to see how to drive the datapath for this function)
					when mov_val =>						
						MuxDp <= muxPos(fromImediate);						
						DpRegFileWriteAddr <= Num2reg(conv_integer(UNSIGNED(operand_reg1)));						
						ImmDp <= "0000000000" & operand_imm;	-- & is used to concatenate signals
						nextExState <= writeRegister;	

					-- ADD r3,2 (r2 <= r2+2) (See the testDatapath to see how to drive the datapath for this function)
					when add_val | sub_val | and_val | or_val | xor_val =>
						MuxDp <= muxPos(fromAlu);
						MuxRegDp <= muxRegPos(fromImediate);
						DpRegFileWriteAddr <= Num2reg(conv_integer(UNSIGNED(operand_reg1)));	
						DpRegFileReadAddrB <= Num2reg(conv_integer(UNSIGNED(operand_reg1)));	-- Read first operand
						DpRegFileReadEnB <= '1';												
						ImmDp <= "0000000000" & operand_imm;	-- & is used to concatenate signals						
						DpAluOp <= opcode2AluOp(opcodeIR);	-- Select the alu operation from the operand
						nextExState <= writeRegister;
					
					when others =>
						null;
				end case;
			
			-- Write something on the register files
			when writeRegister =>
				DpRegFileWriteEn <= '1';
				nextExState <= releaseWriteRead;
			
			-- Release lines (Reset Datapath lines to something that does nothing...)
			when releaseWriteRead =>
				DpRegFileReadEnB <= '0';
				DpRegFileReadEnA <= '0';
				DpRegFileWriteEn <= '0';
			
			when others =>
				null;
		end case;
	end process;

end Behavioral;

