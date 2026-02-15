library IEEE;
use IEEE.std_logic_1164.all;

entity MOD12 is
    port(PulseIn: in std_logic;
         Q: out std_logic_vector(3 downto 0));
end MOD12;

architecture ARCH of MOD12 is
    component DFF1
        port(CL, CK, T: in std_logic;
             Q, Qbar: out std_logic);
    end component;
	 signal CL: std_logic;
    signal TMP1: std_logic_vector(4 downto 0);
    signal TMP2: std_logic_vector(3 downto 0);
begin
    TMP1(0) <= PulseIn;
    LP1: for I in 0 to 3 generate
        U: DFF1 port map (CL, TMP1(I), '1', TMP2(I), TMP1(I+1));
    end generate;
    CL <= TMP2(3) and TMP2(2);
    Q <= TMP2;
end ARCH;            
