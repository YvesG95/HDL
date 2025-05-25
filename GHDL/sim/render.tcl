# render.tcl
# This script requires argv[1] to be the output path

if {[llength $argv] < 2} {
    puts "Usage: gtkwave waveform.ghw layout.gtkw --script render.tcl output.png"
    exit
}

set outfile [lindex $argv 1]
update
puts "Writing to $outfile"
writeWindowToFile $outfile
exit