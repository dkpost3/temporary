# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/ArrowOS/android_manifest.git -b arrow-12.1 -g default,-mips,-darwin,-notdefault
git clone https://github.com/Atul9977/local_manifest.git --depth 1 -b main .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

#build rom
export KBUILD_BUILD_USER=Atul 
export BUILD_USERNAME=Atul
source build/envsetup.sh
lunch arrow_garden-userdebug
export SELINUX_IGNORE_NEVERALLOWS=true
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
export TZ=Asia/Kolkata #put before last build command
m otapackage

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
