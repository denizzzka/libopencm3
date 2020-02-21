project('libopencm3')

# for ensure what appropriate compiler is installed
__gcc_for_libopencm3_unused = find_program('arm-none-eabi-gcc')

legacy_make = find_program('make')

lib_filename = 'libopencm3_stm32f1.a'

make_all = custom_target('Run makefile',
    command : [legacy_make, '-C', meson.current_source_dir(), 'lib/stm32/f1'],
    output: lib_filename+'_1'
)

cp = find_program('cp')

copied_lib = custom_target('Copy library',
    depends: make_all,
    command : [cp, meson.current_source_dir()+'/lib/'+lib_filename, meson.current_source_dir()],
    output: lib_filename+'_2'
)

_lib = static_library('opencm3_stm32f1')

stm32f1_dep = declare_dependency(
    include_directories: include_directories('./include/'),
    link_with: _lib
)

#ld_script = configure_file
