 
#!/bin/bash

# Set Default Path
TOP_DIR=$PWD
KERNEL_PATH=/home/nightwatch/kernel/GT-N7100

# TODO: Set toolchain and root filesystem path
TAR_NAME=zImage.tar

TOOLCHAIN="/home/nightwatch/kernel/toolchains/4.4/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-"
# TOOLCHAIN="/home/neophyte-x360/toolchain/bin/arm-none-eabi-"
ROOTFS_PATH="/home/nightwatch/kernel/initramfs/GT-N7100-initramfs/"

echo "Cleaning latest build"
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` clean

cp -f $KERNEL_PATH/arch/arm/configs/t0_04_defconfig $KERNEL_PATH/.config

make -j2 -C $KERNEL_PATH xconfig || exit -1
make -j2 -C $KERNEL_PATH ARCH=arm CROSS_COMPILE=$TOOLCHAIN || exit -1

cp arch/arm/mvp/commkm/commkm.ko $ROOTFS_PATH/lib/modules/
cp arch/arm/mvp/mvpkm/mvpkm.ko $ROOTFS_PATH/lib/modules/
cp arch/arm/mvp/pvtcpkm/pvtcpkm.ko $ROOTFS_PATH/lib/modules/
cp drivers/net/wireless/bcmdhd/dhd.ko $ROOTFS_PATH/lib/modules/
cp drivers/net/wireless/btlock/btlock.ko $ROOTFS_PATH/lib/modules/
cp drivers/scsi/scsi_wait_scan.ko $ROOTFS_PATH/lib/modules/


make -j2 -C $KERNEL_PATH ARCH=arm CROSS_COMPILE=$TOOLCHAIN || exit -1

# Copy Kernel Image
cp -f $KERNEL_PATH/arch/arm/boot/zImage .

cd arch/arm/boot
tar cf $KERNEL_PATH/arch/arm/boot/$TAR_NAME zImage && ls -lh $TAR_NAME
