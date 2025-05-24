-- ============================================================================
-- Title       : xor gate testbench
-- Description : xor gate module testbench to test out GHDL
-- Author      : Yves Goovaerts
-- Created     : 2025/05/24
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

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

    -- Logging
    file log_file : text open write_mode is "tb_xor_gate_log.txt";

    procedure log(message : in string) is
        variable log_line : line;
        variable time_ns  : integer;
    begin
        time_ns := integer(now / 1 ns);
        write(log_line, "[" & integer'image(time_ns) & " ns] " & message);
        writeline(log_file, log_line);
    end procedure;

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
        variable all_passed      : boolean   := TRUE;
        variable test_number     : integer   := 0;
        variable expected_output : std_logic := '0';
    begin
        -- Test 00 (0)
        test_number := test_number + 1;
        a <= '0';
        b <= '0';
        expected_output := '0';
        wait for 10 ns;

        if c /= expected_output then
            log("Test " & integer'image(test_number) & ": FAIL: A=" & std_logic'image(a) & ", B=" & std_logic'image(b) & ", expected C=" & std_logic'image(expected_output) & ", result C=" & std_logic'image(c));
            all_passed := FALSE;
        end if;
        
        -- Test 01 (1)
        test_number := test_number + 1;
        a <= '0';
        b <= '1';
        expected_output := '1';
        wait for 10 ns;

        if c /= expected_output then
            log("Test " & integer'image(test_number) & ": FAIL: A=" & std_logic'image(a) & ", B=" & std_logic'image(b) & ", expected C=" & std_logic'image(expected_output) & ", result C=" & std_logic'image(c));
            all_passed := FALSE;
        end if;

        -- Test 10 (1)
        test_number := test_number + 1;
        a <= '1';
        b <= '0';
        expected_output := '1';
        wait for 10 ns;

        if c /= expected_output then
            log("Test " & integer'image(test_number) & ": FAIL: A=" & std_logic'image(a) & ", B=" & std_logic'image(b) & ", expected C=" & std_logic'image(expected_output) & ", result C=" & std_logic'image(c));
            all_passed := FALSE;
        end if;

        -- Test 11 (0)
        test_number := test_number + 1;
        a <= '1';
        b <= '1';
        expected_output := '0';
        wait for 10 ns;

        if c /= expected_output then
            log("Test " & integer'image(test_number) & ": FAIL: A=" & std_logic'image(a) & ", B=" & std_logic'image(b) & ", expected C=" & std_logic'image(expected_output) & ", result C=" & std_logic'image(c));
            all_passed := FALSE;
        end if;

        if all_passed then
            log("All tests passed.");
        else
            log("One or more tests failed.");
            assert false report "One or more tests failed, see log." severity error; -- GHDL return a non-zero exit code
        end if;

        -- End of simulation
        a <= '0';
        b <= '0';
        log("Testbench completed.");
        wait; 
    end process;

end architecture;
