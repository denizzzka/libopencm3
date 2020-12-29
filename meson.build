project('libopencm3', 'c')

lib_filename = 'libopencm3_stm32f1.a'

includes = include_directories(
    './include'
)

sources = files(
  'lib/cm3/assert.c',
  'lib/cm3/scb.c',
  'lib/cm3/systick.c',
  'lib/cm3/vector.c',
  'lib/stm32/common/flash_common_all.c',
  'lib/stm32/common/gpio_common_all.c',
  'lib/stm32/common/rcc_common_all.c',
  'lib/stm32/common/pwr_common_v1.c',
  'lib/stm32/common/spi_common_all.c',
  'lib/stm32/common/spi_common_v1.c',
)

for_f1 = files(
  'lib/stm32/f1/gpio.c',
  'lib/stm32/f1/rcc.c',
  'lib/stm32/f1/rtc.c',
)

for_f4 = files(
  'lib/stm32/common/gpio_common_f0234.c',
  'lib/stm32/f4/rcc.c',
  'lib/stm32/f4/rtc.c',
)

libopencm3_dep = declare_dependency(
    include_directories: includes,
    sources: [
      sources,
      for_f4,
    ],
    #compile_args: ['-DSTM32F1'],
    compile_args: ['-DSTM32F4'],
)
