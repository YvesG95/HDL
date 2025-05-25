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
end package body;
