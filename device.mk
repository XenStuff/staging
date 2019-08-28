 # Get non-open-source specific aspects
$(call inherit-product, vendor/xiaomi/lavender/lavender-vendor.mk)

# Boot animation
TARGET_SCREEN_HEIGHT := 2340
TARGET_SCREEN_WIDTH := 1080

TARGET_SYSTEM_PROP := $(LOCAL_PATH)/system.prop

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
       $(LOCAL_PATH)/overlay

# Audio
PRODUCT_PACKAGES += \
    audiod \
    audio.a2dp.default \
    audio.r_submix.default \
    audio.primary.sdm660 \
    audio.usb.default \
    libaacwrapper \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libvolumelistener \
    libaudio-resampler \
    tinymix

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/configs/audio/audio_output_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_output_policy.conf \
    $(LOCAL_PATH)/configs/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/audio_tuning_mixer.txt:$(TARGET_COPY_OUT_VENDOR)/etc/audio_tuning_mixer.txt \
    $(LOCAL_PATH)/configs/audio/graphite_ipc_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/graphite_ipc_platform_info.xml \
    $(LOCAL_PATH)/configs/audio/listen_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/listen_platform_info.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_platform_info.xml

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Video codec configuration files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/configs/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml \
    $(LOCAL_PATH)/configs/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml \
    $(LOCAL_PATH)/configs/media_codecs_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor.xml

# video seccomp policy files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(LOCAL_PATH)/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy


PRODUCT_PROPERTY_OVERRIDES += \
    vendor.video.disable.ubwc=1

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
     android.hardware.power@1.0-impl

# Ramdisk
PRODUCT_PACKAGES += \
    exfat.rc \
    init.msm.usb.configfs.rc \
    init.qcom.factory.rc \
    init.qcom.rc \
    init.qcom.usb.rc \
    init.target.rc \
    fstab.qcom \
    ueventd.qcom.rc

# privapp-permissions whitelisting
PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

PRODUCT_NAME := sdm660_64
PRODUCT_DEVICE := sdm660_64
PRODUCT_BRAND := qti
PRODUCT_MODEL := sdm660 for arm64

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# 196610 is decimal for 0x30002 to report major/minor versions as 3/2
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610

PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext

USE_LIB_PROCESS_GROUP := true

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf
# Exclude TOF sensor from InputManager
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/excluded-input-devices.xml:system/etc/excluded-input-devices.xml

# ANT+
PRODUCT_PACKAGES += \
    AntHalService \
    com.dsi.ant.antradio_library

PRODUCT_COPY_FILES += \
    external/ant-wireless/antradio-library/com.dsi.ant.antradio_library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.dsi.ant.antradio_library.xml

# WLAN driver configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf


#Display/Graphics
ifeq (true,$(call math_gt_or_eq,$(SHIPPING_API_LEVEL),29))
PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.allocator-service \
    android.hardware.graphics.mapper@3.0-impl-qti-display \
    android.hardware.graphics.mapper@4.0-impl-qti-display
else
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1
endif
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.broadcastradio@1.0-impl

ifeq (true,$(call math_gt_or_eq,$(SHIPPING_API_LEVEL),29))
#Enable Light AIDL HAL
PRODUCT_PACKAGES += android.hardware.lights-service.qti
#Display/Graphics
PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.allocator-service \
    android.hardware.graphics.mapper@3.0-impl-qti-display \
    android.hardware.graphics.mapper@4.0-impl-qti-display
else
#Enable Light HIDL HAL
PRODUCT_PACKAGES += \
android.hardware.light@2.0-impl \
android.hardware.light@2.0-service
#Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1
endif

PRODUCT_PACKAGES += \
    vendor.display.color@1.0-service \
    vendor.display.color@1.0-impl

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

PRODUCT_PACKAGES += \
	android.hardware.usb@1.0-service

# Sensor features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

#Facing, CMC and Gesture
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.sensors.facing=false \
    ro.vendor.sensors.cmc=false \
    ro.vendor.sdk.sensors.gestures=false

# Wifi
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/hostapd.accept:$(TARGET_COPY_OUT_VENDOR)/etc/hostapd/hostapd.accept \
    $(LOCAL_PATH)/wifi/hostapd.conf:$(TARGET_COPY_OUT_VENDOR)/etc/hostapd/hostapd_default.conf \
    $(LOCAL_PATH)/wifi/hostapd.deny:$(TARGET_COPY_OUT_VENDOR)/etc/hostapd/hostapd.deny \
    $(LOCAL_PATH)/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    $(LOCAL_PATH)/wifi/wifi_concurrency_cfg.txt:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wifi_concurrency_cfg.txt

# High performance VR feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vr.high_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vr.high_performance.xml

# SF properties
ifeq ($(call math_gt,$(SHIPPING_API_LEVEL),29),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
    ro.surface_flinger.max_virtual_display_dimension=4096
endif

# FBE support
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh
# VB xml
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

# MIDI feature
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

# MSM IRQ Balancer configuration file for SDM660
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf
# MSM IRQ Balancer configuration file for SDM630
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/msm_irqbalance_sdm630.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance_sdm630.conf

PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_VENDOR_MOVE_ENABLED := true

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

#Healthd packages
PRODUCT_PACKAGES += \
        android.hardware.health@2.1-impl \
        android.hardware.health@2.1-service \
        android.hardware.health@2.1-impl.recovery \
        libhealthd.msm

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

TARGET_SUPPORT_SOTER := true

#Enable QTI KEYMASTER and GATEKEEPER HIDLs
ifeq ($(ENABLE_VENDOR_IMAGE), true)
KMGK_USE_QTI_SERVICE := true
endif

#Enable KEYMASTER 4.0
ENABLE_KM_4_0 := true

#Enable AOSP KEYMASTER and GATEKEEPER HIDLs
ifneq ($(KMGK_USE_QTI_SERVICE), true)
PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-impl \
                    android.hardware.gatekeeper@1.0-service \
                    android.hardware.keymaster@3.0-impl \
                    android.hardware.keymaster@3.0-service
endif

PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/system/vendor/lib64/libril-qc-qmi-1.so

# Kernel modules install path
# Change to dlkm when dlkm feature is fully enabled
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

SDM660_DISABLE_MODULE := true

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE:=true

# Enable vndk-sp Libraries
PRODUCT_PACKAGES += vndk_package

TARGET_MOUNT_POINTS_SYMLINKS := false

# Disable skip validate
PRODUCT_PROPERTY_OVERRIDES += \
  vendor.display.disable_skip_validate=1

#vendor prop to disable advanced network scanning
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.enableadvancedscan=false

# Enable telephpony ims feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml

# Target specific Netflix custom property
PRODUCT_PROPERTY_OVERRIDES += \
    ro.netflix.bsp_rev=Q660-13149-1

PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.volume.filenames_mode = "aes-256-cts" \
    ro.crypto.dm_default_key.options_format.version = 2 \
    ro.crypto.volume.metadata.method=dm-default-key \
    ro.crypto.allow_encrypt_override = true

PRODUCT_PACKAGES += libnbaio

# Target specific Netflix custom property
PRODUCT_PROPERTY_OVERRIDES += \
    ro.netflix.bsp_rev=Q660-13149-1
