library IEEE;
use IEEE.std_logic_1164.all;
entity MUX8_1 is
    port(
        S: in std_logic_vector(2 downto 0);
        A: in std_logic_vector(7 downto 0);
        Y: out std_logic);
end MUX8_1;

architecture ARCH of MUX8_1 is
begin
    with S select
    Y <= A(0) when "000",
         A(1) when "001",
         A(2) when "010",
         A(3) when "011",
         A(4) when "100",
         A(5) when "101",
         A(6) when "110",
         A(7) when others;
end ARCH;
