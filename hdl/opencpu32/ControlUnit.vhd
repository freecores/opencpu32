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
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           FlagsDp : in  STD_LOGIC_VECTOR (7 downto 0);
           DataDp : in  STD_LOGIC_VECTOR (7 downto 0);
           MuxDp : out  STD_LOGIC_VECTOR (2 downto 0);
           ImmDp : out  STD_LOGIC_VECTOR (7 downto 0);
           DpRegFileWriteAddr : out  STD_LOGIC;
           DpRegFileWriteEn : out  STD_LOGIC;
           DpRegFileReadAddrA : out  STD_LOGIC;
           DpRegFileReadAddrB : out  STD_LOGIC;
           DpRegFileReadEnA : out  STD_LOGIC;
           DpRegFileReadEnB : out  STD_LOGIC;
           MemoryDataInput : in  STD_LOGIC_VECTOR (7 downto 0);
           MemoryDataAddr : out  STD_LOGIC_VECTOR (7 downto 0);
           MemoryDataOut : out  STD_LOGIC_VECTOR (7 downto 0));
end ControlUnit;

--! @brief ControlUnit http://en.wikipedia.org/wiki/Control_unit
--! @details The control unit receives external instructions or commands which it converts into a sequence of control signals that the control \n
--! unit applies to data path to implement a sequence of register-transfer level operations.
architecture Behavioral of ControlUnit is

begin


end Behavioral;

