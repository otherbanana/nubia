#!/bin/bash
export PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"

ssh_key() {
    mkdir -p /root/.ssh
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuwLr5N5CxF51tEOXtJJ3Qr2+uY7lVtZfWNwN59yewWUhc6p77CiWj917TrOgrgGMIIgb7AXU0vrdNr2IFJ0fNdyF9S9dfEU8+KAqr+FUH7ywQ8b2sktbqTyVLEZ/lVcd7/+KPxFIP7L7UILqEIIx0rGPVAax8UEwLtMlJ1fakPL98UMTx94hQ2ZW8LW6MJsKd2RWoMkbsn0Joif3SiUGCeGcY8IDzQC8xUZQPFJxVkHqj5Z4iDqms8TNNaKYp7nirTTGHiFW0x7uSAoBxXqKur+c0JLc3ABi5FIlC3+yVtwVr7l4/eHK7bRb/iERoMNEyVF22U5Sha41NQZquDitF root@localhost' > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    sed -i '/ChallengeResponseAuthentication/d' /etc/ssh/sshd_config
    sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
    sed -i '/Port /d' /etc/ssh/sshd_config
    echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
    echo 'Port 22' >> /etc/ssh/sshd_config
    systemctl restart sshd
}

person_bin() {
    echo -e '#!/bin/bash\niptables -t nat -S' > /bin/ins
    echo -e '#!/bin/bash\niptables -t mangle -S' > /bin/ims
    echo -e '#!/bin/bash\niptables -t raw -S' > /bin/irs
    echo -e '#!/bin/bash\niptables -S' > /bin/ifs
    echo -e '#!/bin/bash\niptables -t nat -F' > /bin/inf
    echo -e '#!/bin/bash\niptables -t mangle -F' > /bin/imf
    echo -e '#!/bin/bash\niptables -t raw -F' > /bin/irf
    echo -e '#!/bin/bash\niptables -F' > /bin/iff
    echo -e '#!/bin/bash' > /bin/dk
    echo -e "input=\"\$1\"\nRED=\"\\\033[31m\"\nGREEN=\"\\\033[32m\"\nYELLOW=\"\\\033[33m\"\nBLUE=\"\\\033[36m\"\n\ncolorEcho(){\n    COLOR=\$1\n    echo -e \"\${COLOR}\${@:2}\\\033[0m\"\n}\n\nif echo \"\$input\" | grep -q \"^[0-9][0-9]*\\\\$\";then\n    info=\$(netstat -anp | grep -E \"^tcp|^udp\" | grep \"LISTEN\" | grep \":\$input\" | awk '{print \$4\"   \"\$7}')\nelse\n    info=\$(netstat -anp | grep -E \"^tcp|^udp\" | grep \"LISTEN\" | grep \"\$input\" | awk '{print \$4\"   \"\$7}')\nfi\n\nfor loop in \$(seq 1 \$(echo -e \"\$info\" | wc -l));do\n    PID=\$(echo -e \"\$info\" | sed -n \"\${loop}p\" | sed \"s|.* \\\([0-9]*\\\)/.*|\\\1|\")\n    process=\$(echo -e \"\$info\" | sed -n \"\${loop}p\" | awk -F \"/\" '{print \$NF}')\n    listen_info=\$(echo -e \"\$info\" | sed -n \"\${loop}p\" | awk '{print \$1}')\n    connection=\$(ss -o state established sport = :\${listen_info##*:} | awk '{print \$5}' | grep -Eo '([0-9]{1,3}\\\.){3}[0-9]{1,3}' | sort -u | wc -l)\n    [ -z \"\$info\" ] || colorEcho \${YELLOW} \"\$process  \$PID  \$listen_info  \$connection\"\ndone" >> /bin/dk
    chmod +x /bin/i* /bin/dk
}

rc_local() {
    echo -e '[Unit]\nDescription=/etc/rc.local\nConditionPathExists=/etc/rc.local\n\n[Service]\nType=forking\nExecStart=/etc/rc.local start\nTimeoutSec=0\nStandardOutput=tty\nRemainAfterExit=yes\nSysVStartPriority=99\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/rc-local.service
    chmod +x /etc/systemd/system/rc-local.service
    systemctl daemon-reload
    echo -e '#!/bin/sh -e\nexit 0' > /etc/rc.local
    chmod +x /etc/rc.local
    systemctl enable rc-local
} >/dev/null 2>&1

set_bash() {
    cd /root
    country=$(curl -sL http://ip-api.com/json | sed 's|.*"countryCode":"\(..\)".*|\1|')
    system="debian" && command -v yum >/dev/null && system="centos"
    sed -i '/JZDH/d' .bashrc
    echo -e "PS1='\\\n\\\[\\\e[47;30m\\\][$country]\\\u@$system\\\[\\\e[m\\\]:[\$(pwd)]\\\n\\\\$ ' #JZDH" >> .bashrc
    echo 'LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:" #JZDH' >> .bashrc
    echo 'alias ls="ls --color=auto" #JZDH' >> .bashrc
    echo 'alias vi="vim" #JZDH' >> .bashrc
    echo 'alias grep="grep --color=auto" #JZDH' >> .bashrc
    echo "clear #JZDH" >> .bashrc
    chmod 644 .bashrc
}

clean_iptables(){
    [ -f "/etc/systemd/system/clean_iptables.service" ] && return 0
    echo -e '#!/bin/bash\nexport PATH="/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin"' > /bin/clean_iptables
    chmod 755 /bin/clean_iptables
    for chain in filter nat mangle raw;do
        iptables -t $chain -S | grep "\-[AI] " | sed "s|-[AI] |-D |g;s|^|iptables -t $chain |g" >> /bin/clean_iptables
        iptables -t $chain -S | grep "\-N " | sed "s|-N |-X |g;s|^|iptables -t $chain |g" >> /bin/clean_iptables
    done
    echo -e "[Unit]\nDescription=clean_iptables Service\nAfter=network.target\n\n[Service]\nType=forking\nExecStart=/bin/clean_iptables\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/clean_iptables.service
    systemctl daemon-reload
    systemctl enable clean_iptables.service
    clean_iptables
} >/dev/null 2>&1

install_software(){
    if command -v apt-get;then
        apt-get update
        apt-get install curl wget sudo jq qrencode file tree locales git iproute net-tools make unzip tar zip vim dnsutils -y
    elif command -v yum;then
        yum install epel-release sudo qrencode curl file tree wget git iproute net-tools jq locales make unzip tar zip vim bind-utils -y
    fi
} >/dev/null 2>&1

clean_aliyun(){
    for clean in $(find / -name *[Aa][Ll][Ii][Yy][Uu][Nn]* | grep -v "_bak");do
        mv $clean ${clean}_bak
    done
} >/dev/null 2>&1

main() {
    install_software
    clean_iptables
    clean_aliyun
    ssh_key
    person_bin
    rc_local
    set_bash
}

main
