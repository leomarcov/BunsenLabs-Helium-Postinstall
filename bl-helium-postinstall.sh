[ "$(id)" -ne 0 ] && echo "Administrative prvileges needed" && exit 1

########################################################################
#### PACKAGES ##########################################################
########################################################################
apt-get install vim
apt-get install vlc 
apt-get install haveged                        # Avoid delay first login
apt-get install ttf-mscorefonts-installer
apt-get install fonts-freefont-ttf
apt-get install rofi

# PlayOnLinux
apt-get install winbind
apt-get install playonlinux

# ps_mem script
# https://github.com/pixelb/ps_mem
mkdir /tmp/1
cd /tmp/1
wget https://github.com/pixelb/ps_mem/archive/master.zip
unzip *
cp ps_mem-master/ps_mem.py /usr/local/sbin/psmem.py
rm -rf /tmp/1

# VirtualBox
echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
apt-get update
apt-get install linux-headers-$(uname -r) virtualbox-5.2
# VirtualBox Extension Pack
mkdir /tmp/1
cd /tmp/1
wget https://download.virtualbox.org/virtualbox/5.2.12/Oracle_VM_VirtualBox_Extension_Pack-5.2.12.vbox-extpack  
echo "Check last Extesion Pack: https://www.virtualbox.org/wiki/Downloads"
vboxmanage extpack install --replace *extpack
rm -rf /tmp/1

# Sublime-Text 3
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
apt-get update
apt-get install sublime-text
update-alternatives --install /usr/bin/bl-text-editor bl-text-editor /usr/bin/subl 90
update-alternatives --set bl-text-editor /usr/bin/subl

# Google Chrome
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
apt-get update
apt-get install google-chrome-stable
update-alternatives --set x-www-browser /usr/bin/google-chrome-stable
update-alternatives --set gnome-www-browser /usr/bin/google-chrome-stable


########################################################################
#### CONFIG ############################################################
########################################################################
## DISABLE DISPLAY MANAGER
systemctl set-default multi-user.target


### SERVICES
systemctl disable NetworkManager-wait-online.service
systemctl disable ModemManager.service
systemctl disable pppd-dns.service

vi $HOME/.bashrc
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# GRUB CONIFG
sed -i "/\bGRUB_DEFAULT=/Id" /etc/default/grub
sed -i "/\bGRUB_TIMEOUT=/Id" /etc/default/grub
sed -i "/\bGRUB_HIDDEN_TIMEOUT=/Id" /etc/default/grub
sed -i "/\bGRUB_CMDLINE_LINUX_DEFAULT=/Id" /etc/default/grub
sed -i "/\bGRUB_CMDLINE_LINUX/Id" /etc/default/grub
sed -i "/\bGRUB_DISABLE_OS_PROBER=/Id" /etc/default/grub
sed -i "/\bGRUB_GFXMODE=/Id" /etc/default/grub
sed -i "/\bGRUB_GFXPAYLOAD_LINUX=/Id" /etc/default/grub
sed -i "/\bGRUB_BACKGROUND=/Id" /etc/default/grub
echo '
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX=""
GRUB_DISABLE_OS_PROBER=true
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_BACKGROUND=""' >> /etc/default/grub
update-grub

echo 'rofi.color-enabled: true
rofi.color-window: argb:cc273238, argb:cc273238, argb:cc273238
rofi.color-normal: argb:00273238, argb:ccc1c1c1, argb:00273238, argb:cc394249, argb:ccffffff
rofi.color-active: argb:cc273238, argb:cc80cbc4, argb:cc273238, argb:cc394249, argb:cc80cbc4
rofi.color-urgent: argb:cc273238, argb:ccff1844, argb:cc273238, argb:cc394249, argb:ccff1844
rofi.separator-style: solid
rofi.font:              Monospace 12
!rofi.padding:           50
!rofi.line-margin:       5
!rofi.lines:             10
!rofi.width:             720
!rofi.disable-history:   true
!rofi.modi:              keys,drun,window,run
!rofi.sidebar-mode:      true
rofi.fullscreen:        false
!apply changes: xrdb -load ~/.Xresources'
xrdb -load $HOME/.Xresources

# Config shortcut in Openbox:
vi $HOME/.config/openbox/rc.xml
  <keyboard>
    ...
    <keybind key="C-Tab">
      <action name="Execute">
        <command>rofi -show drun</command>
      </action> 
    </keybind>
    <keybind key="A-Tab">
      <action name="Execute">
        <command>rofi -show window</command>
      </action> 
    </keybind>    
    ...




############################################
### SCRIPTS ################################
############################################
# OPENBOX AUTOSTART
vi $HOME/.config/openbox/autostart
brightness.sh -def &           # Set default brightness
xmodmap $HOME/.Xmodmap &
xbindkeys &
syndaemon -i 1 -d &           # Disable touchpad when using keyboard
