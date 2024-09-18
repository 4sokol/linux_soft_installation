#!/bin/bash
#--------------------------------------------------------------------
# script installs all major apps, adds aliases, adds additional repos and gpgkeys
# tested on Fedora 40 with KDE
#--------------------------------------------------------------------

# flatpak setup
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with flatpak setup, check error.log"
fi

#adding repos and gpg
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo -y
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
sudo printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo -y
sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo -y
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with repos and gpg setup, check error.log"
fi

# adding rpm-fusion repos
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with rpm-fision repos setup, check error.log"
fi

# system update and flatpak update
sudo dnf up -y; sudo flatpak update -y; sudo dnf autoremove -y 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with OS packages upgrade and cleanup, check error.log"
fi

# flatpak apps installation [telegram] [retroarch] [anydesk] [rssguard] [jellyfin] [fedora media writer] [ip scanner] [doom] [kega fusion emulator]
sudo flatpak install -y flathub org.telegram.desktop 2>>error.log
sudo flatpak install -y flathub org.libretro.RetroArch 2>>error.log
sudo flatpak install -y flathub com.anydesk.Anydesk 2>>error.log
sudo flatpak install -y flathub io.github.martinrotter.rssguard 2>>error.log
sudo flatpak install -y flathub com.github.iwalton3.jellyfin-media-player 2>>error.log
sudo flatpak install -y flathub org.fedoraproject.MediaWriter 2>>error.log
sudo flatpak install -y flathub org.angryip.ipscan 2>>error.log
sudo flatpak install -y flathub org.chocolate_doom.ChocolateDoom 2>>error.log
sudo flatpak install -y flathub com.carpeludum.KegaFusion 2>>error.log
sudo flatpak install -y flathub io.github.freedoom.Phase2 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with flatpak apps installation, check error.log"
fi

# additional apps installation via dnf [pip3] [docker] [podman] [git] [curl] [dnf-plugin-core] [brave browser] [codium] [flameshot] [sublime text]
# [neofetch] [terminator terminal] [copyq] [chromium browser] [mpv] [vlc] [htop] [qbittorrent] [terraform]
sudo dnf install -y python3-pip docker podman git git-crypt pip3 curl dnf-plugins-core brave-browser codium flameshot sublime-text neofetch terminator copyq chromium mpv vlc htop qbittorrent terraform 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with dnf apps installation, check error.log"
fi

# install virtualization packages and enable it
sudo dnf install -y @virtualization 2>>error.log
sudo systemctl start libvirtd 2>>error.log
sudo systemctl enable libvirtd 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with virtualization setup, check error.log"
fi

# install multimedia libraries and OpenH264
sudo dnf group install -y Multimedia 2>>error.log
sudo dnf install -y gstreamer1-plugin-openh264 mozilla-openh264 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with multimedia setup, check error.log"
fi

# additional kde apps installation
sudo dnf install -y krusader konsole knights 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with KDE apps setup, check error.log"
fi

# pip3 instalation packages
sudo pip3 install -y ansible 2>>error.log
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
sudo dnf install -y zsh 2>>error.log
chsh -s $(which zsh) 2>>error.log
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 2>>error.log
cp ~/.zshrc ~/.zshrc.backup  # Backup of current .zshrc 
cp .zshrc ~/.zshrc 2>>error.log
if [ $? -eq 0 ]; then
    echo "Success"
else
    echo "Error with ZSH setup, check error.log"
fi