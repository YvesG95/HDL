import sys
import subprocess
import xml.etree.ElementTree as ET
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

# Run vunit function and get the test report
tests_passed = vu._main(post_run=lambda **kwargs: None)
exit_code = 0 if tests_passed else 1

# Convert XML report to HTML
xml_path = report_path / "vunit_report.xml"
html_path = report_path / "vunit_report.html"

result = subprocess.run([
    "junit2html", 
    str(xml_path), 
    str(html_path),
    ], capture_output=True, text=True
)

if result.returncode == 0:
    print(f"HTML report written to: {html_path}")
else:
    print(f"junit2html failed with exit code {result.returncode}")

# Parse report and emit GitHub Annotations
if xml_path.exists():
    tree = ET.parse(xml_path)
    root = tree.getroot()
    for testcase in root.iter("testcase"):
        if testcase.find("failure") is not None:
            name = testcase.get("name")
            classname = testcase.get("classname")
            full_name = f"{classname}.{name}" if classname else name
            print(f"::error title=Test Failure::Test '{full_name}' failed")

# Exit with the earlier given code
sys.exit(exit_code)