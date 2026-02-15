library IEEE;
use IEEE.std_logic_1164.all;
entity DeMux1_8 is
    port(
        S: in std_logic_vector(2 downto 0);
        A: in std_logic;
        Y: out std_logic_vector(7 downto 0));
end DeMux1_8;

architecture ARCH of DeMux1_8 is
begin
    Y(0) <= A when S = "000" else 'Z';
    Y(1) <= A when S = "001" else 'Z';
    Y(2) <= A when S = "010" else 'Z';
    Y(3) <= A when S = "011" else 'Z';
    Y(4) <= A when S = "100" else 'Z';
    Y(5) <= A when S = "101" else 'Z';
    Y(6) <= A when S = "110" else 'Z';
    Y(7) <= A when S = "111" else 'Z';
end ARCH;
