--! @file
--! @brief Arithmetic logic unit http://en.wikipedia.org/wiki/Arithmetic_logic_unit

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--! Use CPU Definitions package
library pkgOpenCPU32;

--! ALU is a digital circuit that performs arithmetic and logical operations.

--! ALU is a digital circuit that performs arithmetic and logical operations. It's the fundamental part of the CPU
entity Alu is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);		--! Alu Operand 1
           B : in  STD_LOGIC_VECTOR (7 downto 0);		--! Alu Operand 2
           S : out  STD_LOGIC_VECTOR (7 downto 0);		--! Alu Output
           sel : in  STD_LOGIC_VECTOR (2 downto 0));	--! Select operation
end Alu;

--! @brief Architure definition of the ALU
--! @details More details about this mux element.
architecture Behavioral of Alu is

begin


end Behavioral;

