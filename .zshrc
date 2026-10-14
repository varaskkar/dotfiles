##################################
# Plugins - Oh My ZSH
##################################
plugins=(git colored-man colorize extract zsh-syntax-highlighting zsh-autosuggestions zsh-256color zsh-notify zsh-url-highlighter auto-fu zsh-completions zsh-interactive-cd)
export ZSH=/home/varaskkar/.config/oh-my-zsh
source $ZSH/oh-my-zsh.sh


##################################
# Themes - Starship                         ~/.config/starship.toml             Esta vacio porque asi uso el theme por defecto
##################################          Mas Themes ->                       https://starship.rs/presets/catppuccin-powerline
eval "$(starship init zsh)"


##################################
# Funciones
##################################
# Desactivar shortcuts: Ctrl+D , Ctrl+T , Alt+C , Ctrl+R
set -o ignoreeof
bindkey -r '^T'
bindkey -r '^[c'
bindkey -r '^R'

buscar_palabras() {
    fzf --exact \
        --disabled \
        --query "" \
        --height 85% \
        --reverse \
        --ansi \
        --bind 'change:reload:rg --line-number --no-heading --color=always --smart-case --hidden {q} || true' \
        --preview-window down:12:wrap \
        --bind 'ctrl-b:toggle-preview' \
        --preview '
            file=$(echo {} | cut -d: -f1)
            line=$(echo {} | cut -d: -f2)
            [ -f "$file" ] && bat --style=numbers --color=always --highlight-line $line --line-range $((line>10?line-10:0)):$((line+50)) "$file"
        ' \
        --bind 'enter:execute-silent(
            file=$(echo {} | cut -d: -f1)
            line=$(echo {} | cut -d: -f2)
            subl "$file:$line"
        )'
    zle reset-prompt
}
zle -N buscar_palabras
bindkey '^S' buscar_palabras

buscar_ficheros() {
    fzf --exact \
        --query "" \
        --height 85% \
        --reverse \
        --ansi \
        --bind 'change:reload(fd --type f --hidden --follow {q} || true)' \
        --preview 'bat --style=numbers --color=always --line-range :500 {}' \
        --preview-window down:12:wrap:hidden \
        --bind 'ctrl-b:toggle-preview' \
        --bind 'enter:execute-silent(echo {} | tr -d "'\''" | xargs -I_ subl "_")'
    zle reset-prompt
}
zle -N buscar_ficheros
bindkey '^F' buscar_ficheros

buscar_carpetas() {
    fzf --exact \
        --query "" \
        --height 85% \
        --reverse \
        --ansi \
        --bind 'change:reload(~/scripts/buscar_carpetas.sh {q} || true)' \
        --preview-window right:60:wrap:hidden \
        --bind 'ctrl-b:toggle-preview' \
        --bind 'enter:execute(dolphin {} &)'
    zle reset-prompt
}
zle -N buscar_carpetas
bindkey '^D' buscar_carpetas

buscar_historial() {
    local comando=$(fc -lnr 1 | sed 's/^[ \t]*//' | awk '!x[$0]++' | fzf \
        --height 30% \
        --reverse \
        --preview 'echo {}' \
        --preview-window down:3:wrap:hidden \
        --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)+abort')
    if [ -n "$comando" ]; then
        LBUFFER="$comando"
    fi
    zle reset-prompt
}
zle -N buscar_historial
bindkey '^H' buscar_historial

grant() { sudo chmod 755 -R "$1" && sudo chown $USER:$USER -R "$1" }
text() { tesseract $1 output.txt }


# =========================================================
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'




##################################
# Ajustes
##################################

# Git - Cargar Clave SSH
# if [ -z "$SSH_AUTH_SOCK" ] || ! ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
#     eval "$(ssh-agent -s)" >/dev/null
#     ssh-add ~/.ssh/tpfedora_github 2>/dev/null
# fi


# Conky - Cargar Plugins
USER=$(whoami)
if [ $USER = "varaskkar" ]
then

	# Si conky no esta ejecutandose, lo ejecuto
	if pgrep -x "conky" > /dev/null
	then

	else
		# conky -c "$HOME/.config/conky/stats"
		# conky -c "$HOME/.config/conky/ConkySideralEsp"
		# conky -c "$HOME/.config/conky/musica"
	fi

	# xx

	clear
fi


##################################
# Alias
##################################
#
# alias disk="broot --sort-by-size --whale-spotting"
# alias ls="broot -sdp"
# alias fs="broot --cmd :fs"
# alias nano="micro"
#
# Faltan: zoxide
#
# alias man="tldr"
alias info="hostnamectl status"
alias info2="fastfetch"
alias info3="sudo auto-cpufreq --stats"
alias fs="lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINTS,UUID"
alias fs="duf -only local"
alias ls="eza --group-directories-first"
alias ll="eza -la --icons --group-directories-first --total-size"
alias tree="eza --tree --level=2 --icons"
alias tree2="broot -s"
alias disk="diskonaut"
alias disk2="disktree"
alias disk3="dust"
alias disk4="broot --sort-by-size --whale-spotting"
alias disk5="du -d 1 -h | sort -h"
alias disk6="sudo btrfs filesystem usage /"
alias process="btm --battery --process_memory_as_value"
alias lg="lazygit"
alias cat="bat"
alias image="imgur.sh"
alias password="tr -dc 'A-Za-z0-9!#$%&'\''()*+,-./:;<=>?@[\]^_{|}~' </dev/urandom | head -c 13  ; echo"
alias web="curl -v -l"
alias myip="curl ifconfig.me"
alias update="sudo dnf upgrade"
alias install="sudo dnf install"
alias remove="sudo dnf remove"
alias search="sudo dnf search"
alias p="ping 8.8.8.8"
alias log="journalctl -f"
alias log2="journalctl -xe"
alias k="kill -9"
alias ka="killall"
alias ascii="figlet -d ~/.local/share/figlet -f ansi_shadow"
alias webcam="mpv av://v4l2:/dev/video0 --fullscreen --profile=low-latency --untimed"
alias webcamir="mpv av://v4l2:/dev/video2 --fullscreen --profile=low-latency --untimed"
alias mocp='mocp -M ~/.config/moc'

alias glog='PAGER="less -F -X" git log'                              # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'
alias dotfiles='git --git-dir=$HOME/projects/.dotfiles --work-tree=$HOME'


# alias clean="sudo fstrim -av && update-desktop-database ~/.local/share/applications/"
# alias clean="update-desktop-database ~/.local/share/applications/"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias clean="update-desktop-database ~/.local/share/applications/ && \
             gtk-update-icon-cache -f -t ~/.local/share/icons/ 2>/dev/null; \
             gtk-update-icon-cache -f -t ~/.icons/ 2>/dev/null; \
             echo '🔄 Recargando configuración de Zsh...'; \
             exec zsh"

# Docker
alias up="docker-compose up -d"
alias down="docker-compose down"9

# === Descargas - Individuales ===
alias video="yt-dlp --js-runtimes node --no-playlist -f '(bestvideo[ext=mkv]/bestvideo)+(bestaudio[ext=m4a]/bestaudio)/best' --merge-output-format mkv --embed-subs --embed-thumbnail --sub-langs 'all' -o '\$HOME/downloads/%(title)s.%(ext)s'"
alias audio="yt-dlp --js-runtimes node --no-playlist -f 'bestaudio' --extract-audio --audio-format opus --embed-thumbnail -o '\$HOME/downloads/%(title)s.%(ext)s'"

# === Descargas - Listas de Reproduccion ===
alias videos="yt-dlp --js-runtimes node --yes-playlist -f '(bestvideo[ext=mkv]/bestvideo)+(bestaudio[ext=m4a]/bestaudio)/best' --merge-output-format mkv --embed-subs --embed-thumbnail --sub-langs 'all' -o '\$HOME/downloads/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s'"
alias audios="yt-dlp --js-runtimes node --yes-playlist -f 'bestaudio' --extract-audio --audio-format opus --embed-thumbnail -o '\$HOME/downloads/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s'"

# Ubicados en ~/scripts
alias torrent="superseedr"
alias tv="iptv.sh"
alias format="formatear.sh"
alias backup="backup.sh"
play() {
    if [ "$1" = "normal" ]; then
        cliamp --provider youtube https://www.youtube.com/watch\?v\=PDRj-7UBQuk\&list\=PLTejc9bVUCWgDMJPYNopsVEBwtrNUW6ab
    elif [ "$1" = "rap" ]; then
        cliamp --provider youtube https://www.youtube.com/watch?v=GU_OIiu0OLA&list=PLZClxAF5JhUk
    elif [ "$1" = "anime" ]; then
        cliamp --provider youtube "https://www.youtube.com/watch?v=9DJlKmw8TSM&list=PLTejc9bVUCWjdQrFQkwaKhXK6732ZU0Gl&index=1"
    else
        cliamp "$@"
    fi
}



alias dd="tmux ls | cut -d : -f 1 | xargs -I {} tmux kill-session -t {}"

alias xx="  tmux new -d -s Principal &&

            tmux rename-window 'Ocio' &&
            tmux split-window -v && tmux send-keys 'rtorrent' 'C-m' &&
            tmux select-pane -U && tmux split-window -h && tmux send-keys 'reset' 'C-m' && tmux send-keys 'clear' 'C-m' && tmux send-keys 'mocp' 'C-m' &&
            tmux select-pane -L && tmux resize-pane -R 15 && tmux send-keys 'reset' 'C-m' &&

            tmux new-window && tmux rename-window 'Monitor' &&
            tmux send-keys 'btm --battery --mem_as_value' 'C-m' &&

            tmux new-window && tmux rename-window 'Mercado' &&
            tmux send-keys 'cointop' 'C-m' &&

            tmux new-window && tmux rename-window 'Docker' &&
            tmux send-keys 'ctop' 'C-m' &&

            tmux new-window && tmux rename-window 'Servidor' &&

            tmux new-window && tmux rename-window 'Log' &&

            tmux new-window && tmux rename-window 'VPN' &&

            tmux new-window && tmux rename-window 'Recursos' &&
            tmux split-window -h && tmux select-pane -L &&

            tmux select-window -t 'Ocio' &&
            tmux attach -t Principal
         "




##################################
# Variables de Entorno                      Refrescar los cambios con > source ~/.zshrc
##################################
export SSH_HOME="$HOME/.config/ssh"
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/scripts/liferay:$PATH"

# export PATH=$HOME/.sdk/node/10.15.1/bin/:$PATH
# export PATH=$HOME/.sdkman/candidates/java/8.0.342-amzn/jre:$PATH
# export PATH=$HOME/.sdkman/candidates/java/8.0.342-amzn/jre/bin:$PATH
#
# JAVA_VERSION="17.0.6-amzn"

# export JAVA_HOME=/bin/java
# export GRADLE_HOME=/bin/gradle
# export M2_HOME=/bin/mvn

# export JAVA_HOME=/.sdkman/candidates/java/$JAVA_VERSION/bin
# export PATH=$HOME/.sdkman/candidates/java/$JAVA_VERSION/bin:$PATH
# export JRE_HOME=$HOME/.sdkman/candidates/java/8.0.342-amzn/jre




