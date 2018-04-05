LOCAL_PATH := $(call my-dir)

#----------------------------------------------------------------------
# Compile (L)ittle (K)ernel bootloader and the nandwrite utility
#----------------------------------------------------------------------
ifneq ($(strip $(TARGET_NO_BOOTLOADER)),true)

# Compile
include bootable/bootloader/edk2/AndroidBoot.mk

$(INSTALLED_BOOTLOADER_MODULE): $(TARGET_EMMC_BOOTLOADER) | $(ACP)
	$(transform-prebuilt-to-target)
$(BUILT_TARGET_FILES_PACKAGE): $(INSTALLED_BOOTLOADER_MODULE)

droidcore: $(INSTALLED_BOOTLOADER_MODULE)
endif

#----------------------------------------------------------------------
# Compile Linux Kernel
#----------------------------------------------------------------------
ifeq ($(KERNEL_DEFCONFIG),)
ifeq ($(TARGET_KERNEL_VERSION),$(filter $(TARGET_KERNEL_VERSION),4.14 4.19))
   ifeq ($(TARGET_BUILD_VARIANT),user)
     KERNEL_DEFCONFIG := vendor/sdm660-perf_defconfig
   else
     KERNEL_DEFCONFIG := vendor/sdm660_defconfig
   endif
 else
   ifeq ($(TARGET_BUILD_VARIANT),user)
     KERNEL_DEFCONFIG := sdm660-perf_defconfig
   else
     KERNEL_DEFCONFIG := sdm660_defconfig
   endif
endif
endif

ifeq ($(TARGET_KERNEL_SOURCE),)
     TARGET_KERNEL_SOURCE := kernel
endif

# ../../ prepended to paths because kernel is at ./kernel/msm-x.x
TEMP_TOP=$(shell pwd)
ifeq ($(TARGET_KERNEL_VERSION),$(filter $(TARGET_KERNEL_VERSION),4.14 4.19))
  DTC := $(HOST_OUT_EXECUTABLES)/dtc$(HOST_EXECUTABLE_SUFFIX)
  UFDT_APPLY_OVERLAY := $(HOST_OUT_EXECUTABLES)/ufdt_apply_overlay$(HOST_EXECUTABLE_SUFFIX)
  TARGET_KERNEL_MAKE_ENV := DTC_EXT=$(TEMP_TOP)/$(DTC)
  TARGET_KERNEL_MAKE_ENV += DTC_OVERLAY_TEST_EXT=$(TEMP_TOP)/$(UFDT_APPLY_OVERLAY)
  TARGET_KERNEL_MAKE_ENV += CONFIG_BUILD_ARM64_DT_OVERLAY=y
endif
TARGET_KERNEL_MAKE_ENV += HOSTCC=$(TEMP_TOP)/$(SOONG_LLVM_PREBUILTS_PATH)/clang
TARGET_KERNEL_MAKE_ENV += HOSTAR=$(TEMP_TOP)/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/bin/x86_64-linux-ar
TARGET_KERNEL_MAKE_ENV += HOSTLD=$(TEMP_TOP)/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/bin/x86_64-linux-ld

TARGET_KERNEL_MAKE_ENV += HOSTCFLAGS="-I$$(pwd)/kernel/msm-4.19/include/uapi -I/usr/include -I/usr/include/x86_64-linux-gnu -L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld"

GET_KERNEL_MAKE_ENV += HOSTLDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu -fuse-ld=lld"


#Enable llvm support for kernel
KERNEL_LLVM_SUPPORT := true

#Enable sd-llvm suppport for kernel
KERNEL_SD_LLVM_SUPPORT := true



include $(TARGET_KERNEL_SOURCE)/AndroidKernel.mk
ifeq ($(TARGET_KERNEL_VERSION),$(filter $(TARGET_KERNEL_VERSION),4.14 4.19))
  $(TARGET_PREBUILT_KERNEL): $(DTC) $(UFDT_APPLY_OVERLAY)
endif

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)

#----------------------------------------------------------------------
# Copy additional target-specific files
#----------------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE       := vold.fstab
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := init.target_ota.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init/hw
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := fstab.qcom
LOCAL_MODULE_TAGS  := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES    := $(LOCAL_MODULE)
LOCAL_MODULE_PATH  := $(TARGET_OUT_VENDOR_ETC)/init/hw
include $(BUILD_PREBUILT)

#Create dsp directory
$(shell mkdir -p $(TARGET_OUT_VENDOR)/lib/dsp)

# Create symbolic links for msadp
$(shell  mkdir -p $(TARGET_OUT_VENDOR)/firmware; \
	ln -sf /dev/block/bootdevice/by-name/msadp \
	$(TARGET_OUT_VENDOR)/firmware/msadp)

#----------------------------------------------------------------------
# extra images
#----------------------------------------------------------------------
ifneq (, $(wildcard $(shell pwd)/prebuilts/build-tools/linux-x86/bin/make))
    MAKE := $(shell pwd)/prebuilts/build-tools/linux-x86/bin/$(MAKE)
endif
