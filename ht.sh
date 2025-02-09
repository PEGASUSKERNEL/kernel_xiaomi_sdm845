#!/bin/sh

DEFCONFIG="HardTeam_defconfig"
CLANGDIR="/workspace/aosp-clang-19"

#
rm -rf compile.log

#
mkdir -p out
mkdir out/HardTeam
mkdir out/HardTeam/SE_OC818
mkdir out/HardTeam/NSE_OC818
mkdir out/HardTeam/SE_OC840
mkdir out/HardTeam/NSE_OC840


#
export KBUILD_BUILD_USER=HardTeam
export KBUILD_BUILD_HOST=@RecoveryIsBusyYouNeedFormatData
export PATH="$CLANGDIR/bin:$PATH"

#
make O=out ARCH=arm64 $DEFCONFIG

#
MAKE="./makeparallel"

#
START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

lol () {
make -j$(nproc --all) O=out LLVM=1 \
ARCH=arm64 \
CC=clang \
LD=ld.lld \
AR=llvm-ar \
AS=llvm-as \
NM=llvm-nm \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
STRIP=llvm-strip \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}
        #SE Overclock 818
        cp HardTeam/SE/* arch/arm64/boot/dts/qcom/
        cp HardTeam/OC/818/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
        cp HardTeam/OC/818/gpucc-sdm845.c drivers/clk/qcom/
        cp HardTeam/TOUCH_FW/NEW/* firmware/
        lol 2>&1 | tee -a compile.log
        if [ $? -ne 0 ]
        then
            echo "Build failed"
        else
            echo "Build succesful"
            cp out/arch/arm64/boot/Image.gz-dtb out/HardTeam/SE_OC818/Image.gz-dtbse818
            
            #NSE Overclock 818
            cp HardTeam/NSE/* arch/arm64/boot/dts/qcom/
            cp HardTeam/OC/818/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
            cp HardTeam/OC/818/gpucc-sdm845.c drivers/clk/qcom/
            cp HardTeam/TOUCH_FW/NEW/* firmware
            lol
            if [ $? -ne 0 ]
            then
                echo "Build failed"
            else
                echo "Build succesful"
                cp out/arch/arm64/boot/Image.gz-dtb out/HardTeam/NSE_OC818/Image.gz-dtbnse818

                 #SE Overclock 840
                 cp HardTeam/SE/* arch/arm64/boot/dts/qcom/
                 cp HardTeam/OC/840/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
                 cp HardTeam/OC/840/gpucc-sdm845.c drivers/clk/qcom/
                 cp HardTeam/TOUCH_FW/OLD/* firmware/
                 lol
                 if [ $? -ne 0 ]
                 then
                     echo "Build failed"
                 else
                 echo "Build succesful"
                 cp out/arch/arm64/boot/Image.gz-dtb out/HardTeam/SE_OC840/Image.gz-dtbse840
            
                    #NSE Overclock 840
                    cp HardTeam/NSE/* arch/arm64/boot/dts/qcom/
                    cp HardTeam/OC/840/sdm845-v2.dtsi arch/arm64/boot/dts/qcom/
                    cp HardTeam/OC/840/gpucc-sdm845.c drivers/clk/qcom/
                    cp HardTeam/TOUCH_FW/OLD/* firmware/
                    lol
                    if [ $? -ne 0 ]
                    then
                        echo "Build failed"
                    else
                    echo "Build succesful"
                    cp out/arch/arm64/boot/Image.gz-dtb out/HardTeam/NSE_OC840/Image.gz-dtbnse840

            fi
        fi
    fi
fi
END=$(date +"%s")
DIFF=$(($END - $START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
