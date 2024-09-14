#!/bin/bash
#--------------------------------------------------------------------
# script installs all major apps in automatic mode, adds aliases, adds additional repos and gpgkeys
# tested on Fedora 40
#--------------------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# flatpak setup
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with flatpak setup, check error.log"
fi

rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf install fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with repos and gpg setup, check error.log"
fi

# adding rpm-fusion repos
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with rpm-fision repos setup, check error.log"
fi

# system update and flatpak update
dnf up -y; flatpak update -y; dnf autoremove -y 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with OS packages upgrade and cleanup, check error.log"
fi

# flatpak apps installation [telegram] [retroarch] [anydesk] [rssguard] [jellyfin] [fedora media writer] [ip scanner] [doom] [kega fusion emulator]
flatpak install flathub org.telegram.desktop 2>>error.log
flatpak install flathub org.libretro.RetroArch 2>>error.log
flatpak install flathub com.anydesk.Anydesk 2>>error.log
flatpak install flathub io.github.martinrotter.rssguard 2>>error.log
flatpak install flathub com.github.iwalton3.jellyfin-media-player 2>>error.log
flatpak install flathub org.fedoraproject.MediaWriter 2>>error.log
flatpak install flathub org.angryip.ipscan 2>>error.log
flatpak install flathub org.chocolate_doom.ChocolateDoom 2>>error.log
flatpak install flathub com.carpeludum.KegaFusion 2>>error.log
flatpak install flathub io.github.freedoom.Phase2 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with flatpak apps installation, check error.log"
fi

# additional apps installation via dnf [docker] [podman] [git] [curl] [dnf-plugin-core] [brave browser] [codium] [flameshot] [sublime text]
# [neofetch] [terminator terminal] [copyq] [chromium browser] [google chrome browser] [mpv] [vlc] [htop] [qbittorrent]
dnf install -y docker podman git git-crypt curl dnf-plugins-core brave-browser codium flameshot sublime-text neofetch terminator copyq chromium google-chrome-stable mpv vlc htop qbittorrent 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with dnf apps installation, check error.log"
fi

# install virtualization packages and enable it
dnf install -y @virtualization 2>>error.log
systemctl start libvirtd 2>>error.log
systemctl enable libvirtd 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with virtualization setup, check error.log"
fi

# install multimedia libraries and OpenH264
dnf group install -y Multimedia 2>>error.log
dnf install -y gstreamer1-plugin-openh264 mozilla-openh264 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with multimedia setup, check error.log"
fi

# additional kde apps installation
dnf install -y krusader konsole knights 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with KDE apps setup, check error.log"
fi

# pip3 instalation packages
pip3 install ansible 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with ansible setup, check error.log"
fi

# joplin installation
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with joplin setup, check error.log"
fi

# zsh setup with extensions and aliases
dnf install -y zsh 2>>error.log
chsh -s $(which zsh) 2>>error.log
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 2>>error.log
cp ~/.zshrc ~/.zshrc.backup  # Backup of current .zshrc 
cp .zshrc ~/.zshrc 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with ZSH setup, check error.log"
fi