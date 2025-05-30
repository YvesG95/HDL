import subprocess
from pathlib import Path

report_path = Path("vunit_out/reports")
xml_path = report_path / "vunit_report.xml"
html_path = report_path / "vunit_report.html"

result = subprocess.run([
    "junit2html", 
    str(xml_path), 
    str(html_path),
    ], capture_output=True, text=True
)

print(result.stdout)
print(result.stderr)

if result.returncode == 0:
    print(f"✅ HTML report written to: {html_path}")
else:
    print(f"❌ junit2html failed with exit code {result.returncode}")