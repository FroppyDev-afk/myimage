#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y remove \
        tmux \
        firefox \
        firefox-langpacks \
        htop && \

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \   
    dnf5 -y --setopt=install_weak_deps=False install \
        rocm-hip \
        rocm-opencl \
        rocm-clinfo \
        rocm-smi && \


dnf5 -y clean all
dnf5 -y install steam
# Use a COPR Example:
dnf5 -y copr enable ilyaz/LACT 
dnf5 -y install lact
dnf5 -y copr disable ilyaz/LACT 


#### enabling System Unit Files

systemctl enable lactd
systemctl enable podman.socket
