FROM archlinux:base
ARG PUSERNAME=arch
ARG PUID=1000
# enable color output
ENV TERM=xterm-256color

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

# re-enable pacman doc extractions (i.e. man pages)
# hadolint ignore=SC2016
RUN awk -i inplace -v patt="[options]" '$0 == patt && ++f==2 {next} 1' /etc/pacman.conf && \
    sed -i '/^NoExtract/d' /etc/pacman.conf && \
    # initialize pacman
    pacman-key --init && \
    # FIXME: configure appropriate pacman mirrors
    echo 'Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
    echo 'Server = https://mirror.leaseweb.net/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist && \
    # run OS package updates
    pacman -Syu --noconfirm

# install packages
RUN pacman -S --noconfirm \
        ack \
        apache \
        base-devel \
        bash \
        bat \
        bind-tools \
        cifs-utils \
        cmake \
        curl \
        dotnet-sdk \
        exfat-utils \
        git \
        gnupg \
        go \
        htop \
        jq \
        man-db \
        man-pages \
        neofetch \
        net-tools \
        nmap \
        openbsd-netcat \
        openssh \
        pacman-contrib \
        p7zip \
        pyenv \
        screen \
        sudo \
        sysstat \
        rsync \
        terraform \
        terragrunt \
        tree \
        unzip \
        vim \
        wget \
        which \
        whois \
        xz \
        zip \
        zsh

# add non-root user
RUN echo "%wheel ALL=NOPASSWD:ALL" > /etc/sudoers.d/wheel && \
    useradd -mlG wheel -s /usr/sbin/zsh -u ${PUID} ${PUSERNAME}

# install docker
RUN pacman -S --noconfirm \
        docker \
        docker-compose && \
    usermod -aG docker ${PUSERNAME}

# install stderrred
RUN git clone https://github.com/nbarnum/stderred.git /opt/stderred && \
    pushd /opt/stderred && \
    make && \
    popd || exit

# configure zsh
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /opt/dotfiles/.oh-my-zsh && \
    git clone https://github.com/romkatv/powerlevel10k.git /opt/dotfiles/.oh-my-zsh/custom/themes/powerlevel10k && \
    git clone https://github.com/zsh-users/zsh-autosuggestions /opt/dotfiles/.zsh/zsh-autosuggestions
COPY dotfiles/ /opt/dotfiles/

# install yay
RUN git clone https://aur.archlinux.org/yay.git /opt/yay && \
    chown -R ${PUSERNAME}:${PUSERNAME} /opt/yay
USER ${PUSERNAME}
WORKDIR /opt/yay
RUN makepkg -si --noconfirm

# final configuration
COPY entrypoint.sh /bin/entrypoint.sh
WORKDIR /home/${PUSERNAME}
ENTRYPOINT ["/bin/entrypoint.sh"]
