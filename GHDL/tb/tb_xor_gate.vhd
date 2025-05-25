-- ============================================================================
-- Title       : xor gate testbench
-- Description : xor gate module testbench to test out GHDL
-- Author      : Yves Goovaerts
-- Created     : 2025/05/24
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use work.tb_utils.all;

entity tb_xor_gate is
end entity;

architecture rtl of tb_xor_gate is

    -- Signals
    signal a, b, c : std_logic := '0';

    file log_file : text open write_mode is "tb_xor_gate_log.txt";
    
    -- Constants
    constant file_path : string := "tb/tb_xor_gate.vhd";

    -- Component
    component xor_gate is
        port (
            a : in std_logic;
            b : in std_logic;
            c : out std_logic
        );
    end component;

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
        log(log_file, "========= Starting Testbench =========", file_path);
        wait for 10 ns;

        -- Going over all possible inputs
        for i in inputs_a'range loop
            test_number := i +1;
            a <= inputs_a(i);
            b <= inputs_b(i);
            expected_output := expected_c(i);
            wait for 10 ns;
            assert_equal(c, expected_output, test_number, log_file, file_path);
        end loop;
            
        -- End of simulation
        a <= '0';
        b <= '0';
        log(log_file, "========= Testbench Completed =========", file_path);
        wait; 
    end process;

end architecture;
