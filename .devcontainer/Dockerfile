# Use Ubuntu as base image for better TeX Live support
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set up basic environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Basic utilities
    curl \
    wget \
    git \
    sudo \
    vim \
    nano \
    ca-certificates \
    # Build tools
    make \
    perl \
    python3 \
    python3-pip \
    # Required for TeX Live
    fontconfig \
    ghostscript \
    # Image processing (for graphics in LaTeX)
    imagemagick \
    # PDF utilities
    poppler-utils \
    # Helpful utilities
    tree \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install TeX Live - Full scheme for complete LaTeX support
# Using the network installer approach
RUN mkdir -p /tmp/texlive-install && \
    cd /tmp/texlive-install && \
    wget -q http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar -xzf install-tl-unx.tar.gz && \
    cd install-tl-* && \
    # Create installation profile for automated install
    echo "selected_scheme scheme-full" > texlive.profile && \
    echo "TEXDIR /usr/local/texlive" >> texlive.profile && \
    echo "TEXMFLOCAL /usr/local/texlive/texmf-local" >> texlive.profile && \
    echo "TEXMFSYSVAR /usr/local/texlive/texmf-var" >> texlive.profile && \
    echo "TEXMFSYSCONFIG /usr/local/texlive/texmf-config" >> texlive.profile && \
    echo "TEXMFVAR ~/.texlive/texmf-var" >> texlive.profile && \
    echo "TEXMFCONFIG ~/.texlive/texmf-config" >> texlive.profile && \
    echo "TEXMFHOME ~/texmf" >> texlive.profile && \
    echo "option_doc 0" >> texlive.profile && \
    echo "option_src 0" >> texlive.profile && \
    echo "instopt_adjustpath 1" >> texlive.profile && \
    # Run installation (this takes a while)
    perl ./install-tl --profile=texlive.profile --no-interaction && \
    # Clean up
    cd / && \
    rm -rf /tmp/texlive-install

# Add TeX Live to PATH
ENV PATH="/usr/local/texlive/bin/x86_64-linux:${PATH}"

# Update tlmgr and install additional packages if needed
RUN tlmgr update --self && \
    tlmgr update --all

# Install latexmk if not already included
RUN tlmgr install latexmk

# Create a non-root user 'vscode' for development
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up texmf-local permissions
RUN mkdir -p /usr/local/texlive/texmf-local && \
    chown -R $USERNAME:$USERNAME /usr/local/texlive/texmf-local

# Switch to non-root user
USER $USERNAME

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]

