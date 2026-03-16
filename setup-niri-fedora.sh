#!/usr/bin/env bash
# =============================================================================
# setup-niri-fedora.sh
# Full installation and configuration of Niri + complete desktop environment
# on a fresh Fedora install.
#
# Includes:
#   - Third-party repos (RPM Fusion free/nonfree/tainted, Chrome, Steam, PyCharm)
#   - Multimedia codecs (ffmpeg, GStreamer, libdvdcss)
#   - Nvidia drivers + Wayland workaround (desktop only)
#   - Niri, Waybar (with Bluetooth, Wi-Fi, all icon modules), Mako, Fuzzel,
#     Alacritty, Swayidle/Swaylock, Polkit agent, NetworkManager applet,
#     Blueman, PulseAudio control
#   - Nerd Fonts (JetBrains Mono NF) for Waybar icon glyphs
#   - All config files with Catppuccin Mocha theme
#
# Usage:
#   chmod +x setup-niri-fedora.sh
#   ./setup-niri-fedora.sh
#
# The script asks whether you are on the desktop (Nvidia) or the laptop
# (Intel integrated graphics) and adjusts accordingly.
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
header()  { echo -e "\n${BOLD}═══ $* ═══${NC}"; }

# ── Sanity checks ─────────────────────────────────────────────────────────────
[[ $EUID -eq 0 ]] && error "Do not run this script as root. Use your normal user (sudo will be called when needed)."
command -v dnf &>/dev/null || error "This script requires Fedora (dnf not found)."

# Detect Fedora version for DNF4 / DNF5 compatibility
FEDORA_VERSION=$(rpm -E %fedora)
info "Detected Fedora ${FEDORA_VERSION}."

# DNF5 is the default starting from Fedora 41
if [[ "$FEDORA_VERSION" -ge 41 ]]; then
    DNF5=true
    info "Using DNF5 syntax."
else
    DNF5=false
    info "Using DNF4 syntax."
fi

# ── Initial questions ─────────────────────────────────────────────────────────
header "Initial configuration"

# ── Nvidia hardware auto-detection ────────────────────────────────────────────
# We probe the PCI bus for any device whose vendor ID is 10de (Nvidia).
# lspci is in the 'pciutils' package, which is installed by default on Fedora.
# The check is intentionally broad: it matches GeForce, Quadro, Tesla, etc.
#
# Detection strategy (in order):
#   1. lspci -nn  — lists PCI devices with vendor:device IDs in [xxxx:xxxx] format
#   2. grep -qi "10de"  — matches Nvidia's PCI vendor ID (case-insensitive)
#   3. Also try /sys/bus/pci/devices/*/vendor as a fallback (no lspci needed)

detect_nvidia() {
    # Method 1: lspci (most reliable, human-readable)
    if command -v lspci &>/dev/null; then
        if lspci -nn 2>/dev/null | grep -qi "\[10de:"; then
            return 0  # Nvidia found
        fi
    fi

    # Method 2: sysfs vendor files (works even without lspci)
    if grep -rqi "^0x10de$" /sys/bus/pci/devices/*/vendor 2>/dev/null; then
        return 0  # Nvidia found
    fi

    return 1  # No Nvidia GPU detected
}

echo ""
info "Probing PCI bus for Nvidia GPU..."

if detect_nvidia; then
    # List the detected Nvidia device(s) for the user to verify
    NVIDIA_DEVICES=$(lspci 2>/dev/null | grep -i "nvidia" || \
                     grep -rl "^0x10de$" /sys/bus/pci/devices/*/vendor 2>/dev/null | \
                     xargs -I{} dirname {} | xargs -I{} cat {}/uevent 2>/dev/null | \
                     grep "PCI_ID" | head -3)

    echo ""
    echo -e "  ${GREEN}Nvidia GPU detected:${NC}"
    lspci 2>/dev/null | grep -i "nvidia" | sed 's/^/    /' || true
    echo ""
    echo "  The script will install proprietary Nvidia drivers and apply the"
    echo "  Niri VRAM workaround (GLVidHeapReuseRatio=0)."
    echo ""
    read -rp "  Install Nvidia drivers? [Y/n]: " NVIDIA_CONFIRM
    if [[ "$NVIDIA_CONFIRM" =~ ^[nN]$ ]]; then
        IS_DESKTOP=false
        warn "Skipping Nvidia driver installation as requested."
    else
        IS_DESKTOP=true
        info "Mode: Nvidia GPU detected — will install proprietary drivers."
    fi
else
    echo ""
    info "No Nvidia GPU detected on the PCI bus."
    echo ""
    echo "  Detected graphics hardware:"
    lspci 2>/dev/null | grep -iE "vga|3d|display" | sed 's/^/    /' || \
        echo "    (could not read PCI devices — lspci not available)"
    echo ""
    echo "  The script will skip Nvidia drivers and use the open-source"
    echo "  kernel drivers (i915 for Intel, amdgpu for AMD)."
    echo ""
    # Still offer a manual override in case the probe missed something
    # (e.g. Thunderbolt eGPU, proprietary VM passthrough, exotic board)
    read -rp "  Override and install Nvidia drivers anyway? [y/N]: " NVIDIA_OVERRIDE
    if [[ "$NVIDIA_OVERRIDE" =~ ^[yY]$ ]]; then
        IS_DESKTOP=true
        warn "Manual override: will install Nvidia drivers despite no GPU detected."
    else
        IS_DESKTOP=false
        info "Mode: No Nvidia GPU — open-source drivers only."
    fi
fi

echo ""
read -rp "Install Google Chrome? [y/N]: " INSTALL_CHROME
[[ "$INSTALL_CHROME" =~ ^[yY]$ ]] && CHROME=true || CHROME=false

echo ""
read -rp "Install Steam? [y/N]: " INSTALL_STEAM
[[ "$INSTALL_STEAM" =~ ^[yY]$ ]] && STEAM=true || STEAM=false

echo ""
read -rp "Install PyCharm Community (COPR)? [y/N]: " INSTALL_PYCHARM
[[ "$INSTALL_PYCHARM" =~ ^[yY]$ ]] && PYCHARM=true || PYCHARM=false

# ── 1. System update ──────────────────────────────────────────────────────────
header "1. System update"
info "Refreshing metadata and upgrading all packages..."
sudo dnf upgrade -y --refresh
success "System is up to date."

# ── 2. Third-party repositories ───────────────────────────────────────────────
header "2. Third-party repositories"

# RPM Fusion Free + Nonfree
# Required for: ffmpeg, nvidia drivers, steam, codecs, and many other packages
# that cannot be distributed in the main Fedora repo due to licensing.
info "Installing RPM Fusion Free and Nonfree repositories..."
sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

# RPM Fusion Tainted repos
# Free-tainted: libdvdcss (DVD playback, legally grey in some countries)
# Nonfree-tainted: additional proprietary firmware blobs
info "Installing RPM Fusion Tainted repositories (free + nonfree)..."
sudo dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted

# In DNF4, 'groupupdate core' re-evaluates group memberships after adding repos.
# DNF5 handles this automatically.
if ! $DNF5; then
    sudo dnf groupupdate -y core
fi
success "RPM Fusion repositories configured."

# fedora-workstation-repositories
# Provides repo definitions for Chrome, PyCharm, and other third-party apps
info "Installing fedora-workstation-repositories..."
sudo dnf install -y fedora-workstation-repositories

# ── Optional: Google Chrome ───────────────────────────────────────────────────
if $CHROME; then
    info "Enabling the Google Chrome repository..."
    if $DNF5; then
        sudo dnf config-manager setopt google-chrome.enabled=1
    else
        sudo dnf config-manager --set-enabled google-chrome
    fi
    sudo dnf install -y google-chrome-stable
    success "Google Chrome installed."
fi

# ── Optional: Steam ───────────────────────────────────────────────────────────
# Steam is available via RPM Fusion Nonfree, which is already enabled above.
# It will also pull in required 32-bit libs (steam-devices, etc.).
if $STEAM; then
    info "Installing Steam..."
    sudo dnf install -y steam
    success "Steam installed."
fi

# ── Optional: PyCharm Community ───────────────────────────────────────────────
if $PYCHARM; then
    info "Enabling COPR phracek/PyCharm..."
    sudo dnf copr enable -y phracek/PyCharm
    sudo dnf install -y pycharm-community
    success "PyCharm Community installed."
fi

# ── 3. Multimedia codecs ──────────────────────────────────────────────────────
header "3. Multimedia codecs"

# Fedora ships 'ffmpeg-free' (stripped of non-free codecs) by default.
# We replace it with the full build from RPM Fusion for H.264, AAC, MP3, etc.
info "Installing multimedia codecs from RPM Fusion..."
if $DNF5; then
    info "Swapping ffmpeg-free → full ffmpeg from RPM Fusion..."
    sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing || \
        info "ffmpeg full build already installed, continuing."
    sudo dnf install -y --skip-unavailable \
        gstreamer1-plugins-ugly \
        gstreamer1-plugins-bad-free \
        gstreamer1-plugins-bad-freeworld \
        gstreamer1-plugin-openh264 \
        pipewire-codec-aptx \
        flac faac faad2 \
        x264 x265
else
    # DNF4 path: groupupdate handles codec meta-packages automatically
    sudo dnf groupupdate -y multimedia \
        --setopt="install_weak_deps=False" \
        --exclude=PackageKit-gstreamer-plugin
    sudo dnf groupupdate -y sound-and-video
fi

# libdvdcss from the Tainted repo — needed to play commercial DVDs
sudo dnf install -y libdvdcss
success "Multimedia codecs installed."

# ── 4. Nvidia drivers (desktop only) ─────────────────────────────────────────
if $IS_DESKTOP; then
    header "4. Nvidia drivers (desktop)"

    # akmod-nvidia: DKMS-style module that rebuilds automatically after kernel updates.
    # xorg-x11-drv-nvidia-cuda: includes CUDA libraries and OpenGL ICDs needed by Wayland.
    info "Installing proprietary Nvidia drivers from RPM Fusion..."
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

    # nvidia-drm.modeset=1  — enables DRM kernel mode-setting, required for Wayland.
    # nvidia-drm.fbdev=1    — enables the Nvidia framebuffer device for early console.
    info "Enabling DRM kernel mode-setting for Nvidia + Wayland..."
    sudo grubby --update-kernel=ALL \
        --args="nvidia-drm.modeset=1 nvidia-drm.fbdev=1"

    # VRAM workaround for Niri + Nvidia:
    # Without this, Nvidia's GL driver keeps a large free-buffer pool (~1 GiB of VRAM)
    # that is never released between frames. Setting GLVidHeapReuseRatio=0 disables
    # the pool and keeps idle VRAM usage around ~100 MiB.
    info "Applying Niri + Nvidia VRAM workaround (GLVidHeapReuseRatio=0)..."
    sudo mkdir -p /etc/nvidia/nvidia-application-profiles-rc.d
    sudo tee /etc/nvidia/nvidia-application-profiles-rc.d/50-niri-vram.json > /dev/null << 'NVIDIA_EOF'
{
    "rules": [
        {
            "pattern": {
                "feature": "procname",
                "matches": "niri"
            },
            "profile": "Limit Free Buffer Pool On Wayland Compositors"
        }
    ],
    "profiles": [
        {
            "name": "Limit Free Buffer Pool On Wayland Compositors",
            "settings": [
                {
                    "key": "GLVidHeapReuseRatio",
                    "value": 0
                }
            ]
        }
    ]
}
NVIDIA_EOF
    success "Nvidia drivers and VRAM workaround configured."
    warn "IMPORTANT: After rebooting, wait ~5 minutes before logging into Niri so akmod can compile the kernel module."
fi

# ── 5. Niri and desktop environment packages ──────────────────────────────────
header "5. Installing Niri and desktop environment tools"

# Core compositor and UI tools
info "Installing Niri, Waybar, Mako, Fuzzel, Alacritty..."
sudo dnf install -y --skip-unavailable \
    niri \
    waybar \
    mako \
    fuzzel \
    alacritty

# XWayland compatibility layer — runs legacy X11 apps inside Niri without
# requiring a full XWayland server embedded in the compositor.
info "Installing XWayland satellite..."
sudo dnf install -y --skip-unavailable xwayland-satellite

# Credential storage — gnome-keyring stores SSH/GPG/web passwords;
# libsecret is the library that apps use to talk to it.
info "Installing keyring and secret service..."
sudo dnf install -y gnome-keyring libsecret

# Wallpaper daemon, media controls, screen brightness
info "Installing swaybg, playerctl, brightnessctl..."
sudo dnf install -y swaybg playerctl brightnessctl

# Screenshot tools: grim captures, slurp draws a selection region
info "Installing screenshot tools (grim, slurp)..."
sudo dnf install -y grim slurp wl-clipboard wlr-randr

# PipeWire audio stack — wireplumber is the session manager that replaces
# pipewire-media-session; pipewire-pulseaudio provides PulseAudio compatibility.
info "Installing PipeWire audio stack..."
sudo dnf install -y pipewire wireplumber pipewire-pulseaudio

# XDG portals — allow sandboxed apps (Flatpak, etc.) to access system resources
# (file picker, screen capture, notifications) through a secure API.
# xdg-desktop-portal-gnome provides the GTK4 implementation used by many apps.
info "Installing XDG desktop portals..."
sudo dnf install -y \
    xdg-desktop-portal \
    xdg-desktop-portal-gnome \
    xdg-user-dirs

# Initialize XDG user directories (Downloads, Documents, Music, etc.)
xdg-user-dirs-update

# ── Bluetooth ─────────────────────────────────────────────────────────────────
# bluez     — core BlueZ Bluetooth stack (D-Bus service, kernel module management)
# blueman   — GTK Bluetooth manager (used by the Waybar bluetooth module on-click)
info "Installing Bluetooth stack (bluez + blueman)..."
sudo dnf install -y bluez blueman

# Enable and start the Bluetooth service immediately.
# Without this, the Waybar bluetooth module will show an error state.
info "Enabling bluetooth.service..."
sudo systemctl enable --now bluetooth.service
success "Bluetooth enabled."

# ── Network Manager applet ────────────────────────────────────────────────────
# Provides nm-connection-editor (referenced in niri window rules) and the
# system tray icon for managing Wi-Fi, VPN, and wired connections.
info "Installing NetworkManager applet..."
sudo dnf install -y network-manager-applet
success "NetworkManager applet installed."

# ── PulseAudio volume control ─────────────────────────────────────────────────
# pavucontrol is the GUI mixer for PipeWire/PulseAudio — used as the
# on-click action in the Waybar pulseaudio module.
info "Installing pavucontrol..."
sudo dnf install -y pavucontrol
success "pavucontrol installed."

# ── Polkit authentication agent ───────────────────────────────────────────────
# Without a polkit agent running, any app requesting elevated privileges
# (mounting drives, changing system settings) will silently fail.
# polkit-gnome is lightweight and works well in non-GNOME Wayland sessions.
info "Installing polkit-gnome authentication agent..."
sudo dnf install -y polkit-gnome
success "Polkit agent installed."

# ── Idle management and screen locking ───────────────────────────────────────
# swayidle: monitors inactivity and fires commands (dim screen, lock, sleep).
# swaylock: a Wayland-native screen locker that runs on top of Niri.
info "Installing swayidle and swaylock..."
sudo dnf install -y --skip-unavailable swayidle swaylock
success "Idle management tools installed."

success "All Niri environment packages installed."

# ── 6. Fonts ──────────────────────────────────────────────────────────────────
header "6. Fonts"

# Standard packages from Fedora repos
info "Installing base fonts..."
sudo dnf install -y \
    jetbrains-mono-fonts \
    fontawesome-fonts \
    google-noto-emoji-fonts

# Nerd Fonts — JetBrains Mono Nerd Font variant
# Waybar renders icons using Unicode Private Use Area (PUA) codepoints that are
# only present in Nerd Font patched variants. The standard JetBrains Mono from
# Fedora repos does NOT include these glyphs, so Waybar icons would show boxes.
# We install via the ryanoasis/nerd-fonts COPR.
info "Enabling Nerd Fonts COPR (ryanoasis/nerd-fonts) for Waybar icon glyphs..."
sudo dnf copr enable -y che/nerd-fonts 2>/dev/null || \
    warn "Could not enable Nerd Fonts COPR — Waybar icons may not render. Install manually from https://www.nerdfonts.com/"

if sudo dnf install -y --skip-unavailable nerd-fonts-JetBrainsMono 2>/dev/null; then
    success "JetBrains Mono Nerd Font installed."
else
    # Fallback: download and install manually from GitHub releases
    warn "COPR package not found, attempting direct download from GitHub..."
    NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
    mkdir -p "$FONT_DIR"
    TMPDIR_NF=$(mktemp -d)
    if curl -L --fail -o "$TMPDIR_NF/JetBrainsMono.tar.xz" "$NERD_FONT_URL" 2>/dev/null; then
        tar -xf "$TMPDIR_NF/JetBrainsMono.tar.xz" -C "$FONT_DIR"
        fc-cache -fv "$FONT_DIR" > /dev/null
        success "JetBrains Mono Nerd Font installed to ~/.local/share/fonts/NerdFonts/"
    else
        warn "Could not download Nerd Font. Waybar icons may show as boxes."
        warn "Download manually: https://www.nerdfonts.com/font-downloads"
    fi
    rm -rf "$TMPDIR_NF"
fi

success "Fonts installed."

# ── 6b. Set JetBrainsMono Nerd Font as the system-wide default font ───────────
#
# fontconfig resolves font requests in priority order: user config
# (~/.config/fontconfig/) overrides /etc/fonts/conf.d/ overrides compiled-in
# defaults. We write a high-priority user config (51-) that aliases the three
# generic families (sans-serif, serif, monospace) to JetBrainsMono NF, so every
# GTK app, Waybar, Mako, Fuzzel, and Alacritty all pick up the same font
# without needing per-app configuration.
#
# Priority note: files in conf.d are loaded in lexicographic order.
#   00–49  → font substitutions and aliases
#   50     → default families (we slot in at 51 to override distro defaults)
#   60–99  → metric-compatible aliases (we stay below these)
#
# The <prefer> block inside each <alias> means "try JetBrainsMono NF first;
# if it is not installed, fall through to the next family in the list."
# This prevents a hard failure if the Nerd Font install failed above.

info "Setting JetBrainsMono Nerd Font as the system-wide default font via fontconfig..."

mkdir -p ~/.config/fontconfig

cat > ~/.config/fontconfig/99-jetbrainsmono-nf-default.conf << 'FONTCONFIG_EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<!--
  99-jetbrainsmono-nf-default.conf
  Sets JetBrainsMono Nerd Font as the preferred default for all three
  generic font families. Applications that request "sans-serif", "serif",
  or "monospace" without a specific family will resolve to JetBrainsMono NF.

  Rationale: JetBrainsMono NF covers the full Nerd Fonts icon range (PUA
  codepoints U+E000–U+F8FF and U+100000–U+10FFFD) in addition to normal
  Latin/Cyrillic/Greek glyphs, so it works for both UI text and icon fonts
  without needing a separate fallback.

  Fallback chain:
    JetBrainsMono Nerd Font → JetBrains Mono → (system default)
  The system default kicks in if neither Nerd Font nor the plain variant
  is installed — so this config is always safe to deploy.
-->
<fontconfig>

  <!-- ── sans-serif → JetBrainsMono Nerd Font ───────────────────────────── -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>JetBrainsMono Nerd Font</family>
      <family>JetBrains Mono</family>
    </prefer>
  </alias>

  <!-- ── serif → JetBrainsMono Nerd Font ────────────────────────────────── -->
  <!-- JetBrains Mono has no true serif variant; this alias ensures that     -->
  <!-- apps requesting "serif" still get a legible monospace font rather      -->
  <!-- than falling back to a completely unrelated serif face.                -->
  <alias>
    <family>serif</family>
    <prefer>
      <family>JetBrainsMono Nerd Font</family>
      <family>JetBrains Mono</family>
    </prefer>
  </alias>

  <!-- ── monospace → JetBrainsMono Nerd Font ────────────────────────────── -->
  <!-- This is the most important alias: terminals, code editors, and        -->
  <!-- Waybar/Mako/Fuzzel all request "monospace" when no font is specified. -->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>JetBrainsMono Nerd Font</family>
      <family>JetBrains Mono</family>
    </prefer>
  </alias>

  <!-- ── Global rendering hints ─────────────────────────────────────────── -->
  <!-- subpixel hinting + full hinting gives the sharpest result on most    -->
  <!-- 1080p monitors. Change hintstyle to "hintslight" for HiDPI displays. -->
  <match target="font">
    <edit name="antialias"  mode="assign"><bool>true</bool></edit>
    <edit name="hinting"    mode="assign"><bool>true</bool></edit>
    <edit name="hintstyle"  mode="assign"><const>hintfull</const></edit>
    <edit name="rgba"       mode="assign"><const>rgb</const></edit>
    <edit name="lcdfilter"  mode="assign"><const>lcddefault</const></edit>
  </match>

</fontconfig>
FONTCONFIG_EOF

# Rebuild the fontconfig cache so the new aliases take effect immediately.
# fc-cache -f forces a full rebuild; -v prints each directory processed.
# We silence -v output to keep the script tidy but show a spinner-style wait.
info "Rebuilding fontconfig cache (this may take a few seconds)..."
fc-cache -f ~/.config/fontconfig/ 2>/dev/null && \
    fc-cache -f ~/.local/share/fonts/ 2>/dev/null || true

# Verify the alias resolved correctly
RESOLVED=$(fc-match "monospace" --format="%{family}\n" 2>/dev/null | head -1)
if echo "$RESOLVED" | grep -qi "JetBrainsMono"; then
    success "Default font confirmed: $(fc-match 'monospace' --format='%{family} %{style}' 2>/dev/null)"
else
    warn "fontconfig resolved 'monospace' to '${RESOLVED}' instead of JetBrainsMono NF."
    warn "This usually means the Nerd Font was not installed. The config file is in place"
    warn "and will activate automatically once the font is present."
    warn "Config path: ~/.config/fontconfig/99-jetbrainsmono-nf-default.conf"
fi

# ── 7. Configuration files ────────────────────────────────────────────────────
header "7. Writing configuration files"

# All configs use the Catppuccin Mocha color palette for a consistent look:
#   Background:  #1e1e2e   Text:    #cdd6f4
#   Blue accent: #89b4fa   Surface: #313244
#   Red/error:   #f38ba8   Borders: #45475a

MONITOR_NAME="PLACEHOLDER"
warn "Monitor name is set to '${MONITOR_NAME}' in the Niri config."
warn "After first boot, run 'niri msg outputs' to find the real name and update ~/.config/niri/config.kdl"

# ── Niri ──────────────────────────────────────────────────────────────────────
mkdir -p ~/.config/niri

if [[ -f ~/.config/niri/config.kdl ]]; then
    warn "~/.config/niri/config.kdl already exists — backing up as config.kdl.bak"
    cp ~/.config/niri/config.kdl ~/.config/niri/config.kdl.bak
fi

cat > ~/.config/niri/config.kdl << 'NIRI_EOF'
// ─────────────────────────────────────────────────────────────────────────────
// Niri configuration
// Replace "PLACEHOLDER" with your actual monitor name (run: niri msg outputs)
// ─────────────────────────────────────────────────────────────────────────────

// ── Input ─────────────────────────────────────────────────────────────────────
input {
    keyboard {
        xkb {
            layout "us"
            // Change to "es" for Spanish layout, "de" for German, etc.
            // variant "deadtilde"  // uncomment if needed
        }
    }
    touchpad {
        // tap-to-click enabled
        tap
        // natural scrolling (content follows finger direction)
        natural-scroll
        accel-speed 0.2
    }
    // Focus window when the mouse pointer moves over it (no click needed)
    focus-follows-mouse
}

// ── Outputs (monitors) ────────────────────────────────────────────────────────
// Replace PLACEHOLDER with the real connector name, e.g. DP-1, HDMI-A-1, eDP-1
// Run 'niri msg outputs' inside a running session to list all detected monitors.
output "PLACEHOLDER" {
    mode "1920x1080@60.000"
    scale 1.0
    position x=0 y=0
}

// ── Layout ────────────────────────────────────────────────────────────────────
layout {
    // Gap in pixels between windows and screen edges
    gaps 8

    // Do not automatically center the focused column
    center-focused-column "never"

    // Preset widths cycled through with Mod+R
    preset-column-widths {
        proportion 0.33333   // one third
        proportion 0.5       // half
        proportion 0.66667   // two thirds
    }

    // New windows open at half the screen width by default
    default-column-width { proportion 0.5; }

    // Focus ring shown around the active window
    focus-ring {
        width 2
        active-color "#89b4fa"    // Catppuccin blue
        inactive-color "#45475a"  // Catppuccin surface
    }

    // Window borders are disabled (focus ring provides visual feedback)
    border {
        off
    }
}

// ── Animations ────────────────────────────────────────────────────────────────
animations {
    // 1.0 = default speed; lower values are faster, higher are slower
    slowdown 0.8
}

// ── Autostart ─────────────────────────────────────────────────────────────────
// These programs are launched when Niri starts.
// Order matters: waybar and mako should come before apps that send notifications.

// Status bar
spawn-at-startup "waybar"

// Notification daemon
spawn-at-startup "mako"

// Wallpaper — change the path to your preferred image
// Supported formats: PNG, JPEG, WebP, JXL
spawn-at-startup "swaybg" "-m" "fill" "-i" "/usr/share/backgrounds/gnome/adwaita-l.jxl"

// XWayland compatibility — allows X11 apps to run inside Niri
spawn-at-startup "xwayland-satellite"

// Polkit agent — handles privilege escalation dialogs (e.g. mounting drives)
spawn-at-startup "/usr/libexec/polkit-gnome-authentication-agent-1"

// NetworkManager tray icon — shows Wi-Fi/Ethernet status in the system tray
spawn-at-startup "nm-applet" "--indicator"

// Idle management:
//   After 5 min idle  → lock the screen with swaylock
//   After 10 min idle → turn off monitors
//   On sleep          → lock immediately
spawn-at-startup "swayidle" "-w"
    "timeout" "300"  "swaylock -f -c 1e1e2e"
    "timeout" "600"  "niri msg action power-off-monitors"
    "resume"         "niri msg action power-on-monitors"
    "before-sleep"   "swaylock -f -c 1e1e2e"

// ── Window rules ──────────────────────────────────────────────────────────────
// These windows open as floating dialogs instead of tiling
window-rule {
    match app-id="org.gnome.Calculator"
    match app-id="pavucontrol"
    match app-id="nm-connection-editor"
    match app-id="blueman-manager"
    open-floating true
}

// ── Keybindings ───────────────────────────────────────────────────────────────
binds {
    // ── Application launchers ──────────────────────────────────────────────────
    Mod+Return  { spawn "alacritty"; }             // Open terminal
    Mod+D       { spawn "fuzzel"; }                // App launcher
    Mod+B       { spawn "blueman-manager"; }        // Bluetooth manager
    Mod+N       { spawn "nm-connection-editor"; }   // Network connections

    // ── Window management ──────────────────────────────────────────────────────
    Mod+Shift+Q { close-window; }                  // Close focused window
    Mod+Shift+E { quit; }                          // Exit Niri

    // ── Focus movement (vim-style) ─────────────────────────────────────────────
    Mod+H { focus-column-left; }
    Mod+L { focus-column-right; }
    Mod+J { focus-window-down; }
    Mod+K { focus-window-up; }

    // Arrow key alternatives
    Mod+Left  { focus-column-left; }
    Mod+Right { focus-column-right; }
    Mod+Down  { focus-window-down; }
    Mod+Up    { focus-window-up; }

    // ── Window movement ────────────────────────────────────────────────────────
    Mod+Shift+H { move-column-left; }
    Mod+Shift+L { move-column-right; }
    Mod+Shift+J { move-window-down; }
    Mod+Shift+K { move-window-up; }

    // ── Column sizing ──────────────────────────────────────────────────────────
    Mod+R       { switch-preset-column-width; }    // Cycle preset widths
    Mod+F       { maximize-column; }               // Maximize column
    Mod+Shift+F { fullscreen-window; }             // Full-screen window

    // ── Workspaces ─────────────────────────────────────────────────────────────
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+Shift+1 { move-column-to-workspace 1; }
    Mod+Shift+2 { move-column-to-workspace 2; }
    Mod+Shift+3 { move-column-to-workspace 3; }
    Mod+Shift+4 { move-column-to-workspace 4; }
    Mod+Shift+5 { move-column-to-workspace 5; }

    // ── Mouse wheel scrolling ──────────────────────────────────────────────────
    Mod+WheelScrollRight { focus-column-right; }
    Mod+WheelScrollLeft  { focus-column-left; }

    // ── Screenshots ────────────────────────────────────────────────────────────
    Print     { screenshot; }           // Interactive area selection
    Mod+Print { screenshot-window; }    // Capture the focused window only

    // ── Audio (PipeWire via wpctl) ─────────────────────────────────────────────
    XF86AudioRaiseVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
    XF86AudioLowerVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
    XF86AudioMute         { spawn "wpctl" "set-mute"   "@DEFAULT_AUDIO_SINK@" "toggle"; }
    XF86AudioMicMute      { spawn "wpctl" "set-mute"   "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

    // ── Brightness (mainly for laptop) ────────────────────────────────────────
    XF86MonBrightnessUp   { spawn "brightnessctl" "set" "10%+"; }
    XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

    // ── Media playback ─────────────────────────────────────────────────────────
    XF86AudioPlay  { spawn "playerctl" "play-pause"; }
    XF86AudioStop  { spawn "playerctl" "stop"; }
    XF86AudioNext  { spawn "playerctl" "next"; }
    XF86AudioPrev  { spawn "playerctl" "previous"; }

    // ── Screen lock ────────────────────────────────────────────────────────────
    Mod+Shift+L { spawn "swaylock" "-f" "-c" "1e1e2e"; }
}
NIRI_EOF
success "~/.config/niri/config.kdl written."

# ── Waybar ────────────────────────────────────────────────────────────────────
mkdir -p ~/.config/waybar

# Main Waybar configuration
# Module layout:
#   Left:   workspace switcher + current window title
#   Center: clock
#   Right:  bluetooth | pulseaudio | network | cpu | memory | [battery] | tray | power
#
# Note: the battery module is always included but Waybar hides it automatically
# on machines with no battery — safe to keep for both desktop and laptop.
cat > ~/.config/waybar/config << 'WAYBAR_EOF'
{
    "layer": "top",
    "position": "top",
    "height": 32,
    "spacing": 4,

    "modules-left": [
        "niri/workspaces",
        "niri/window"
    ],
    "modules-center": [
        "clock"
    ],
    "modules-right": [
        "bluetooth",
        "pulseaudio",
        "network",
        "cpu",
        "memory",
        "temperature",
        "battery",
        "tray",
        "custom/power"
    ],

    // ── Niri workspaces ────────────────────────────────────────────────────────
    // Shows a button for each workspace; active one is highlighted via CSS.
    "niri/workspaces": {
        "format": "{name}"
    },

    // ── Niri window title ──────────────────────────────────────────────────────
    "niri/window": {
        "max-length": 60,
        "separate-outputs": true
    },

    // ── Clock ──────────────────────────────────────────────────────────────────
    "clock": {
        "format": "󰃭  {:%H:%M  %d/%m/%Y}",
        "tooltip-format": "<big>{:%A, %d %B %Y}</big>\n<tt><small>{calendar}</small></tt>",
        "calendar": {
            "mode": "year",
            "mode-mon-col": 3,
            "on-scroll": 1,
            "format": {
                "months":     "<span color='#cdd6f4'><b>{}</b></span>",
                "days":       "<span color='#cdd6f4'>{}</span>",
                "weeks":      "<span color='#89b4fa'>W{}</span>",
                "weekdays":   "<span color='#a6e3a1'><b>{}</b></span>",
                "today":      "<span color='#f38ba8'><b>{}</b></span>"
            }
        }
    },

    // ── Bluetooth ──────────────────────────────────────────────────────────────
    // Requires: bluez (installed) + bluetooth.service running (enabled above).
    // Reads state directly from BlueZ via D-Bus — no extra daemon needed.
    //  No adapter detected → module hidden
    //  Adapter off         →  (dimmed via CSS)
    //  On, no devices      →  Bluetooth
    //  Device connected    →  DeviceName [battery% if reported by device]
    "bluetooth": {
        "format": "  {status}",
        "format-disabled": "",
        "format-off": "󰂲  Off",
        "format-on": "󰂯  On",
        "format-connected": "󰂱  {device_alias}",
        "format-connected-battery": "󰂱  {device_alias}  {device_battery_percentage}%",
        "tooltip-format": "Controller: {controller_alias} [{controller_address}]\nStatus: {status}",
        "tooltip-format-connected": "Controller: {controller_alias}\n\nConnected devices:\n{device_enumerate}",
        "tooltip-format-enumerate-connected": "  {device_alias} [{device_address}]",
        "tooltip-format-enumerate-connected-battery": "  {device_alias} [{device_address}]  {device_battery_percentage}%",
        "on-click": "blueman-manager",
        "on-click-right": "rfkill toggle bluetooth"
    },

    // ── Audio (PipeWire via PulseAudio API) ────────────────────────────────────
    //  Normal:  speaker icon + volume %
    //  Muted:   muted speaker icon + "Muted"
    //  Click:   open pavucontrol mixer
    //  Scroll:  adjust volume ±5%
    "pulseaudio": {
        "format": "{icon}  {volume}%",
        "format-muted": "󰝟  Muted",
        "format-bluetooth": "󰂰  {volume}%",
        "format-bluetooth-muted": "󰂲  Muted",
        "format-icons": {
            "headphone": "󰋋",
            "hands-free": "󰋎",
            "headset": "󰋎",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["󰕿", "󰖀", "󰕾"]
        },
        "scroll-step": 5,
        "on-click": "pavucontrol",
        "on-click-right": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
        "tooltip-format": "{desc} — {volume}%"
    },

    // ── Network ────────────────────────────────────────────────────────────────
    // Shows SSID for Wi-Fi or IP for Ethernet; disconnected state shown with icon.
    // Click opens nm-connection-editor.
    "network": {
        "format-wifi": "󰤨  {essid} ({signalStrength}%)",
        "format-ethernet": "󰈀  {ipaddr}/{cidr}",
        "format-disconnected": "󰤭  Disconnected",
        "format-linked": "󰤫  {ifname} (no IP)",
        "tooltip-format": "Interface: {ifname}\nIP: {ipaddr}/{cidr}\nGateway: {gwaddr}\nFrequency: {frequency} GHz\nUp: {bandwidthUpBytes}  Down: {bandwidthDownBytes}",
        "tooltip-format-wifi": "SSID: {essid}\nSignal: {signalStrength}%\nFrequency: {frequency} GHz\nIP: {ipaddr}\nUp: {bandwidthUpBytes}  Down: {bandwidthDownBytes}",
        "on-click": "nm-connection-editor",
        "interval": 5
    },

    // ── CPU ────────────────────────────────────────────────────────────────────
    "cpu": {
        "format": "󰻠  {usage}%",
        "tooltip": true,
        "tooltip-format": "CPU Usage: {usage}%\nLoad: {load}",
        "interval": 3,
        "states": {
            "warning": 70,
            "critical": 90
        }
    },

    // ── Memory ────────────────────────────────────────────────────────────────
    "memory": {
        "format": "󰍛  {used:0.1f}G",
        "tooltip-format": "Used: {used:0.2f} GiB / {total:0.2f} GiB\nSwap: {swapUsed:0.2f} GiB / {swapTotal:0.2f} GiB",
        "interval": 5,
        "states": {
            "warning": 70,
            "critical": 90
        }
    },

    // ── Temperature ────────────────────────────────────────────────────────────
    // Reads from the first available hwmon thermal zone.
    // Adjust "hwmon-path" if the wrong sensor is shown (check /sys/class/hwmon/).
    "temperature": {
        "format": "{icon}  {temperatureC}°C",
        "format-critical": "󰸁  {temperatureC}°C",
        "tooltip-format": "Temperature: {temperatureC}°C",
        "critical-threshold": 80,
        "format-icons": ["󰜗", "󰜗", "󰜗", "󰜗", "󰸁"],
        "interval": 5
    },

    // ── Battery ────────────────────────────────────────────────────────────────
    // Automatically hidden on machines with no battery (safe for desktop).
    "battery": {
        "format": "{icon}  {capacity}%",
        "format-charging": "󰂄  {capacity}%",
        "format-plugged": "󰂄  {capacity}%",
        "format-full": "󰁹  Full",
        "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        "states": {
            "good": 80,
            "warning": 30,
            "critical": 15
        },
        "tooltip-format": "Battery: {capacity}%\nPower draw: {power}W\nTime to {timeTo}: {time}"
    },

    // ── System tray ────────────────────────────────────────────────────────────
    // Shows tray icons from nm-applet, blueman-applet, and other apps.
    "tray": {
        "icon-size": 16,
        "spacing": 8
    },

    // ── Power button ───────────────────────────────────────────────────────────
    // Sends the Niri quit signal. Replace with a logout menu if preferred.
    "custom/power": {
        "format": "⏻",
        "tooltip": false,
        "on-click": "niri msg action quit",
        "on-click-right": "systemctl poweroff"
    }
}
WAYBAR_EOF
success "~/.config/waybar/config written."

# Waybar CSS — Catppuccin Mocha theme
# All icon modules share the same padding/color base; overrides per module
# handle warning and critical states.
cat > ~/.config/waybar/style.css << 'WAYBAR_CSS_EOF'
/* ── Global reset ─────────────────────────────────────────────────────────── */
* {
    font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", monospace;
    font-size: 13px;
    border: none;
    border-radius: 0;
    min-height: 0;
}

/* ── Bar container ────────────────────────────────────────────────────────── */
window#waybar {
    background-color: rgba(30, 30, 46, 0.92);   /* Catppuccin Mocha base */
    color: #cdd6f4;                              /* Catppuccin text */
    border-bottom: 2px solid #89b4fa;           /* blue accent */
    transition-property: background-color;
    transition-duration: 0.5s;
}

/* ── Workspace buttons ────────────────────────────────────────────────────── */
#workspaces button {
    padding: 0 8px;
    color: #6c7086;               /* dimmed — inactive workspaces */
    background: transparent;
    border-radius: 4px;
    margin: 4px 2px;
    transition: all 0.2s ease;
}

#workspaces button.active {
    color: #cdd6f4;               /* bright — focused workspace */
    background-color: #313244;   /* surface overlay */
    border-radius: 4px;
}

#workspaces button:hover {
    background: rgba(137, 180, 250, 0.15);
    color: #89b4fa;
}

/* ── Window title ─────────────────────────────────────────────────────────── */
#window {
    padding: 0 10px;
    color: #a6adc8;               /* slightly dimmed for hierarchy */
    font-style: italic;
}

/* ── Shared module styles ─────────────────────────────────────────────────── */
#clock,
#bluetooth,
#pulseaudio,
#network,
#cpu,
#memory,
#temperature,
#battery,
#tray,
#custom-power {
    padding: 0 12px;
    color: #cdd6f4;
    margin: 4px 0;
}

/* ── Bluetooth states ─────────────────────────────────────────────────────── */
#bluetooth {
    color: #89b4fa;               /* blue when on */
}

#bluetooth.disabled,
#bluetooth.off {
    color: #45475a;               /* dimmed when off/disabled */
}

#bluetooth.connected {
    color: #a6e3a1;               /* green when a device is connected */
}

/* ── Audio states ─────────────────────────────────────────────────────────── */
#pulseaudio.muted {
    color: #45475a;               /* dimmed when muted */
}

/* ── Network states ───────────────────────────────────────────────────────── */
#network.disconnected {
    color: #f38ba8;               /* red when offline */
}

/* ── CPU warning / critical ───────────────────────────────────────────────── */
#cpu.warning {
    color: #fab387;               /* orange at 70%+ */
}

#cpu.critical {
    color: #f38ba8;               /* red at 90%+ */
    font-weight: bold;
}

/* ── Memory warning / critical ────────────────────────────────────────────── */
#memory.warning {
    color: #fab387;
}

#memory.critical {
    color: #f38ba8;
    font-weight: bold;
}

/* ── Temperature states ───────────────────────────────────────────────────── */
#temperature.critical {
    color: #f38ba8;
    background-color: rgba(243, 139, 168, 0.15);
}

/* ── Battery states ───────────────────────────────────────────────────────── */
#battery.good {
    color: #a6e3a1;               /* green when charged */
}

#battery.warning {
    color: #fab387;               /* orange at 30% */
}

#battery.critical:not(.charging) {
    color: #f38ba8;               /* red at 15% */
    animation: blink 0.5s steps(12) infinite;
}

#battery.charging,
#battery.plugged {
    color: #a6e3a1;               /* green while charging */
}

/* ── Power button ─────────────────────────────────────────────────────────── */
#custom-power {
    color: #f38ba8;
    padding: 0 14px;
    font-size: 14px;
}

#custom-power:hover {
    background-color: rgba(243, 139, 168, 0.15);
    border-radius: 4px;
}

/* ── Blink animation (critical battery) ──────────────────────────────────── */
@keyframes blink {
    to { color: #f38ba8; background-color: transparent; }
}
WAYBAR_CSS_EOF
success "~/.config/waybar/style.css written."

# ── Mako ──────────────────────────────────────────────────────────────────────
mkdir -p ~/.config/mako

cat > ~/.config/mako/config << 'MAKO_EOF'
# Mako notification daemon configuration
# Catppuccin Mocha palette

# Appearance
background-color=#1e1e2e
text-color=#cdd6f4
border-color=#89b4fa
border-radius=8
border-size=2
width=350
height=110
margin=10
padding=12
font=JetBrainsMono Nerd Font 11

# Behavior
default-timeout=5000     # auto-dismiss after 5 seconds
ignore-timeout=0         # honor app-provided timeouts

# Icons
icon-path=/usr/share/icons/hicolor:/usr/share/icons/Adwaita

# High-urgency notifications (e.g. low battery, critical errors)
# Never auto-dismiss and use a red border to stand out
[urgency=high]
border-color=#f38ba8
default-timeout=0
MAKO_EOF
success "~/.config/mako/config written."

# ── Fuzzel ────────────────────────────────────────────────────────────────────
mkdir -p ~/.config/fuzzel

cat > ~/.config/fuzzel/fuzzel.ini << 'FUZZEL_EOF'
# Fuzzel application launcher configuration
# Catppuccin Mocha palette

[main]
font=JetBrainsMono Nerd Font:size=11
terminal=alacritty
# Render on the overlay layer so it appears above all windows
layer=overlay
# Dismiss when focus is lost (click outside the launcher)
exit-on-keyboard-focus-loss=yes
# Show 8 results at a time
lines=8
# Width as a fraction of the screen width
width=35

[colors]
# Format: RRGGBBaa (alpha suffix)
background=1e1e2edd        # base + slight transparency
text=cdd6f4ff
match=89b4faff             # matched characters highlighted in blue
selection=313244ff         # selected entry background
selection-text=cdd6f4ff
border=89b4faff

[border]
width=2
radius=8

[dmenu]
exit-immediately-if-empty=no
FUZZEL_EOF
success "~/.config/fuzzel/fuzzel.ini written."

# ── Alacritty ─────────────────────────────────────────────────────────────────
mkdir -p ~/.config/alacritty

cat > ~/.config/alacritty/alacritty.toml << 'ALACRITTY_EOF'
# Alacritty terminal configuration
# Catppuccin Mocha theme — matches Waybar and Mako

[window]
padding = { x = 10, y = 10 }
# "None" removes the server-side title bar; Niri draws the focus ring instead
decorations = "None"
# Slight transparency — set to 1.0 for fully opaque
opacity = 0.95

[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
bold   = { family = "JetBrainsMono Nerd Font", style = "Bold" }
italic = { family = "JetBrainsMono Nerd Font", style = "Italic" }
size = 11.0

# ── Catppuccin Mocha color scheme ─────────────────────────────────────────────
[colors.primary]
background = "#1e1e2e"    # base
foreground = "#cdd6f4"    # text

[colors.cursor]
text   = "#1e1e2e"
cursor = "#f5e0dc"        # rosewater

[colors.normal]
black   = "#45475a"       # surface1
red     = "#f38ba8"       # red
green   = "#a6e3a1"       # green
yellow  = "#f9e2af"       # yellow
blue    = "#89b4fa"       # blue
magenta = "#f5c2e7"       # pink
cyan    = "#94e2d5"       # teal
white   = "#bac2de"       # subtext1

[colors.bright]
black   = "#585b70"       # surface2
red     = "#f38ba8"
green   = "#a6e3a1"
yellow  = "#f9e2af"
blue    = "#89b4fa"
magenta = "#f5c2e7"
cyan    = "#94e2d5"
white   = "#a6adc8"       # subtext0
ALACRITTY_EOF
success "~/.config/alacritty/alacritty.toml written."

# ── 8. Swaylock configuration ─────────────────────────────────────────────────
header "8. Swaylock configuration"

# Swaylock needs a config file to apply colors; otherwise it shows a plain grey screen.
# This matches the Catppuccin Mocha theme used throughout.
mkdir -p ~/.config/swaylock

cat > ~/.config/swaylock/config << 'SWAYLOCK_EOF'
# Swaylock screen locker configuration
# Catppuccin Mocha palette

# Show clock (requires swaylock-effects fork — omit if not installed)
# clock
# timestr=%H:%M
# datestr=%A, %d %B

# Background and ring colors
color=1e1e2e
ring-color=89b4fa
ring-ver-color=a6e3a1
ring-wrong-color=f38ba8
ring-clear-color=fab387

inside-color=1e1e2e
inside-ver-color=313244
inside-wrong-color=1e1e2e
inside-clear-color=1e1e2e

key-hl-color=89b4fa
bs-hl-color=f38ba8
text-color=cdd6f4
text-clear-color=fab387
text-ver-color=a6e3a1
text-wrong-color=f38ba8

line-uses-ring

# Hide typing indicator
indicator-radius=100
indicator-thickness=8

# Image (optional — uncomment and set path to use a lock screen wallpaper)
# image=/path/to/wallpaper.jpg
SWAYLOCK_EOF
success "~/.config/swaylock/config written."

# ── 9. Verify Niri GDM session entry ─────────────────────────────────────────
header "9. Verifying GDM session entry"

if [[ -f /usr/share/wayland-sessions/niri.desktop ]]; then
    success "niri.desktop found in /usr/share/wayland-sessions/ — Niri will appear in GDM."
else
    warn "niri.desktop NOT found in /usr/share/wayland-sessions/"
    warn "The niri package may not have installed the session file."
    warn "Check with: rpm -ql niri | grep desktop"
    warn "You can create it manually if needed."
fi

# ── Final summary ─────────────────────────────────────────────────────────────
header "Installation complete"

echo ""
echo -e "${GREEN}Everything is ready. Follow these steps to start using Niri:${NC}"
echo ""
echo -e "  ${BOLD}1. Reboot your system.${NC}"
if $IS_DESKTOP; then
    echo "     → On the desktop, wait ~5 minutes after boot before logging in"
    echo "       so akmod can finish compiling the Nvidia kernel module."
    echo "       You can check progress with: journalctl -f | grep akmod"
fi
echo ""
echo -e "  ${BOLD}2. At the GDM login screen:${NC}"
echo "     → Click the gear icon (bottom right) and select 'Niri'."
echo "     → Then enter your password."
echo ""
echo -e "  ${BOLD}3. Find your monitor name:${NC}"
echo "     → Open a terminal with Super+Enter and run:"
echo "         niri msg outputs"
echo "     → Copy the connector name (e.g. DP-1, HDMI-A-1, eDP-1) and"
echo "       replace PLACEHOLDER in:"
echo "         ~/.config/niri/config.kdl"
echo ""
echo -e "  ${BOLD}4. Reload the Niri config (no restart needed):${NC}"
echo "     → Niri watches the config file and reloads it on save."
echo "     → Validate the config without a session: niri validate"
echo ""
echo -e "  ${BOLD}5. Bluetooth:${NC}"
echo "     → Open Bluetooth manager with Super+B or click the Waybar icon."
echo "     → Right-click the Waybar bluetooth icon to toggle the adapter on/off."
echo ""
if $IS_DESKTOP; then
    echo -e "  ${YELLOW}Nvidia VRAM workaround:${NC}"
    echo "     → Idle VRAM usage should be ~100 MiB, not ~1 GiB."
    echo "     → Monitor with: nvtop"
    echo "     → If VRAM is still high after login, log out and back in."
    echo ""
fi
echo -e "  ${BOLD}Config files created:${NC}"
echo "    ~/.config/niri/config.kdl                          (compositor)"
echo "    ~/.config/waybar/config                            (status bar modules)"
echo "    ~/.config/waybar/style.css                         (status bar theme)"
echo "    ~/.config/mako/config                              (notifications)"
echo "    ~/.config/fuzzel/fuzzel.ini                        (app launcher)"
echo "    ~/.config/alacritty/alacritty.toml                 (terminal)"
echo "    ~/.config/swaylock/config                          (screen locker)"
echo "    ~/.config/fontconfig/99-jetbrainsmono-nf-default.conf  (system default font)"
echo ""
echo -e "  ${BOLD}Key bindings cheatsheet:${NC}"
echo "    Super+Enter       Open terminal"
echo "    Super+D           Open app launcher (Fuzzel)"
echo "    Super+B           Open Bluetooth manager"
echo "    Super+N           Open Network connections"
echo "    Super+Shift+Q     Close window"
echo "    Super+Shift+L     Lock screen"
echo "    Super+Shift+E     Quit Niri"
echo "    Super+H/J/K/L     Move focus (vim keys)"
echo "    Super+Shift+H/L   Move column left/right"
echo "    Super+R           Cycle preset column widths"
echo "    Super+F           Maximize column"
echo "    Super+Shift+F     Fullscreen window"
echo "    Super+1-5         Switch workspace"
echo "    Super+Shift+1-5   Move window to workspace"
echo "    Print             Screenshot (area selection)"
echo "    Super+Print       Screenshot focused window"
echo ""
echo -e "${BLUE}Enjoy Niri!${NC}"
