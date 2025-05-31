-- ============================================================================
-- Title       : xor gate testbench
-- Description : xor gate module testbench to test out VUnit
-- Author      : Yves Goovaerts
-- Created     : 2025/05/31
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- VUnit library
library vunit_lib;
context vunit_lib.vunit_context;

entity tb_xor_gate is
    generic (runner_cfg : string);
end entity;

architecture tb of tb_xor_gate is

    -------------------------------------------------
    -- Signals                                     --
    -------------------------------------------------
    signal a, b, c : std_logic := '0';

begin

    -------------------------------------------------
    -- UUT (Unit Under Test) Instantiation         --
    -------------------------------------------------
    uut : entity work.xor_gate
        port map(
            a => a,
            b => b,
            c => c
        );

    -------------------------------------------------
    -- Test Procedure                              --
    -------------------------------------------------
    test_procedure : process
        variable test_number     : integer   := 0;
        variable expected_output : std_logic := '0';
    begin
        test_runner_setup(runner, runner_cfg);

        -- Test 0 xor 0 = 0
        a <= '0'; 
        b <= '0';
        wait for 10 ns;
        check_equal(c, '0', "0 xor 0 should be 0");

        -- Test 0 xor 1 = 1
        a <= '0'; 
        b <= '1';
        wait for 10 ns;
        check_equal(c, '1', "0 xor 1 should be 1");

        -- Test 1 xor 0 = 1
        a <= '1'; 
        b <= '0';
        wait for 10 ns;
        check_equal(c, '1', "1 xor 0 should be 1");

        -- Test 1 xor 1 = 0
        a <= '1'; 
        b <= '1';
        wait for 10 ns;
        check_equal(c, '0', "1 xor 1 should be 0");

        -- End of simulation, letting it run a bit longer to see the result of the last test
        wait for 10 ns;

        test_runner_cleanup(runner);
        wait; 
    end process;

end architecture;
