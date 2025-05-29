-- ============================================================================
-- Title       : counter testbench
-- Description : counter module testbench to test out GHDL
-- Author      : Yves Goovaerts
-- Created     : 2025/05/24
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.tb_utils.all;

entity tb_counter is
end entity;

architecture rtl of tb_counter is

    -------------------------------------------------
    -- Constants                                   --
    -------------------------------------------------
    constant file_path : string := "tb/tb_counter.vhd";

    constant clock_period : time := 10 ns;
    constant reset_time   : time := 100 ns;

    constant counter_length : integer := 8;

    -------------------------------------------------
    -- Signals                                     --
    -------------------------------------------------
    signal simulation_finished : boolean := FALSE;

    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    signal counter_result : std_logic_vector(counter_length - 1 downto 0) := (others => '0');

    file log_file : text open write_mode is "tb_counter_log.txt";
    
begin

    -------------------------------------------------
    -- Clock Generation                            --
    -------------------------------------------------
    process
    begin
        generate_clock(clock, clock_period, simulation_finished);
    end process;

    -------------------------------------------------
    -- Reset Generation                            --
    -------------------------------------------------
    process
    begin
        generate_reset(reset, reset_time);
    end process;

    -------------------------------------------------
    -- UUT (Unit Under Test) Instantiation         --
    -------------------------------------------------
    uut : entity work.counter
        generic map(
            counter_length => counter_length
        )
        port map(
            -- Clocking & Reset
            clk           => clock,
            rst           => reset,
            -- Input
            rst_value     => (others => '0'),
            -- Output
            counter_value => counter_result
        );

    -------------------------------------------------
    -- Test Procedure                              --
    -------------------------------------------------
    test_procedure : process
            variable expected : std_logic_vector(counter_length - 1 downto 0);
    begin
        log(log_file, "========= Starting Testbench =========", file_path);

        -- Wait for reset to finish
        wait for reset_time;

        -- Check that the counter is incremeting correctly (all options)
        for i in 0 to 2**counter_length loop
            expected := std_logic_vector(to_unsigned((i + 1) mod 2**counter_length, expected'length));
            wait for clock_period;
            assert_equal(counter_result, expected, i, log_file, file_path);
        end loop;

        -- End of simulation
        log(log_file, "========= Testbench Completed =========", file_path);
        simulation_finished <= TRUE;
        wait;
    end process;

end architecture;
