library IEEE;
use IEEE.std_logic_1164.all;
entity Encoder8_3 is
    port(
        EN: in std_logic;
        A: in std_logic_vector(7 downto 0);
        Y: out std_logic_vector(2 downto 0));
end Encoder8_3;

architecture ARCH of Encoder8_3 is
begin
    Y <= "111" when (EN and A(7)) = '1' else
         "110" when (EN and A(6)) = '1' else
         "101" when (EN and A(5)) = '1' else
         "100" when (EN and A(4)) = '1' else
         "011" when (EN and A(3)) = '1' else
         "010" when (EN and A(2)) = '1' else
         "001" when (EN and A(1)) = '1' else
         "000";
end ARCH;
