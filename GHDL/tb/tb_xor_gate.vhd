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

    file log_file : text open write_mode is "tb_xor_gate_log.txt";

    -- Component
    component xor_gate is
        port (
            a : in std_logic;
            b : in std_logic;
            c : out std_logic
        );
    end component;

    -- Procedures
    procedure log(message : in string) is
        variable log_line : line;
        variable time_ns  : integer;
    begin
        time_ns := integer(now / 1 ns);
        write(log_line, "[" & integer'image(time_ns) & " ns] " & message);
        writeline(log_file, log_line);
    end procedure;

    procedure check_result(
        signal sig_a : std_logic; 
        signal sig_b : std_logic;
        signal sig_c : std_logic;
        variable var_expected : std_logic; 
        variable var_test_id  : integer
    ) is
    begin
        if sig_c /= var_expected then
            log("Test " & integer'image(var_test_id) & ": FAIL: A=" & std_logic'image(sig_a) & ", B=" & std_logic'image(sig_b) & ", expected C=" & std_logic'image(var_expected) & ", result C=" & std_logic'image(sig_c));
            assert false report "Test " & integer'image(var_test_id) & ": XOR failed" severity error;
        end if;
    end procedure;

    -- Test inputs
    type test_array is array (natural range <>) of std_logic;
    constant inputs_a   : test_array := ('0', '0', '1', '1');
    constant inputs_b   : test_array := ('0', '1', '0', '1');
    constant expected_c : test_array := ('0', '1', '1', '0');

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
    test_procedure : process
        variable test_number     : integer   := 0;
        variable expected_output : std_logic := '0';
    begin
        log("========= Starting Testbench =========");
        wait for 10 ns;
        
        -- Going over all possible inputs
        for i in inputs_a'range loop
            test_number := i +1;
            a <= inputs_a(i);
            b <= inputs_b(i);
            expected_output := expected_c(i);
            wait for 10 ns;
            check_result(a, b, c, expected_output, test_number);
        end loop;
            
        -- End of simulation
        a <= '0';
        b <= '0';
        log("========= Testbench Completed =========");
        wait; 
    end process;

end architecture;
