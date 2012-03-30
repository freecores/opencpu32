--! @file
--! @brief 2:1 CPU global Definitions

--! @mainpage
--! <H1>Main document of the OpenCPU32 project</H1>\n
--! <H2>Features</H2>

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package pkgOpenCPU32 is

--! Declare constants, enums, functions used by the design
constant nBits		: integer := 32;

--! Number of general registers (r0..r15)
constant numGenRegs : integer := 16;

type aluOps is (alu_pass, alu_sum, alu_sub, alu_inc, alu_dec, alu_mul, alu_or, alu_and, alu_xor, alu_not);
type typeEnDis is (enable, disable);
type generalRegisters is (r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15);

function reg2Num (a: generalRegisters) return integer;
function Num2reg (a: integer) return generalRegisters;

end pkgOpenCPU32;

--! Define functions or procedures
package body pkgOpenCPU32 is

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
