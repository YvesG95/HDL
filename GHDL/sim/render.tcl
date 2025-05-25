set filename [lindex $tcl_args 0]
set output   [lindex $tcl_args 1]

puts "Rendering waveform $filename to $output"
loadFile $filename
update
writeCanvas $output
exit