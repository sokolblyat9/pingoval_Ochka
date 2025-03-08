#!/bin/bash

function Proverka_OS {
    os_info=$(uname -a)
    if [[ $os_info == *"Debian"* || $os_info == *"Ubuntu"* ]]; then
        sudo apt update && sudo apt upgrade -y && sudo apt install -y parallel
    elif [[ $os_info == *"Linux calculate"* ]]; then
        cl-update && sudo emerge sys-process/parallel
    else
        echo "Ты используешь хуй знает что..."
    fi
}
Proverka_OS

function V_Potoke {
    while true; do
        read -p "Выбери количество потоков при пинге (от 1 до 252): " potok

        if [[ $potok -ge 1 && $potok -le 252 ]]; then
            echo -e "Будем пинговать с $potok потоком"
            break
        else
            echo "Выбери число от 1 до 252"
        fi
    done
}

V_Potoke

function Display_menu_punkt {
    echo "Выбери чо нибудь"
    options=("Пинганем сеть 192.168.0.1-192.168.0.254" "Выход")
    for i in "${!options[@]}"; do
        option_number=$((i+1))
        option_text="${options[i]}"
        echo "$option_number) $option_text"
    done
    echo -n "Вы выбрали (1-${#options[@]}): "
}

spinner() {
  local pid=$1
  local spinner=('|' '/' '-' '\\')

  while kill -0 $pid 2>/dev/null; do
    for s in "${spinner[@]}"; do
      echo -ne "\r$s"
      sleep 0.1
    done
  done
}

function Ping {
    ip_addresses=()
    temp_file=$(mktemp)

    while true; do
        Display_menu_punkt
        read -n 1 -s vybor
        echo
        case $vybor in
            1)
                echo "Пинганем сетОЧКУ"
                seq 1 254 | parallel -j $potok 'ip=192.168.0.{}; if ping -c 4 -W 4 $ip > /dev/null; then echo $ip доступен; fi' > "$temp_file" 2>&1 & 
                ping_pid=$!
                spinner "$ping_pid"
                wait ping_pid
                echo

                while IFS= read -r line; do
                    if [[ $line == *"доступен"* ]]; then
                        echo "$line"
                        ip="${line% доступен}"
                        ip_addresses+=("$ip")
                    fi
                done < "$temp_file"

                echo "Доступные IP-адреса: ${ip_addresses[*]}"
                ;;
            2)
                echo "Доступные IP-адреса: ${ip_addresses[*]}"
                echo "Выйдем из скрипта, аривидерчи!"
                rm -f "$temp_file"
                return
                ;;
            *)
                echo "Ты выбрал хуйню, выбери че нибудь другое"
                ;;
        esac
    done
}

Ping
