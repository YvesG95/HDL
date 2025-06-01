# VUnit Test Suite

![VUnit Tests](https://github.com/YvesGoo/HDL/actions/workflows/vunit.yml/badge.svg)

This repository uses [VUnit](https://vunit.github.io) for automated testing of VHDL designs.

## Running Tests Locally

### Prerequisites

- Python 3.6 or higher
- [GHDL](https://ghdl.github.io/)
- VUnit Python package: install with
  ```bash
  pip install vunit_hdl
  ```
- junit2html (for HTML reports):
  ```bash
  pip install junit2htmlreport
  ```
- Optional: GTKWave for waveform viewing
  ```bash
  sudo apt install gtkwave
  ```

### Running

Run the test script:

```bash
python run.py
```

This will:

- Compile and simulate all testbenches in `src/` and `tb/`
- Generate waveform files (`*.ghw`) in `vunit_out/waves/`
- Generate test logs in `vunit_out/logs/`
- Produce XML and HTML test reports in `vunit_out/reports/`
- Copy logs and create GitHub annotations if running in CI


## Continuous Integration (CI)

This project includes a GitHub Actions workflow (`.github/workflows/vunit.yml`) that:

- Automatically runs the test suite on each push or pull request
- Publishes the status badge you see above
- Produces detailed test reports and logs accessible via the workflow run artifacts

## Viewing Waveforms

Use GTKWave to open waveform files for detailed simulation analysis:

```bash
gtkwave vunit_out/waves/<testbench_name>.ghw
```

## Additional Information

- The test logs and reports help quickly identify failing tests.
- The script `run.py` contains all commands and hooks to run simulations, generate reports, and integrate with GitHub Actions.