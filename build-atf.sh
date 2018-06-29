#!/bin/sh

export BUILD_PATH=$(pwd)
export PATH=/opt/gcc-linaro-5.5.0-2017.10-x86_64_arm-linux-gnueabihf/bin:/opt/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu/bin/:$PATH

cd ${BUILD_PATH}/edk2
ln -sf ../OpenPlatformPkg
cd -

BUILD_OPTION=DEBUG
export AARCH64_TOOLCHAIN=GCC5
export UEFI_TOOLS_DIR=${BUILD_PATH}/uefi-tools
export EDK2_DIR=${BUILD_PATH}/edk2
EDK2_OUTPUT_DIR=${EDK2_DIR}/Build/HiKey960/${BUILD_OPTION}_${AARCH64_TOOLCHAIN}
cd ${EDK2_DIR}
# Build UEFI & Trusted Firmware-A
${UEFI_TOOLS_DIR}/uefi-build.sh -b ${BUILD_OPTION} -a ../arm-trusted-firmware -s ../optee_os hikey960
cd -

cd ${BUILD_PATH}/l-loader
ln -sf ${EDK2_OUTPUT_DIR}/FV/bl1.bin
ln -sf ${EDK2_OUTPUT_DIR}/FV/bl2.bin
ln -sf ${EDK2_OUTPUT_DIR}/FV/fip.bin
ln -sf ${EDK2_OUTPUT_DIR}/FV/BL33_AP_UEFI.fd
make hikey960
cd -

cd ${BUILD_PATH}/tools-images-hikey960
ln -sf ${BUILD_PATH}/l-loader/l-loader.bin
ln -sf ${BUILD_PATH}/l-loader/fip.bin
ln -sf ${BUILD_PATH}/l-loader/recovery.bin

#sudo ./hikey_idt -c config -p /dev/ttyUSB1

cd -
