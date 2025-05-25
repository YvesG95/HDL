# GHDL
[Official Documentation](https://ghdl-rad.readthedocs.io/en/stable/about.html)

## Install 
Latest releases can be found on [GHDL GitHub Releases page](https://github.com/ghdl/ghdl/releases).

1. Download the Windows release from the link above (`ghdl-mcode-6.0.0-dev-ucrt64`).
2. Unzip to `C:\ghdl`.
3. Add the `C:\ghdl\bin` folder to your system's PATH (environment variables).
4. Verify installation by running: `ghdl --version`

> On Linux, install with your package manager: `sudo apt install ghdl` (Debian/Ubuntu).

## First simulation: Hello World 

### Step 1: Analyze the VHDL file
This compiles the VHDL source into an intermediate format.
 
    ghdl -a hello.vhd

### Step 2: Elaborate the design
This builds the executable simulation model from the design hierarchy.

    ghdl -e hello

### Step 3: Run the simulation
This executes the elaborated design.

    ghdl -r hello

    
### Expected output

    hello.vhd:18:5:@0ms:(report note): Hello world