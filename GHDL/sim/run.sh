#!/bin/bash

# Detect if the script is running on Linux system
IS_LINUX=false
if [[ "$(uname -s)" == "Linux" ]]; then
    IS_LINUX=true
fi

# -----------------------------
# GHDL VHDL Automation Script
# -----------------------------
set -e  # Exit on any error

# Define variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/../src"
TB_DIR="$SCRIPT_DIR/../tb"
BUILD_DIR="$SCRIPT_DIR/../build"
LOG_DIR="$BUILD_DIR/logs"
WAVE_DIR="$BUILD_DIR/waves"

# Checking for --render in arguments
RENDER=false
for arg in "$@"; do
    if [[ "$arg" == "--render" ]]; then
        RENDER=true
        break;
    fi
done

# Create build, log and wave directory
mkdir -p "$BUILD_DIR"
mkdir -p "$LOG_DIR"
mkdir -p "$WAVE_DIR"
cd "$BUILD_DIR"

# Analyze all source files
echo "Analyzing VHDL sources..."
ghdl -a "$SRC_DIR"/*.vhd

# Run all testbenches
for tb_file in ../tb/tb_*.vhd; do
    tb_name=$(basename "$tb_file" .vhd)

    echo "Compiling  testbench: $tb_name"
    ghdl -a "$tb_file"
    ghdl -e "$tb_name"

    echo "Running testbench: $tb_name"
    wave_file="$WAVE_DIR/${tb_name}.ghw"
    if ghdl -r "$tb_name" --wave="$wave_file"; then
        echo "Testbench $tb_name passed"
    else
        echo "Testbench $tb_name failed"
    fi

    # Handle the log file
    src_log="${tb_name}_log.txt"
    if [[ -f "$src_log" ]]; then
        timestamp=$(date +%Y%m%d_%H%M%S)
        mv "$src_log" "$LOG_DIR/${tb_name}_${timestamp}.log"
    else
        echo "Warning: Log file $src_log not found."
    fi

    # Generate waveform preview
    if $RENDER && [[ -f "$wave_file" ]] && $IS_LINUX; then
        echo "Generating waveform preview..."
        gtkw_file="$TB_DIR/${tb_name}.gtkw"
        png_file="$WAVE_DIR/${tb_name}.png"
        xvfb-run gtkwave "$wave_file" "$gtkw_file" --script "$SCRIPT_DIR/render.tcl" "$png_file"
    fi
done