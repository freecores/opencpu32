-------------------------------------------------------
--! @file
--! @brief 2:1 Mux using with-select
-------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--! Mux entity brief description

--! Detailed description of this 
--! mux design element.
entity Multiplexer2_1 is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC;
           S : in  STD_LOGIC_VECTOR (7 downto 0));
end Multiplexer2_1;

--! @brief Architure definition of the MUX
--! @details More details about this mux element.
architecture Behavioral of Multiplexer2_1 is

begin


end Behavioral;

