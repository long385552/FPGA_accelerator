onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib Fully_Connected_bram_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {Fully_Connected_bram.udo}

run -all

quit -force
