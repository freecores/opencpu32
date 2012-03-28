--! @file
--! @brief Arithmetic logic unit http://en.wikipedia.org/wiki/Arithmetic_logic_unit

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--! Use CPU Definitions package
use work.pkgOpenCPU32.all;

--! ALU is a digital circuit that performs arithmetic and logical operations.

--! ALU is a digital circuit that performs arithmetic and logical operations. It's the fundamental part of the CPU
entity Alu is
    generic (n : integer := nBits - 1);
	 Port ( A : in  STD_LOGIC_VECTOR (n downto 0);		--! Alu Operand 1
           B : in  STD_LOGIC_VECTOR (n downto 0);		--! Alu Operand 2
           S : out  STD_LOGIC_VECTOR (n downto 0);		--! Alu Output
           sel : in  aluOps);									--! Select operation
end Alu;

--! @brief Architure definition of the ALU
--! @details More details about this mux element.
architecture Behavioral of Alu is

begin
	--! Behavior description of combinational circuit (Can not infer any FF(Flip flop))
	process (A,B,sel) is
	begin
		case sel is
			when alu_sum =>
				S <= A + B;
			
			when alu_sub =>
				S <= A - B;
			
			when alu_inc =>
				S <= A - B;
			
			when alu_dec =>
				S <= A - B;
				
			when alu_and =>
				S <= A and B;
				
			when alu_or =>
				S <= A or B;
			
			when alu_xor =>
				S <= A xor B;
			
			when others =>
				S <= (others => 'Z');
		end case;
	end process;

end Behavioral;

