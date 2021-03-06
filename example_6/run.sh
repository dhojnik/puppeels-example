#!/usr/bin/sh
echo "Installing r10k gem...."
if [[ ! `gem list r10k` ]];then
	gem install r10k
fi
echo "Creating modules/ folder..."
mkdir -p modules
echo "Creating manifests/ folder ..."
mkdir -p manifests
echo "Getting the modules..."
PUPPETFILE=./Puppetfile PUPPETFILE_DIR=modules r10k --verbose 3 puppetfile install
echo "Creating default.pp..."
cp example.pp manifests/default.pp

# Disable include ::sudo for Vagrant purpose
# Since it automaticailly set Default requiretty
sed -i 's/include ::sudo/#include ::sudo/' modules/profile/manifests/base.pp
sed -i 's/include profile::logging/#include profile::logging/' modules/profile/manifests/base.pp
sed -i 's/include profile::monitoring/#include profile::monitoring/' modules/profile/manifests/base.pp

# Remove unmet symlink in account
# puppet module
rm modules/account/.travis.yml

echo "Everything is done !"
