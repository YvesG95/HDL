-- ============================================================================
-- Title       : xor gate test bench
-- Description : xor gate module test bench to test out GHDL
-- Author      : Yves Goovaerts
-- Created     : 2025/05/24
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity tb_xor_gate is
end entity;

architecture rtl of tb_xor_gate is

    -- Signals
    signal a, b, c : std_logic := '0';

    -- Component
    component xor_gate is
        port (
            a : in std_logic;
            b : in std_logic;
            c : out std_logic
        );
    end component;

begin

    -- Instantiate the xor_gate module
    -- UUT = unit under test
    uut : xor_gate
        port map(
            a => a,
            b => b,
            c => c
        );

    -- Test procedure
    process
        variable test_failed : boolean := FALSE;
    begin
        -- Test 00 (0)
        a <= '0';
        b <= '0';
        wait for 10 ns;

        if c /= '0' then
            report "0 xor 0 failed" severity error;
            test_failed := TRUE;
        end if;
        
        -- Test 01 (1)
        a <= '0';
        b <= '1';
        wait for 10 ns;

        if c /= '1' then
            report "0 xor 0 failed" severity error;
            test_failed := TRUE;
        end if;

        -- Test 10 (1)
        a <= '1';
        b <= '0';
        wait for 10 ns;

        if c /= '1' then
            report "0 xor 0 failed" severity error;
            test_failed := TRUE;
        end if;

        -- Test 11 (0)
        a <= '1';
        b <= '1';
        wait for 10 ns;

        if c /= '0' then
            report "0 xor 0 failed" severity error;
            test_failed := TRUE;
        end if;

        -- Check if the test has failed or not
        if test_failed then
            report "One or more xor tests failed!" severity warning;
        else
            report "ALL xor tests passed!" severity note;
        end if;

        -- End of simulation
        wait; 
    end process;

end architecture;
