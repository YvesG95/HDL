-- ============================================================================
-- Title       : simple counter block
-- Description : counter block for more GHDL/TB testing
-- Author      : Yves Goovaerts
-- Created     : 2025/05/29
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    generic(
        counter_length : integer := 8
    );
    port (
        -- Clocking & Reset
        clk           : in std_logic;
        rst           : in std_logic;
        -- Input
        rst_value     : in std_logic_vector(counter_length - 1 downto 0);
        -- Output
        counter_value : out std_logic_vector(counter_length - 1 downto 0)
    );
end entity;

architecture rtl of counter is

    -------------------------------------------------
    -- Constants                                   --
    -------------------------------------------------

    -------------------------------------------------
    -- Signals                                     --
    -------------------------------------------------
    -- Counter
    signal internal_counter : unsigned(counter_length - 1 downto 0) := (others => '0');

begin

    -------------------------------------------------
    -- Counter                                     --
    -------------------------------------------------
    counter_i : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                internal_counter <= unsigned(rst_value);
            else
                internal_counter <= internal_counter + 1;
            end if;
        end if;
    end process;

    counter_value <= std_logic_vector(internal_counter);

end architecture;
