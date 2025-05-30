import sys
import subprocess
from pathlib import Path
from vunit import VUnit

# Ensure report directory exists
report_path = Path("vunit_out/reports")
report_path.mkdir(parents=True, exist_ok=True)

# Add xunit-xml argument if not already present
if not any(arg.startswith("--xunit-xml") for arg in sys.argv):
    sys.argv += ["--xunit-xml", str(report_path / "vunit_report.xml")]

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

# Optionally add VUnit's builtin HDL utilities for checking, logging, communication...
# See http://vunit.github.io/hdl_libraries.html.
vu.add_vhdl_builtins()
# or
# vu.add_verilog_builtins()

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("tb/*.vhd")

# Run vunit function
vu.main()