import os
import sys
import shutil
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path
from vunit import VUnit

def check_dirs():
    # Ensure report, wave & log output directories exists
    report_dir = Path("vunit_out/reports")
    wave_dir = Path("vunit_out/waves")
    log_dir = Path("vunit_out/logs")
    report_dir.mkdir(parents=True, exist_ok=True)
    wave_dir.mkdir(parents=True, exist_ok=True)
    log_dir.mkdir(parents=True, exist_ok=True)
    return report_dir, wave_dir, log_dir
    
def add_wave_config(lib, wave_dir):
    # Loop over all test benches and add a config with the correct waveform path
    for tb in lib.get_test_benches():
        wave_path = (wave_dir / f"{tb.name}.ghw").resolve()

        tb.add_config(
            name="with_wave",
            sim_options={"ghdl.sim_flags": [f"--wave={wave_path}"]}
        )

def convert_xml(xml_path, html_path):
    # Convert XML report to HTML
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

def copy_logs(log_dir):
    # Copy and rename all generated output.txt log files
    for tb_folder in Path("vunit_out/test_output").iterdir():
        if tb_folder.is_dir():
            for output_file in tb_folder.iterdir():
                if output_file.suffix == ".txt":
                    # Extract the unique name from the folder
                    split_name = tb_folder.name.split('.')
                    unique_name = split_name[1] if len(split_name) > 1 else split_name[0]
                    # Create new file name
                    new_name =  log_dir / f"{unique_name}_{output_file.name}"
                    try:
                        shutil.copy(output_file, new_name)
                        print(f"Copied {output_file} to {new_name}")
                    except Exception as ex:
                        print(f"::error::Failed to copy {output_file}: {ex}")

def github_annotations(xml_path):
    # Parse report and emit GitHub Annotations
    summary_lines = ["## VUnit CI Summary\n"]
    if xml_path.exists():
        tree = ET.parse(xml_path)
        root = tree.getroot()
        total = 0
        failures = 0
        for testcase in root.iter("testcase"):
            name = testcase.get("name")
            classname = testcase.get("classname")
            full_name = f"{classname}.{name}" if classname else name
            total += 1
            if testcase.find("failure") is not None:
                failures += 1
                summary_lines.append(f"- **{full_name}** failed")
            else:
                summary_lines.append(f"- **{full_name}** passed")
        summary_lines.append(f"\n**Result**: {total - failures}/{total} tests passed.")

        summary_lines.insert(1, f"Total tests: {total}, Failures: {failures}")

        # Write the summary to Github Actions
        summary_env = os.getenv("GITHUB_STEP_SUMMARY")
        if summary_env:
            summary_path = Path(summary_env)
            summary_path.write_text("\n".join(summary_lines), encoding="utf-8", newline="\n")
        else:
            print("::warning::GITHUB_STEP_SUMMARY is not set, skipping summary output.")
            print("\n".join(summary_lines))
    else:
        print("::warning::No test report found to generate summary.")

def main():
    report_dir, wave_dir, log_dir = check_dirs()

    # Add xunit-xml argument if not already present
    if not any(arg.startswith("--xunit-xml") for arg in sys.argv):
        sys.argv += ["--xunit-xml", str(report_dir / "vunit_report.xml")]

    # Create VUnit instance by parsing command line arguments
    vu = VUnit.from_argv()

    # Optionally add VUnit's builtin HDL utilities for checking, logging, communication...
    # See http://vunit.github.io/hdl_libraries.html.
    vu.add_vhdl_builtins()

    # Create library 'lib'
    lib = vu.add_library("lib")

    # Add all files ending in .vhd in source & testbench directory to library
    lib.add_source_files("src/*.vhd")
    lib.add_source_files("tb/*.vhd")

    # Add waveforms
    add_wave_config(lib, wave_dir)

    # Run vunit function and get the test report
    tests_passed = vu._main(post_run=lambda **kwargs: None)
    exit_code = 0 if tests_passed else 1

    # Create HTML report
    xml_path = report_dir / "vunit_report.xml"
    html_path = report_dir / "vunit_report.html"
    convert_xml(xml_path, html_path)

    # Copy logs of each tb to have them in the same folder
    copy_logs(log_dir)

    # Create GitHub Annotations
    github_annotations(xml_path)

    # Exit with the earlier given code
    sys.exit(exit_code)

if __name__ == "__main__":
    sys.exit(main())