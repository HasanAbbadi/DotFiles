export PATH := ${HOME}/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl

PACKAGES	:= arandr bat bc dmenu dosfstools dunst exfat-utils ffmpeg fzf fzy gnome-keyring 
PACKAGES	+= gvim i3-gaps libnotify lynx maim man-db mediainfo moreutils mpc mpd mpv mupdf 
PACKAGES	+= ncmpcpp newsboat noto-fonts-emoji ntfs-3g pamixer picom pipewire pipewire-pulse 
PACKAGES	+= poppler pulsemixer python-qdarkstyle rofi rofi-calc rxvt-unicode slock socat 
PACKAGES	+= sxiv tmux ttf-dejavu ttf-linux-libertine unclutter unrar unzip urxvt-perls vimb 
PACKAGES	+= xcape xclip xcompmgr xdotool xorg-server xorg-xbacklight xorg-xdpyinfo 
PACKAGES	+= xorg-xinit xorg-xprop xorg-xwininfo xwallpaper youtube-dl zsh 

PIP_PKGS	:= pywal lookatme

BASE_PKGS	:= filesystem gcc-libs glibc bash coreutils file findutils gawk grep procps-ng 
BASE_PKGS	+= sed tar gettext pciutils psmisc shadow util-linux bzip2 gzip xz licenses which 
BASE_PKGS	+= pacman systemd systemd-sysvcompat iputils iproute2 autoconf sudo automake 
BASE_PKGS	+= binutils bison fakeroot flex gcc groff libtool m4 make patch pkgconf texinfo 


PACMAN		:= sudo pacman -S --needed --noconfirm 
PIP				:= sudo pip3 install 
SYSTEMD_ENABLE	:= sudo systemctl --now enable 
LN		:= ln -vsf 
AURHELPER := yay

.DEFAULT_GOAL := help
.PHONY: all allinstall

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: ## Install My Whole Config | Do all the following:
	allinstall

${HOME}/.local:
	mkdir -p $<

test:
	echo $(AURHELPER)

init: ## Initial Symlinks
	# make the needed directories
	mkdir -p ${HOME}/.config
	find ${PWD}/.config -maxdepth 2 -type d | tail -n +1 | xargs -I{} mkdir -p $${HOME}/{}
	# X11
	$(LN) {${PWD},${HOME}}/.config/x11/xresources
	$(LN) {${PWD},${HOME}}/.config/x11/xinitrc
	$(LN) ${PWD}/.config/x11/xprofile ${HOME}/xprofile
	# SHELL
	$(LN) {${PWD},${HOME}}/.config/shell/zshnameddirrc
	$(LN) {${PWD},${HOME}}/.config/shell/bm-dirs
	$(LN) {${PWD},${HOME}}/.config/shell/aliasrc
	$(LN) {${PWD},${HOME}}/.config/shell/profile
	$(LN) {${PWD},${HOME}}/.config/shell/inputrc
	$(LN) {${PWD},${HOME}}/.config/shell/bm-files
	$(LN) {${PWD},${HOME}}/.config/shell/shortcutrc
	# ZSH
	$(LN) {${PWD},${HOME}}/.config/zsh/.zcompdump
	$(LN) {${PWD},${HOME}}/.config/zsh/.zshrc
	# Everyday Setup
	$(LN) {${PWD},${HOME}}/.config/i3/config
	$(LN) {${PWD},${HOME}}/.config/picom/picom.conf
	$(LN) {${PWD},${HOME}}/.config/tmux/tmux.conf
	$(LN) {${PWD},${HOME}}/.config/lynx/lynx.lss
	$(LN) {${PWD},${HOME}}/.config/lynx/lynx.cfg
	$(LN) {${PWD},${HOME}}/.config/vim/vimrc
	$(LN) {${PWD},${HOME}}/.config/vim/colors/wal.vim
	$(LN) {${PWD},${HOME}}/.config/rofi/config.rasi
	# Vimb
	$(LN) {${PWD},${HOME}}/.config/vimb/config
	$(LN) {${PWD},${HOME}}/.config/vimb/style.css
	$(LN) {${PWD},${HOME}}/.config/sxiv/exec/key-handler

scripts: ## Install my scripts
	mkdir -p $${HOME}/.local/bin
	find .local/bin -maxdepth 2 -type d | tail -n +1 | xargs -I{} mkdir -p $${HOME}/{}
	find .local/bin -type f | xargs -I{} $(LN) {${PWD},${HOME}}/{}

base: ## Install base and base-devel package
	$(PACMAN) $(BASE_PKGS)

pip: ## Install Python and Pip Packages
	$(PACMAN) python-pip
	$(PIP)    $(PIP_PKGS)

pacman: ## Install packages & Make pacman colorful (eye-candy)
	sudo pacman --noconfirm -S archlinux-keyring
	grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
	sed -i "s/^#ParallelDownloads.*$/ParallelDownloads = 5/;s/^#Color$/Color/" /etc/pacman.conf
	$(PACMAN) $(PACKAGES)

aur: ## Install Aur Helper: [Default:Yay]
	sudo mkdir -p "$${HOME}/.local/src/$(AURHELPER)"
	sudo  git clone --depth 1 "https://aur.archlinux.org/$(AURHELPER).git" "${HOME}/.local/src/$(AURHELPER)" >/dev/null 2>&1 ||\
		{ cd "$${HOME}/.local/src/$(AURHELPER)" || return 1 ; sudo git pull --force origin master;}
	cd "$${HOME}/.local/src/$(AURHELPER)"
	sudo -D "$${HOME}/.local/src/$(AURHELPER)" makepkg --noconfirm -si >/dev/null 2>&1 || return 1

xorg: ## Setup XOrg Configs
	sudo cp {${PWD},}/etc/X11/xorg.conf.d/20-intel.conf
	sudo cp {${PWD},}/etc/X11/xorg.conf.d/40-libinput.conf

bluetooth: ## Setup bluetooth using [bluez]
	$(PACMAN) bluez
	$(SYSTEMD_ENABLE) $@

testpath: ## Echo PATH
	PATH=$$PATH
	@echo $$PATH | tr ':' '\n'

allinstall:
	base pacman aur pip init scripts
	xorg bluetooth
