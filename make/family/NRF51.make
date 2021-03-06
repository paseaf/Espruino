NRF5X=1
NRF5X_SDK=12
NRF5X_SDK_12=1
NRF5X_SDK_PATH=$(ROOT)/targetlibs/nrf5x_12
DEFINES += -DNRF_SD_BLE_API_VERSION=2
SOFTDEVICE        = $(NRF5X_SDK_PATH)/components/softdevice/s130/hex/s130_nrf51_2.0.1_softdevice.hex

# ARCHFLAGS are shared by both CFLAGS and LDFLAGS.
ARCHFLAGS = -mcpu=cortex-m0 -mthumb -mabi=aapcs -mfloat-abi=soft # Use nRF51 makefiles provided in SDK as reference.

# nRF51 specific.
INCLUDE          += -I$(NRF5X_SDK_PATH)/components/softdevice/s130/headers
INCLUDE          += -I$(NRF5X_SDK_PATH)/components/softdevice/s130/headers/nrf51
TARGETSOURCES    += $(NRF5X_SDK_PATH)/components/toolchain/system_nrf51.c
PRECOMPILED_OBJS += $(NRF5X_SDK_PATH)/components/toolchain/gcc/gcc_startup_nrf51.o

DEFINES += -DNRF51 -DNRF51_SERIES -DSWI_DISABLE0 -DSOFTDEVICE_PRESENT -DS130 -DBLE_STACK_SUPPORT_REQD # SoftDevice included by default.
LINKER_RAM:=$(shell python scripts/get_board_info.py $(BOARD) "board.chip['ram']")


ifdef USE_BOOTLOADER
NRF_BOOTLOADER    = $(BOOTLOADER_PROJ_NAME).hex
LINKER_FILE = $(NRF5X_SDK_PATH)/nrf5x_linkers/linker_nrf51_ble_espruino_$(LINKER_RAM).ld
else
LINKER_FILE = $(NRF5X_SDK_PATH)/nrf5x_linkers/linker_nrf51_ble_espruino_$(LINKER_RAM).ld
INCLUDE += -I$(NRF5X_SDK_PATH)/nrf51_config
endif

include make/common/NRF5X.make
