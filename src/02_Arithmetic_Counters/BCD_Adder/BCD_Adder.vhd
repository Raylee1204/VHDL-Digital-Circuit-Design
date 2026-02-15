library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity BCDadder is
    port(A, B: in integer range 0 to 99;
         Y2, Y1, Y0: out std_logic_vector(3 downto 0));
end BCDadder;

architecture ARCH of BCDadder is
begin
    process(A, B)
        variable Sum:integer range 0 to 200;
        variable Output:std_logic_vector(3 downto 0);
        variable TMP:integer range 0 to 9;
    begin
        Sum := A+B;
        TMP := Sum rem 10;
        Dig0: for I in 0 to 3 loop
            if ((TMP mod 2)=1) Then Output(I):= '1';
            else Output(I):='0';
            end if;
            TMP := TMP/2;
        end loop;
        Y0 <= Output;
        TMP := (Sum/10) rem 10;
        Dig1: for I in 0 to 3 loop
            if ((TMP mod 2)=1) Then Output(I):= '1';
            else Output(I):='0';
            end if;
            TMP := TMP/2;
        end loop;
        Y1 <= Output;
        TMP := Sum/100;
        Dig2: for I in 0 to 3 loop
            if ((TMP mod 2)=1) Then Output(I):= '1';
            else Output(I):='0';
            end if;
            TMP := TMP/2;
        end loop;
        Y2 <= Output;
    end process;
end ARCH;            
