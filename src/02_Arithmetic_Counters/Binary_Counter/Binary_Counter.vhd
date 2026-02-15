library IEEE;
use IEEE.std_logic_1164.all;

entity UDC_4B is
    port(CL, UD, PulseIn: in std_logic;
         Q: out std_logic_vector(3 downto 0));
end UDC_4B;

architecture ARCH of UDC_4B is
    component DFF1
        port(CL, CK, T: in std_logic;
             Q, Qbar: out std_logic);
    end component;
    signal TMP: std_logic_vector(4 downto 0);
begin
    TMP(0) <= PulseIn;
    LP1: for I in 0 to 3 generate
        U: DFF1 port map (CL, TMP(I) xor UD, '1', Q(I), TMP(I+1));
    end generate;
end ARCH;            
