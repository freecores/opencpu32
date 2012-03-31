--! @file
--! @brief Testbench for Alu

--! Use standard library and import the packages (std_logic_1164,std_logic_unsigned,std_logic_arith)
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--! Use CPU Definitions package
use work.pkgOpenCPU32.all;
 
ENTITY testDataPath IS
END testDataPath;
 
--! @brief Alu Testbench file
--! @details Exercise each Alu operation to verify if the description work as planned 
--! for more information: http://vhdlguru.blogspot.com/2010/03/how-to-write-testbench.html
ARCHITECTURE behavior OF testDataPath IS 
     
	 --! Component declaration to instantiate the Alu circuit
    COMPONENT DataPath
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
    END COMPONENT;
    

   --Inputs
   signal inputMm : std_logic_vector(31 downto 0) := (others => '0');	--! Wire to connect Test signal to component
   signal inputImm : std_logic_vector(31 downto 0) := (others => '0');	--! Wire to connect Test signal to component
   signal clk : std_logic := '0';													--! Wire to connect Test signal to component
   signal outEn : std_logic := '0';													--! Wire to connect Test signal to component
   signal aluOp : std_logic := '0';													--! Wire to connect Test signal to component
   signal muxSel : std_logic_vector(2 downto 0) := (others => '0');		--! Wire to connect Test signal to component
   signal regFileWriteAddr : std_logic := '0';									--! Wire to connect Test signal to component
   signal regFileWriteEn : std_logic := '0';										--! Wire to connect Test signal to component
   signal regFileReadAddrA : std_logic := '0';									--! Wire to connect Test signal to component
   signal regFileReadAddrB : std_logic := '0';									--! Wire to connect Test signal to component
   signal regFileEnA : std_logic := '0';											--! Wire to connect Test signal to component
   signal regFileEnB : std_logic := '0';											--! Wire to connect Test signal to component

 	--Outputs
   signal outputDp : std_logic_vector(31 downto 0);							--! Wire to connect Test signal to component
   signal dpFlags : std_logic_vector(31 downto 0);								--! Wire to connect Test signal to component
   
 
BEGIN
 
	--! Instantiate the Unit Under Test (Alu) (Doxygen bug if it's not commented!)
   uut: DataPath PORT MAP (
          inputMm => inputMm,
          inputImm => inputImm,
          clk => clk,
          outEn => outEn,
          aluOp => aluOp,
          muxSel => muxSel,
          regFileWriteAddr => regFileWriteAddr,
          regFileWriteEn => regFileWriteEn,
          regFileReadAddrA => regFileReadAddrA,
          regFileReadAddrB => regFileReadAddrB,
          regFileEnA => regFileEnA,
          regFileEnB => regFileEnB,
          outputDp => outputDp,
          dpFlags => dpFlags
        );
  
   -- Stimulus process
   stim_proc: process
   begin		
      

      -- insert stimulus here 

      wait;
   end process;

END;
