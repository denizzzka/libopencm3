# Usage:
# $ make -f mk/generate-ldscript.mk generate DEVICE=stm32f103x8 OPENCM3_DIR=.
# $ make -f mk/generate-ldscript.mk clean DEVICE=stm32f103x8 OPENCM3_DIR=.

include $(OPENCM3_DIR)/mk/genlink-config.mk
include $(OPENCM3_DIR)/mk/gcc-config.mk
include $(OPENCM3_DIR)/mk/genlink-rules.mk

generate: $(LDSCRIPT)
	mv $(LDSCRIPT) $(RENAME_TO)

clean:
	$(Q)$(RM) -rf generated.ld
