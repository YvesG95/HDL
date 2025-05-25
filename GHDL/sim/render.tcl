# render.tcl
set filename [lindex $argv 0]
set output [lindex $argv 1]
puts "Rendering waveform to $output"
loadFile $filename
update
writeCanvas $output
exit