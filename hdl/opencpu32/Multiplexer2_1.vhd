--! @file
--! @brief 2:1 Mux using with-select

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--! Use CPU Definitions package
use work.pkgOpenCPU32.all;

--! Mux 2->1 circuit can select one of the 2 inputs into one output with some selection signal

--! Detailed description of this 
--! mux design element.
entity Multiplexer2_1 is
    generic (n : integer := nBits - 1);					--! Generic value (Used to easily change the size of the Alu on the package)
	 Port ( A   : in  STD_LOGIC_VECTOR (n downto 0);	--! First Input
           B   : in  STD_LOGIC_VECTOR (n downto 0);	--! Second Input
           sel : in  STD_LOGIC;								--! Select inputs (1 or 2)
           S   : out  STD_LOGIC_VECTOR (n downto 0));	--! Mux Output
end Multiplexer2_1;

--! @brief Architure definition of the MUX
--! @details On this case we're going to use VHDL combinational description
architecture Behavioral of Multiplexer2_1 is

begin
	with sel select
		S <= A when '0',
			  B when '1',
			  (others => 'Z') when others;

end Behavioral;

