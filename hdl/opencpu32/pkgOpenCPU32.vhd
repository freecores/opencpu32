--! @file
--! @brief 2:1 CPU global Definitions

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package pkgOpenCPU32 is

--! Declare constants, enums, functions used by the design
constant nBits		: integer := 32;

type aluOps is (alu_sum, alu_sub, alu_inc, alu_dec, alu_mul, alu_or, alu_and, alu_xor, alu_not);
type typeEnDis is (enable, disable);

end pkgOpenCPU32;

--! Define functions or procedures
package body pkgOpenCPU32 is

end pkgOpenCPU32;
