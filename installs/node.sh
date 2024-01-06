# Set Version
VERSION=v20.10.0
DISTRO=linux-x64
INSTALL_FOLDER=/usr/local/lib/nodejs

# Download prebuilt binaries
curl -O https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.xz

# Create necessary folders, and extract binaries to install folder
sudo mkdir -p $INSTALL_FOLDER
sudo tar -xJvf node-$VERSION-$DISTRO.tar.xz -C $INSTALL_FOLDER

# update profile
FILE=~/.zsh/node.zsh
#if [ -f "$FILE" ]; then
    # Append node path to $PATH in your profile
    echo "export PATH=$INSTALL_FOLDER/node-$VERSION-$DISTRO/bin:$PATH" > $FILE
    # Reload profile
    source $FILE
    echo 'Updated user profile'
    # Run version reports
    node -v
    npm version
    npx -v
#else
#    echo "$FILE does not exist."
#    echo "Please manually update your profile to add Node.js to your PATH"
#fi


rm node-$VERSION-$DISTRO.tar.xz
