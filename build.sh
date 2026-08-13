#!/bin/bash

echo
echo "Clean Build Directory"
echo 

make clean && make mrproper

echo
echo "Issue Build Commands"
echo

mkdir -p out
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=/home/konadev/toolchains/clang-r416183b/bin
export GCC64_PATH=/home/konadev/toolchains/aarch64-linux-gnu/bin
export GCC32_PATH=/home/konadev/toolchains/arm-linux-gnueabi/bin
export PATH=${CLANG_PATH}:${GCC64_PATH}:${GCC32_PATH}:${PATH}
export CLANG_TRIPLE=/home/konadev/toolchains/aarch64-linux-gnu/bin/aarch64-linux-gnu-
export CROSS_COMPILE=/home/konadev/toolchains/aarch64-linux-gnu/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/home/konadev/toolchains/arm-linux-gnueabi/bin/arm-linux-gnueabi-

echo
echo "Set DEFCONFIG"
echo 
make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=${CROSS_COMPILE}objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out ARCH=arm64 SUBARCH=arm64 vendor/timelm_defconfig -j$(nproc --all)

echo
echo "Build The Good Stuff"
echo 

make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=${CROSS_COMPILE}objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out -j$(nproc --all) 2>&1 | tee out/build.log

