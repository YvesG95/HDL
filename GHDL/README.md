# GHDL
https://ghdl-rad.readthedocs.io/en/stable/about.html

## Install 
Latest releases can be found on: https://github.com/ghdl/ghdl/releases

    1) Download Windows release from above link (ghdl-mcode-6.0.0-dev-ucrt64)
    2) Unzip to C:\ghdl
    3) Add bin folder (C:\ghdl\bin) to environment variables

Can be tested out by opening command line and running:
    
    ghdl --version

## Hello world 

In the example folder is a hello.vhd file containing a hello module to test out GHDL.

Run the following commands to use GHDL on the hello.vhd file.

Analysis of a design file in VHDL terms (hello.vhd)
 
    ghdl -a hello.vhd

Elaborate a design with the given entity name (hello) as top of the hierarchy

    ghdl -e hello

Launch the simulation with the given entity name (hello)

    ghdl -r hello

    
Expected output:

    hello.vhd:18:5:@0ms:(report note): Hello world