export PATH := ${HOME}/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl

PACKAGES  := xorg-server xorg-xwininfo xorg-xinit ttf-linux-libertine bc xcompmgr xorg-xprop 
PACKAGES  += arandr dosfstools libnotify dunst exfat-utils sxiv xwallpaper ffmpeg 
PACKAGES  += gnome-keyring python-qdarkstyle gvim mpd mpc mpv man-db ncmpcpp newsboat 
PACKAGES  += noto-fonts-emoji ntfs-3g pipewire pipewire-pulse pulsemixer pamixer maim 
PACKAGES  += unclutter unrar unzip lynx xcape xclip xdotool xorg-xdpyinfo youtube-dl 
PACKAGES  += mupdf poppler mediainfo fzf bat xorg-xbacklight slock socat 
PACKAGES  += moreutils 

BASE_PKGS	:= filesystem gcc-libs glibc bash coreutils file findutils gawk grep procps-ng sed tar gettext
BASE_PKGS	+= pciutils psmisc shadow util-linux bzip2 gzip xz licenses pacman systemd systemd-sysvcompat 
BASE_PKGS	+= iputils iproute2 autoconf sudo automake binutils bison fakeroot flex gcc groff libtool m4 
BASE_PKGS	+= make patch pkgconf texinfo which

PACMAN		:= sudo pacman -S --needed 
SYSTEMD_ENABLE	:= sudo systemctl --now enable
LN		:= ln -vsf 

.DEFAULT_GOAL := help
.PHONY: all allinstall nextinstall allupdate allbackup

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: allinstall allupdate

${HOME}/.local:
	mkdir -p $<

init: ## Initial deploy dotfiles
	echo -en "WARNING: THIS WILL OVERWRITE YOUR CONFIGS"
	sleep 3
	$(LN) {${PWD},${HOME}}/.config/x11/xresources
	$(LN) {${PWD},${HOME}}/.config/x11/xinitrc
	$(LN) {${PWD},${HOME}}/.config/x11/xprofile
	$(LN) {${PWD},${HOME}}/.config/i3/config
	$(LN) {${PWD},${HOME}}/.config/lynx/lynx.lss
	$(LN) {${PWD},${HOME}}/.config/lynx/lynx.cfg
	$(LN) {${PWD},${HOME}}/.config/vim/vimrc
	$(LN) {${PWD},${HOME}}/.config/shell/aliasrc
	$(LN) {${PWD},${HOME}}/.config/shell/profile
	$(LN) {${PWD},${HOME}}/.config/tmux/tmux.conf
	$(LN) {${PWD},${HOME}}/.config/vimb/config
	$(LN) {${PWD},${HOME}}/.config/picom/picom.conf

scripts: ## Initial deploy dotfiles
	echo -en "WARNING: THIS WILL OVERWRITE ANY SCRIPT WITH THE SAME NAME"
	sleep 3

base: ## Install base and base-devel package
	$(PACMAN) $(BASE_PKGS)

install: ## Install arch linux packages using pacman
	$(PACMAN) $(PACKAGES)

urxvt: ## Init rxvt-unicode terminal
	$(PACMAN) $@-perls rxvt-unicode

mpv:
	mkdir -p ${HOME}/.config/mpv

test:
	echo $@

hosts:
	sudo $(LN) {${PWD},}/etc/hosts

sxiv: ## Init sxiv
	$(PACMAN) $@
	mkdir -p ${HOME}/.config/$@/exec
	$(LN) {${PWD},${HOME}}/.config/$@/exec/image-info && chmod +x $$_

intel: ## Setup Intel Graphics
	sudo $(LN) {${PWD},}/etc/X11/xorg.conf.d/20-intel.conf

bluetooth: # Setup bluetooth for AS801 by AfterShokz
	$(PACMAN) bluez
	$(SYSTEMD_ENABLE) $@

testpath: ## Echo PATH
	PATH=$$PATH
	@echo $$PATH
	GOPATH=$$GOPATH
	@echo $$GOPATH

allinstall: ## Install EVERYTING
	gnupg init base install urxvt thinkpad sxiv intel gh 
	bluetooth desktop screenkey testpath allinstall allupdate

allupdate: update
