#!/usr/bin/bash
#
# Script to fix the line endings issue with https://github.com/AnandPilania/php-android-cli/
# Issue can be found at:
# - https://github.com/AnandPilania/php-android-cli/issues/4
# - https://github.com/AnandPilania/php-android-cli/issues/8
#
# This script:
# + downloads the v1.0.0 binary of phpandroid.phar (which has incorrect line endings for linux execution)
# + downloads the v1.0.0 source code (zip) for the above binary
# + extracts the vendor folder from the binary
# + re-builds the phpandroid.phar archive from source
# + cleans up!
echo -e "\033[93m *** This script creates a temporary folder, fix-phpandroid, in your home directory and downloads \033[0mphpandroid.phar (v1.0.0) binary release & its source code \033[93mfrom the official github repository at \033[94mhttps://github.com/AnandPilania/php-android-cli\n"
echo -e "\033[93mThis script relies upon the following being available:\033[0m\n * wget (\033[93musually installed by default on most Linux boxes\033[0m)\n * phar (\033[93mthis is part of phpV.X-common\033[0m; if you have php, you should have phar)\n\033[0m * unzip (\033[91mnot \033[93musually installed by default - use the pkg manager to install)\033[0m\n     sudo apt install unzip\n     sudo yum install unzip \033[93metc, use the pkg man for the flavour you use\n\n\033[91mPlease ensure you have these before continuing to execute this script.\033[0m"
read -p "Press any key to continue, or CTRL+C to quit"
mkdir ~/fix-phpandroid
cd ~/fix-phpandroid
wget https://github.com/AnandPilania/php-android-cli/releases/download/v1.0.0/phpandroid.phar
phar extract -f phpandroid.phar extracted
# clean up - don't need the broken binary any more
rm phpandroid.phar
wget https://github.com/AnandPilania/php-android-cli/archive/refs/tags/v1.0.0.zip
unzip v1.0.0.zip
mv extracted/vendor php-android-cli-1.0.0/.
rm v1.0.0.zip
cd php-android-cli-1.0.0
# Correct the version number, so we know in future that this is a modified binary, not an official release:
sed -i -e 's/v1.0.0/v1.0.99/g' index.php
sed -i -e 's/Console App/Console App [self build]/g' index.php
cd tasks
php generate_phar.php
mv phpandroid.phar ~/.
cd ../../..
# final clean up
rm -rf fix-phpandroid
echo -e "\n\033[93m *** All temporary files and folders created by this script have been deleted, including the two downloaded ones.\n\033[0m"
chmod +x ~/phpandroid.phar
echo -e "\n\033[93m *** Re-build phpandroid.phar successful.\033[0m \033[91mThe binary can be found in your home directory $HOME/phpandroid.phar. Execute permission bit has been set\033[0m:"
ls ~/phpandroid.phar -la
echo -e "\n\033[93m *** Running command line: \033[0m~/phpandroid.phar -V\n\033[91mIf the following reads \033[0m'Console App [self build] \033[92mv1.0.99\033[90m'\033[91m then the bug is fixed and your new phpandroid.phar is ready and waiting to be put into /usr/bin/ or wherever you want to put it!\033[0m"
~/phpandroid.phar -V
