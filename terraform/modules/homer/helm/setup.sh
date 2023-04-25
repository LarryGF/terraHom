#! /bin/bash
echo "Installing unzip"
apt update && apt install unzip -y
echo "Creating subfolders"
mkdir -p /config/icons /config/images /config/logo
echo "Cloning theme"
git clone https://github.com/mrpbennett/catppucin-homer.git /theme
echo "Cloning icons"
git clone https://github.com/NX211/homer-icons.git /icons
echo "Copying icons"
unzip -o /theme/assets/favicons/dark_favicon.zip -d /config/icons/
cp /theme/assets/footers/* /config/
cp -r /icons/png/* /config/icons/
cp -r /icons/svg/* /config/icons/
echo "Copying theme css"
cp /theme/flavours/catppuccin-macchiato.css /config/ 
cp /theme/flavours/catppuccin-latte.css /config/ 
echo "Copying theme background"
cp /theme/assets/images/backgrounds/romb.png /config/images/romb.png
echo "Setting permissions"
chown -R 1001:1001 /config
echo "Done"