project('libopencm3', 'c')

lib_filename = 'libopencm3_stm32f1.a'

includes = include_directories(
    './include'
)

sources = files(
  'lib/cm3/assert.c',
  'lib/cm3/vector.c',
  'lib/stm32/common/flash_common_all.c',
  'lib/stm32/common/gpio_common_all.c',
  'lib/stm32/common/rcc_common_all.c',
  'lib/stm32/common/pwr_common_v1.c',
  'lib/stm32/f1/gpio.c',
  'lib/stm32/f1/rcc.c',
  'lib/stm32/f1/rtc.c',
)

libopencm3_dep = declare_dependency(
    include_directories: includes,
    sources: sources,
    compile_args: ['-DSTM32F1'],
)
