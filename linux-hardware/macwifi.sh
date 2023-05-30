sudo apt update
sudo nala install bcmwl-kernel-source
sudo modprobe -r b43 ssb wl brcmfmac brcmsmac bcma
sudo modprobe wl

