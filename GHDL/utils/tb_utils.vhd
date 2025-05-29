-- ============================================================================
-- Title       : Testbench utils package
-- Description : Package that contains procedures used only during testbench
-- Author      : Yves Goovaerts
-- Created     : 2025/05/25
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

package tb_utils is
    procedure log(
        file f  : text;
        message : in string;
        path    : in string
    );

    procedure assert_equal(
        actual         : std_logic;
        expected       : std_logic;
        test_id        : integer;
        file f         : text;
        path           : string;
        severity_level : severity_level := error
    );

    procedure assert_equal(
        actual         : std_logic_vector;
        expected       : std_logic_vector;
        test_id        : integer;
        file f         : text;
        path           : string;
        severity_level : severity_level := error
    );

    procedure generate_clock(
        signal clk         : out std_logic;
        constant period_ns : time;
        signal sim_done    : in boolean
    );

    procedure generate_reset(
        signal rst        : out std_logic;
        constant rst_time : time
    );
end package;

package body tb_utils is
    procedure log(
        file f  : text;
        message : in string;
        path    : in string
    ) is
        variable l : line;
        variable time_ns : integer := integer(now / 1 ns);
    begin
        write(l, "[" & integer'image(time_ns) & " ns] [" & path & "] " & message);
        writeline(f, l);
    end procedure;

    procedure assert_equal(
        actual         : std_logic;
        expected       : std_logic;
        test_id        : integer;
        file f         : text;
        path           : string;
        severity_level : severity_level := error
    ) is
    begin
        if actual /= expected then
            log(f, "Test " & integer'image(test_id) & ": FAIL - expected " & std_logic'image(expected) & ", got " & std_logic'image(actual), path);
            assert false report "Test " & integer'image(test_id) & ": Assertion failed" severity severity_level;
        else
            log(f, "Test " & integer'image(test_id) & ": PASS", path);
        end if;
    end procedure;    

    procedure assert_equal(
        actual         : std_logic_vector;
        expected       : std_logic_vector;
        test_id        : integer;
        file f         : text;
        path           : string;
        severity_level : severity_level := error
    ) is
        variable actual_str   : string(1 to expected'length);
        variable expected_str : string(1 to expected'length);
    begin
        -- First check that the ranges are equal
        assert actual'length = expected'length report "Test " & integer'image(test_id) & ": Length mismatch: actual = " & integer'image(actual'length) & ", expected = " & integer'image(expected'length) severity failure;

        -- Convert to string for logging
        for i in expected'range loop
            expected_str(i - expected'low + 1) := std_logic'image(expected(i))(2);
            actual_str(i - actual'low + 1) := std_logic'image(actual(i))(2);
        end loop;

        if actual /= expected then
            log(f, "Test " & integer'image(test_id) & ": FAIL - expected " & expected_str & ", got " & actual_str, path);
            assert false report "Test " & integer'image(test_id) & ": Assertion failed" severity severity_level;
        else
            log(f, "Test " & integer'image(test_id) & ": PASS", path);
        end if;
    end procedure; 

    procedure generate_clock(
        signal clk         : out std_logic;
        constant period_ns : time;
        signal sim_done    : in boolean
    ) is
    begin
        loop
            if sim_done then
                exit;
            end if;
            clk <= '0';
            wait for period_ns / 2;

            if sim_done then
                exit;
            end if;
            clk <= '1';
            wait for period_ns / 2;
        end loop;
        wait;
    end procedure;

    procedure generate_reset(
        signal rst        : out std_logic;
        constant rst_time : time
    ) is
    begin
        rst <= '1';
        wait for rst_time;
        rst <= '0';
        wait;
    end procedure;
end package body;
