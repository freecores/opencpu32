--! @file
--! @brief DataPath http://en.wikipedia.org/wiki/Datapath

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--! Use CPU Definitions package
use work.pkgOpenCPU32.all;

--! A datapath is a collection of functional units, such as arithmetic logic units or multipliers, that perform data processing operations.\n
--! Most central processing units consist of a datapath and a control unit, with a large part of the control unit dedicated to 
--! regulating the interaction between the datapath and main memory.

--! The purpose of datapaths is to provide routes for data to travel between functional units.
entity DataPath is
    generic (n : integer := nBits - 1);									--! Generic value (Used to easily change the size of the Alu on the package)
	 Port ( inputMm : in  STD_LOGIC_VECTOR (n downto 0);    			--! Input of Datapath from main memory       
			  inputImm : in  STD_LOGIC_VECTOR (n downto 0);    		--! Input of Datapath from imediate value (instructions...)
			  clk : in  STD_LOGIC;												--! Clock signal
           outEn : in  typeEnDis;											--! Enable/Disable datapath output
           aluOp : in  aluOps;												--! Alu operations
           muxSel : in  STD_LOGIC_VECTOR (2 downto 0);				--! Select inputs from dataPath(Memory,Imediate,RegisterFile,Alu)
           regFileWriteAddr : in  generalRegisters;					--! General register write address
           regFileWriteEn : in  STD_LOGIC;								--! RegisterFile write enable signal
           regFileReadAddrA : in  generalRegisters;					--! General register read address (PortA)
           regFileReadAddrB : in  generalRegisters;					--! General register read address (PortB)
           regFileEnA : in  STD_LOGIC;										--! Enable RegisterFile PortA
           regFileEnB : in  STD_LOGIC;										--! Enable RegisterFile PortB
			  outputDp : out  STD_LOGIC_VECTOR (n downto 0);			--! DataPath Output
           dpFlags : out  STD_LOGIC_VECTOR (n downto 0));			--! Alu Flags
end DataPath;

--! @brief DataPath http://en.wikipedia.org/wiki/Datapath
--! @details This description will also show how to instantiate components(Alu, RegisterFile, Multiplexer) on your design
architecture Behavioral of DataPath is

begin


end Behavioral;

