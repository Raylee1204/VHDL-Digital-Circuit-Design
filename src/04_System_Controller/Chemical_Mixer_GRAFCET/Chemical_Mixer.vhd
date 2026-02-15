library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity g0 is
    port(
        clk, rstn, en, L1, L2: in std_logic;
        V1, V2, M: out std_logic;
        y0, y1, y2, y3: out std_logic); --debug用 ，指現在在狀態幾
end g0;
architecture rt1 of g0 is
signal x0, x1, x2, x3: std_logic;
signal W_V1, W_V2, W_M: std_logic;
begin
GRAFCET : process(clk, rstn) --冒號前是標籤註解
begin
    if rstn='0' then x0<='1'; x1<='0'; x2<='0'; x3<='0';
    elsif clk 'event and clk='1' then
        if x0='1' and en='1' then x0<='0'; x1<='1';
        elsif x1='1' and L1='1' then x1<='0'; x2<='1'; x3<='1';
        elsif x2='1' and x3='1' and L2='1' then  x2<='0'; x3<='0'; x0<='1';
        else null;
        end if;
    else null;
    end if;
    end process;
DATA_PATH : process(x0,x1,x2,x3)
    begin
        y0<=x0; y1<=x1; y2<=x2; y3<=x3;
        if x0='1' then W_V1<='0'; W_V2<='0'; W_M<='0';
        end if;
        if x1='1' then W_V1<='1';
        end if;
        if x2='1' then W_M<='1';
        end if;
        if x3='1' then W_v2<='1';
        end if;
        v1<=W_v1; V2<=W_V2; M<=W_M;
    end process;
end rt1;
