--! @file
--! @brief 2:1 CPU global Definitions

--! @mainpage
--! <H1>Main document of the OpenCPU32 project</H1>\n
--! <H2>Features</H2>

--! Use standard library
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

package pkgOpenCPU32 is

--! Declare constants, enums, functions used by the design
constant nBits		: integer := 32;
constant instructionSize : integer := nBits;

--! Number of general registers (r0..r15)
constant numGenRegs : integer := 16;

type aluOps is (alu_pass, alu_passB, alu_sum, alu_sub, alu_inc, alu_dec, alu_mul, alu_or, alu_and, 
	alu_xor, alu_not, alu_shfLt, alu_shfRt, alu_roLt, alu_roRt);
type typeEnDis is (enable, disable);
type generalRegisters is (r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15);
type dpMuxInputs is (fromMemory, fromImediate, fromRegFileA, fromRegFileB, fromAlu);
type controlUnitStates is (initial, fetch, decode, execute, executing);

function reg2Num (a: generalRegisters) return integer;
function Num2reg (a: integer) return generalRegisters;
function muxPos( a: dpMuxInputs) return std_logic_vector;

-- Opcodes
subtype opcodes is std_logic_vector(5 downto 0);

-- Each instruction will take 32 bits
-- Tutorial on using records.. (http://vhdlguru.blogspot.com.br/2010/02/arrays-and-records-in-vhdl.html)
type instructionType is record
	opcode : std_logic_vector(5 downto 0);
	reg1   : std_logic_vector(3 downto 0);
	reg2   : std_logic_vector(3 downto 0);
	imm    : std_logic_vector(15 downto 0); -- Max imediate value (16 bits)
end record;


-- Data movement
constant mov_reg  : opcodes := conv_std_logic_vector(0,6);	 -- Move data between registers
constant mov_val  : opcodes := conv_std_logic_vector(1,6);   -- Move data from imediate value to a register
constant stom_reg : opcodes := conv_std_logic_vector(2,6);   -- Store a value in memory coming from a register
constant stom_val : opcodes := conv_std_logic_vector(3,6);   -- Store a value in memory coming from imediate
constant ld_reg   : opcodes := conv_std_logic_vector(4,6);   -- Load a value from memory into a register
constant ld_val   : opcodes := conv_std_logic_vector(5,6);   -- Load a value from memoru into another address in memory

-- Jump instructions
constant jmp_val  : opcodes := conv_std_logic_vector(6,6);	 -- Jump (PC <= Val)
constant jmpr_val : opcodes := conv_std_logic_vector(7,6);   -- Jump relative (PC <= PC + Val)
constant jz_val   : opcodes := conv_std_logic_vector(8,6);   -- Jump if zero
constant jzr_val  : opcodes := conv_std_logic_vector(9,6);   -- Jump if zero relative
constant jnz_val  : opcodes := conv_std_logic_vector(10,6);  -- Jump if not zero
constant jnzr_val : opcodes := conv_std_logic_vector(11,6);  -- Jump if not zero relative
constant call_reg : opcodes := conv_std_logic_vector(12,6);  -- Jump to address (Save return value on the stack
constant ret_reg  : opcodes := conv_std_logic_vector(13,6);  -- Pop return value from the stack and jump to it

-- Logical instructions
constant and_reg  : opcodes := conv_std_logic_vector(14,6);  -- And between to registers
constant and_val  : opcodes := conv_std_logic_vector(15,6);  -- And between register and imediate
constant or_reg   : opcodes := conv_std_logic_vector(16,6);  -- Or between to registers
constant or_val   : opcodes := conv_std_logic_vector(17,6);  -- Or between register and imediate
constant xor_reg  : opcodes := conv_std_logic_vector(18,6);  -- Xor between to registers
constant xor_val  : opcodes := conv_std_logic_vector(19,6);  -- Xor between register and imediate
constant not_reg  : opcodes := conv_std_logic_vector(20,6);  -- Not on register
constant shl_reg  : opcodes := conv_std_logic_vector(21,6);  -- Shift left register (one shift)
constant shr_reg  : opcodes := conv_std_logic_vector(22,6);  -- Shift right register (one shift)
constant rol_reg  : opcodes := conv_std_logic_vector(23,6);  -- Rotate left register (one rotation)
constant ror_reg  : opcodes := conv_std_logic_vector(24,6);  -- Rotate right register (one rotation)
constant sbit_reg : opcodes := conv_std_logic_vector(25,6);  -- Set bit pointed by register
constant cbit_reg : opcodes := conv_std_logic_vector(26,6);  -- Clear bit pointed by register

-- Math operations instructions (unsigned)
constant add_reg  : opcodes := conv_std_logic_vector(27,6);  -- Add to registers
constant add_val  : opcodes := conv_std_logic_vector(28,6);  -- Add register and a imediate value
constant sub_reg  : opcodes := conv_std_logic_vector(29,6);  -- Subtract to registers
constant sub_val  : opcodes := conv_std_logic_vector(30,6);  -- Subtract register and a imediate value
constant inc_reg  : opcodes := conv_std_logic_vector(31,6);  -- Increment register
constant dec_reg  : opcodes := conv_std_logic_vector(32,6);  -- Decrement register

-- Control opcodes
constant nop      : opcodes := conv_std_logic_vector(31,6);  -- Nop...
constant halt     : opcodes := conv_std_logic_vector(32,6);  -- Halt processor

end pkgOpenCPU32;

--! Define functions or procedures
package body pkgOpenCPU32 is

function muxPos( a: dpMuxInputs) return std_logic_vector is
variable valRet : std_logic_vector(2 downto 0); 
begin
	case a is
		when fromMemory => valRet := "000";
		when fromImediate => valRet := "001";
		when fromRegFileA => valRet := "010";
		when fromRegFileB => valRet := "011";
		when fromAlu => valRet := "100";
	end case;
	return valRet;
end muxPos;

function reg2Num (a: generalRegisters) return integer is
  variable valRet : integer; 
  begin
    case a is
		when r0 => valRet := 0;
		when r1 => valRet := 1;
		when r2 => valRet := 2;
		when r3 => valRet := 3;
		when r4 => valRet := 4;
		when r5 => valRet := 5;
		when r6 => valRet := 6;
		when r7 => valRet := 7;
		when r8 => valRet := 8;
		when r9 => valRet := 9;
		when r10 => valRet := 10;
		when r11 => valRet := 11;
		when r12 => valRet := 12;
		when r13 => valRet := 13;
		when r14 => valRet := 14;
		when r15 => valRet := 15;
	 end case;
	 return valRet;
  end reg2Num;
  
function Num2reg (a: integer) return generalRegisters is
  variable valRet : generalRegisters; 
  begin
    case a is
		when 0 => valRet := r0;
		when 1 => valRet := r1;
		when 2 => valRet := r2;
		when 3 => valRet := r3;
		when 4 => valRet := r4;
		when 5 => valRet := r5;
		when 6 => valRet := r6;
		when 7 => valRet := r7;
		when 8 => valRet := r8;
		when 9 => valRet := r9;
		when 10 => valRet := r10;
		when 11 => valRet := r11;
		when 12 => valRet := r12;
		when 13 => valRet := r13;
		when 14 => valRet := r14;
		when 15 => valRet := r15;
		when others => valRet := r0;
	 end case;
	 return valRet;
  end Num2reg;

end pkgOpenCPU32;
