set dumpfile [lindex $argv 0]
set outfile [lindex $argv 1]
loadFile $dumpfile
writeImage $outfile
exit