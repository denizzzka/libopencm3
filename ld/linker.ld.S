/*
 * This file is part of the libopencm3 project.
 *
 * Copyright (C) 2009 Uwe Hermann <uwe@hermann-uwe.de>
 * Copyright (C) 2013 Frantisek Burian <BuFran@seznam.cz>
 *
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 */

/* Generic linker script for all targets using libopencm3. */

/* Enforce emmition of the vector table. */
EXTERN(vector_table)

/* Define the entry point of the output file. */
ENTRY(reset_handler)

/* Define memory regions. */
MEMORY
{
	/* RAM is always used */
	ram (rwx) : ORIGIN = _RAM_OFF, LENGTH = _RAM

#if defined(_ROM)
	rom (rx) : ORIGIN = _ROM_OFF, LENGTH = _ROM
#endif
#if defined(_ROM1)
	rom1 (rx) : ORIGIN = _ROM1_OFF, LENGTH = _ROM1
#endif
#if defined(_ROM2)
	rom2 (rx) : ORIGIN = _ROM2_OFF, LENGTH = _ROM2
#endif
#if defined(_RAM1)
	ram1 (rwx) : ORIGIN = _RAM1_OFF, LENGTH = _RAM1
#endif
#if defined(_RAM2)
	ram2 (rwx) : ORIGIN = _RAM2_OFF, LENGTH = _RAM2
#endif
#if defined(_RAM3)
	ram3 (rwx) : ORIGIN = _RAM3_OFF, LENGTH = _RAM3
#endif
#if defined(_CCM)
	ccm (rwx) : ORIGIN = _CCM_OFF, LENGTH = _CCM
#endif
#if defined(_EEP)
	eep (r) : ORIGIN = _EEP_OFF, LENGTH = _EEP
#endif
#if defined(_XSRAM)
	xsram (rw) : ORIGIN = _XSRAM_OFF, LENGTH = _XSRAM
#endif
#if defined(_XDRAM)
	xdram (rw) : ORIGIN = _XDRAM_OFF, LENGTH = _XDRAM
#endif
#if defined(_NFCRAM)
	nfcram (rw) : ORIGIN _NFCRAM_OFF, LENGTH = _NFCRAM
#endif
}

/* Define sections. */
SECTIONS
{
	.text : {
		*(.vectors)	/* Vector table */
		*(.text*)	/* Program code */
		. = ALIGN(4);
		*(.rodata*)	/* Read-only data */
		. = ALIGN(4);
	} >rom

	/* C++ Static constructors/destructors, also used for
	 * __attribute__((constructor)) and the likes.
	 */
	.preinit_array : {
		. = ALIGN(4);
		__preinit_array_start = .;
		KEEP (*(.preinit_array))
		__preinit_array_end = .;
	} >rom
	.init_array : {
		. = ALIGN(4);
		__init_array_start = .;
		KEEP (*(SORT(.init_array.*)))
		KEEP (*(.init_array))
		__init_array_end = .;
	} >rom
	.fini_array : {
		. = ALIGN(4);
		__fini_array_start = .;
		KEEP (*(.fini_array))
		KEEP (*(SORT(.fini_array.*)))
		__fini_array_end = .;
	} >rom

	/*
	 * Another section used by C++ stuff, appears when using newlib with
	 * 64bit (long long) printf support
	 */
	.ARM.extab : {
		*(.ARM.extab*)
	} >rom
	.ARM.exidx : {
		__exidx_start = .;
		*(.ARM.exidx*)
		__exidx_end = .;
	} >rom

	. = ALIGN(4);
	_etext = .;

	.data : {
		_data = .;
		*(.data*)	/* Read-write initialized data */
		. = ALIGN(4);
		_edata = .;
	} >ram AT >rom
	_data_loadaddr = LOADADDR(.data);

	/* Thread local initialized data. This gets
	 * space allocated as it is expected to be placed
	 * in ram to be used as a template for TLS data blocks
	 * allocated at runtime. We're slightly abusing that
	 * by placing the data in flash where it will be copied
	 * into the allocate ram addresses by the existing
	 * data initialization code in crt0
	 */
	.tdata : {
		PROVIDE( __tls_base = .);
		*(.tdata .tdata.* .gnu.linkonce.td.*)
		PROVIDE(__data_end = .);
	} >ram AT>rom :tls :ram_init
	PROVIDE( __tdata_source = LOADADDR(.tdata) );
	PROVIDE( __tdata_size = SIZEOF(.tdata) );

	PROVIDE( __edata = __data_end );
	PROVIDE( _edata = __data_end );
	PROVIDE( edata = __data_end );
	PROVIDE( __data_size = __data_end - __data_start );

	.tbss : {
		PROVIDE( __bss_start = . );
		*(.tbss .tbss.* .gnu.linkonce.tb.*)
		*(.tcommon)
		PROVIDE( __tls_end = . );
	} >ram AT>ram :tls :ram
	PROVIDE( __tbss_size = SIZEOF(.tbss) );
	PROVIDE( __tls_size = __tls_end - __tls_base );

	.bss : {
		*(.bss*)	/* Read-write zero initialized data */
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
	} >ram

#if defined(_CCM)
	.ccm : {
		*(.ccmram*)
		. = ALIGN(4);
	} >ccm
#endif

#if defined(_RAM1)
	.ram1 : {
		*(.ram1*)
		. = ALIGN(4);
	} >ram1
#endif

#if defined(_RAM2)
	.ram2 : {
		*(.ram2*)
		. = ALIGN(4);
	} >ram2
#endif

#if defined(_RAM3)
	.ram3 : {
		*(.ram3*)
		. = ALIGN(4);
	} >ram3
#endif

#if defined(_XSRAM)
	.xsram : {
		*(.xsram*)
		. = ALIGN(4);
	} >xsram
#endif

#if defined(_XDRAM)
	.xdram : {
		*(.xdram*)
		. = ALIGN(4);
	} >xdram
#endif

#if defined(_NFCRAM)
	.nfcram : {
		*(.nfcram*)
		. = ALIGN(4);
	} >nfcram
#endif

	.eh_frame : { *(.eh_frame) }

	. = ALIGN(4);
	end = .;
}

PROVIDE(_stack = ORIGIN(ram) + LENGTH(ram));

/* Need for picolibc: */
__bss_start__ = ADDR(.bss);
PROVIDE(__bss_end__ = _ebss);
PROVIDE(__bss_end = __bss_end__);

/* copied from picolibc.ld: */
	PROVIDE( __end = __bss_end );
	PROVIDE( _end = __bss_end );
	PROVIDE( end = __bss_end );
	PROVIDE(__bss_size = __bss_end - __bss_start);

	/* Make the rest of memory available for heap storage */
	PROVIDE( __heap_start = __end );
	PROVIDE( __heap_end = ORIGIN(ram) + LENGTH(ram) - 0x800 /* stack size */);
	PROVIDE( __heap_size = __heap_end - __bss_end );
