#! /bin/bash

# Warn user
echo "This script removes a LOT of packages!"
read -p "Do you want to continue? (y/N)" continue

case "$continue" in
    Y|y*);;
    *) exit 1;;
esac


# Run as root
if [ $UID -ne 0 ]; then
    exec sudo -s "$0" "$@"
fi


printf "Removing packages...""\n"

while read package
do
  apt purge --ignore-missing --auto-remove -y "$package"
done < "packages-to-remove.txt"

printf "\n""Packages removed successfully!"



# Add repositories (finish)
printf "\n""Adding repositories...""\n"

while read package
do
   apt-add-repository deb
done < "repositories.txt"



# Install packages
printf "\n""Installing packages...""\n"

while read package
do
    apt update
    apt install --ignore-missing -y "$package"
done < "packages-to-install.txt"

printf "\n""Packages installed successfully!""\n"
