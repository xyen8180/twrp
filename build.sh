#!/bin/bash

# Just a basic script U can improvise lateron asper ur need xD 

MANIFEST="https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp -b twrp-11"


DEVICE=star
DT_LINK="https://github.com/xyen8180/twrp/"
DT_PATH=device/xiaomi/$DEVICE
SD_LINK="https://github.com/xyen8180/android_device_xiaomi_sm8350-common -b aosp"
SD_PATH="device/xiaomi/sm8350-common"
echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y
mkdir ~/twrp && cd ~/twrp

echo " ===+++ Syncing Recovery Sources +++==="
echo " ===+++ Cloning Manifest  +++==="
repo init --depth=1 -u $MANIFEST 2>/dev/null
repo sync 2>/dev/null
repo sync 2>/dev/null
echo " ===+++ Device Tree Manifest  +++==="
git clone --depth=1 $DT_LINK $DT_PATH 2>/dev/null
echo " ===+++ Cloning SM8350-common Tree  +++==="
git clone --depth=1 $SD_LINK $SD_PATH 2>/dev/null
echo " ===+++ Cloning VEndor Manifest  +++==="
git clone http://github.com/xyen8180/vendor_star vendor/xiaomi/sm8350-common/ 2>/dev/null
echo " ===+++ Cloning Kernel Tree   +++==="
git clone https://github.com/nebrassy/kernel_xiaomi_sm8350  kernel/xiaomi/sm8350/ 2>/dev/null
echo " ===+++ Building Recovery +++==="
chmod -R u+x *
chmod -R u+x ./*
echo -------------------------------

echo " ===+++ Building Recovery +++==="

. build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_${DEVICE}-eng && mka bootimage

# Upload zips & boot.img (U can improvise lateron adding telegram support etc etc)
echo " ===+++ Uploading Recovery +++==="
version=$(cat bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d \" -f2)
OUTFILE=TWRP-${version}-${DEVICE}-$(date "+%Y%m%d-%I%M").zip
cd out/target/product/$DEVICE
mv boot.img ${OUTFILE%.zip}.img
zip -r9 $OUTFILE ${OUTFILE%.zip}.img

#curl -T $OUTFILE https://oshi.at
curl -sL $OUTFILE https://git.io/file-transfer | sh
./transfer wet *.zip
