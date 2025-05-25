# HDL
This repository contains hardware description language (HDL) projects, examples, and infrastructure for digital design and simulation. It provides a structured environment for working with VHDL, with an emphasis on simulation using GHDL.

## Folder Structure
* GHDL/ – GHDL-based simulation framework
    * build/ – Output folder for logs and waveforms
    * sim/ – Automation scripts for GHDL simulation
    * src/ – VHDL source files
    * tb/ – Testbenches
    * utils/ – Utility VHDL code
    * README.md – Instructions for using GHDL
* README.md – Top-level repository overview (this file)

## Features
* Organized VHDL development environment
* Automated testbench compilation and simulation with GHDL
* Compatible with GTKWave for waveform viewing
* CI-ready (GitHub Actions support in progress)
* Clear separation of testbenches, utilities, and core design files

## Getting Started
See the GHDL/ folder for:
* Installation and setup instructions
* A "Hello World" VHDL simulation example
* Details on how to run testbenches using the run.sh automation script

## Future Plans
* Expand testbench libraries using UVVM or VUnit
* Set up a Vivado environment for synthesis and FPGA workflows