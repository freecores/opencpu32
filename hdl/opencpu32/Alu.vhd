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
    generic (n : integer := nBits - 1);					--! Generic value (Used to easily change the size of the Alu on the package)
	 Port ( A : in  STD_LOGIC_VECTOR (n downto 0);		--! Alu Operand 1
           B : in  STD_LOGIC_VECTOR (n downto 0);		--! Alu Operand 2
           S : out  STD_LOGIC_VECTOR (n downto 0);		--! Alu Output
           sel : in  aluOps);									--! Select operation
end Alu;

--! @brief Arithmetic logic unit, refer to this page for more information http://en.wikipedia.org/wiki/Arithmetic_logic_unit
--! @details This circuit will be excited by the control unit to perfom some arithimetic, or logic operation (Depending on the opcode selected)
--! \n You can see some samples on the Internet: http://www.vlsibank.com/sessionspage.asp?titl_id=12222
architecture Behavioral of Alu is

begin
	--! Behavior description of combinational circuit (Can not infer any FF(Flip flop)) of the Alu
	process (A,B,sel) is
	variable mulResult : std_logic_vector(((nBits*2) - 1)downto 0);
	begin
		case sel is
			when alu_pass =>
				--Pass operation
				S <= A;
			
			when alu_passB =>
				--Pass operation
				S <= B;
			
			when alu_sum =>
				--Sum operation
				S <= A + B;
			
			when alu_sub =>
				--Subtraction operation
				S <= A - B;
			
			when alu_inc =>
				--Increment operation
				S <= A + conv_std_logic_vector(1, n+1);
			
			when alu_dec =>
				--Decrement operation
				S <= A - conv_std_logic_vector(1, n+1);
			
			when alu_mul =>
				--Multiplication operation
				mulResult := A * B;
				S <= mulResult((nBits - 1) downto 0);
				
			when alu_and =>
				--And operation
				S <= A and B;
				
			when alu_or =>
				--Or operation
				S <= A or B;
			
			when alu_xor =>
				--Xor operation
				S <= A xor B;
			
			when alu_not =>
				--Not operation
				S <= not A;
			
			when others =>
				S <= (others => 'Z');
		end case;
	end process;

end Behavioral;

