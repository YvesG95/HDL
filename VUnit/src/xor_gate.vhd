-- ============================================================================
-- Title       : xor gate
-- Description : xor gate module to test out VUnit
-- Author      : Yves Goovaerts
-- Created     : 2025/05/31
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity xor_gate is
    port (
        a : in  std_logic;  
        b : in  std_logic;
        c : out std_logic
    );
end entity;

architecture rtl of xor_gate is

begin

    c <= a xor b;

end architecture;
