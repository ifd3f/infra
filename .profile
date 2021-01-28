# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# /opt/bin
export PATH="$PATH:/opt/bin"

# Git repo I store my configs in
export CONFIG_REPO="/home/astrid/config-repo"

# Snaps
export PATH="$PATH:/snap/bin/"

# AppImages
export PATH="$PATH:/home/astrid/Applications/bin"

# Linuxbrew
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

# Nix
. /etc/profile.d/nix.sh

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Node Version Manager
export PATH="$PATH:/home/astrid/.nvm/versions/node/v14.15.1/bin" # Fix VS Code not finding it
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Maybe Vivado will be happy with this
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/Xilinx/Vivado/2019.2/lib/lnx64.o/

# KiCad path for SKiDL
export KICAD_SYMBOL_DIR=/usr/share/kicad/library/
export KISYSMOD=/usr/share/kicad/modules/

export QSYS_ROOTDIR="/home/astrid/intelFPGA_lite/20.1/quartus/sopc_builder/bin"

# OpenGL includes and crap
export GLM_INCLUDE_DIR="/home/astrid/opengl/glm"
export GLFW_DIR="/home/astrid/opengl/glfw-3.3.2"

# ESP32 IDF and tools
export IDF_PATH="/home/astrid/.lib/esp-idf"
export PATH="$PATH:/home/astrid/.espressif/tools/xtensa-esp32s2-elf/esp-2020r3-8.4.0/xtensa-esp32s2-elf/bin"

# ghcup
. /home/astrid/.ghcup/env

# SteamVR
export PATH="$PATH:/home/astrid/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/"

# RISC-V Toolchain
export PATH="$PATH:/opt/riscv/bin/"

[[ -s "/home/astrid/.gvm/scripts/gvm" ]] && source "/home/astrid/.gvm/scripts/gvm"
