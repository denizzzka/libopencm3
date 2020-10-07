project('libopencm3', 'c')

lib_filename = 'libopencm3_stm32f1.a'

includes = include_directories(
    './include'
)

sources = files(
  'lib/cm3/vector.c',
  'lib/stm32/f1/gpio.c',
  'lib/stm32/f1/rtc.c',
)

libopencm3_dep = declare_dependency(
    include_directories: includes,
    sources: sources,
    compile_args: ['-DSTM32F1'],
)
