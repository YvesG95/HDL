-- ============================================================================
-- Title       : Hello world GHDL
-- Description : GHDL hello world
-- Author      : Yves Goovaerts
-- Created     : 2025/05/24
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity hello is
end;

architecture behavior of hello is
begin
  process
  begin
    report "Hello world";
    wait;
  end process;
end;