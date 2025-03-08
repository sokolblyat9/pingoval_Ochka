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





function Proverka_ystanovki_ipcalc {
    echo "Проверю на наличие пакета ipcalc"
    vyvod=$(ipcalc --version)
        if [[ $os_info == *"Debian"* || $os_info == *"Ubuntu"* ]]; then
            if [[ $vyvod == "*команда не найдена*" ]]; then
                sudo apt install ipcalc
            fi
        elif [[ $os_info == *"MANJARO"* ]]; then
            if [[ $vyvod == "*команда не найдена*" ]]; then
                sudo pacman -S ipcalc
            fi
        else
            echo "IPCALC установлен"
        fi
}

Proverka_ystanovki_ipcalc




function Sbor_dannyh_iz_ipcalc {
    read -p "Впиши какую подсеть ты хочешь пингануть. Например: 192.168.0.0/24: " ipishnik_s_maskoy
        echo Hostmin=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}') && echo HostMax=$(ipcalc $ipishnik_s_maskoy | grep HostMax | awk '{print $2}') && echo Broadcast=$(ipcalc $ipishnik_s_maskoy | grep Broadcast | awk '{print $2}')
        temp_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}' | cut -d '.' -f 1)
        temp_min_ip_two_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}' | cut -d '.' -f 2)
        temp_max_ip_two_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMax | awk '{print $2}' | cut -d '.' -f 2)
        temp_min_ip_three_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}' | cut -d '.' -f 3)
        temp_max_ip_three_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMax | awk '{print $2}' | cut -d '.' -f 3)
        temp_min_ip_four_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}' | cut -d '.' -f 4)
        temp_max_ip_four_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMax | awk '{print $2}' | cut -d '.' -f 4)
        read -p "Вы хотите пингануть $HostMin - $HostMax адреса?" pinging
}
Sbor_dannyh_iz_ipcalc





function Ping_Seti {

shopt -s nocasematch
    case $pinging in
        да|yes|нуа|lf)
            if [[ $temp_oktet == 10 ]]; then
                seq $temp_min_ip_two_oktet $temp_max_ip_two_oktet | while read second_oktet; do
                    seq $temp_min_ip_three_oktet $temp_max_ip_three_oktet | while read third_oktet; do
                        seq $temp_min_ip_four_oktet $temp_max_ip_four_oktet | parallel -j $potok ping -c5 -W 5 10.${second_oktet}.${third_oktet}.{}
                        done
                    done

            elif [[ $temp_oktet == 100 ]]; then
                seq $temp_min_ip_two_oktet $temp_max_ip_two_oktet | while read second_oktet; do
                    seq $temp_min_ip_three_oktet $temp_max_ip_three_oktet | while read third_oktet; do
                        seq $temp_min_ip_four_oktet $temp_max_ip_four_oktet | parallel -j $potok ping -c5 -W 5 100.${second_oktet}.${third_oktet}.{}
                        done
                    done

            elif [[ $temp_oktet == 172 ]]; then
                seq $temp_min_ip_two_oktet $temp_max_ip_two_oktet | while read second_oktet; do
                    seq $temp_min_ip_three_oktet $temp_max_ip_three_oktet | while read third_oktet; do
                        seq $temp_min_ip_four_oktet $temp_max_ip_four_oktet | parallel -j $potok ping -c5 -W 5 172.${second_oktet}.${third_oktet}.{}
                        done
                    done

            elif [[ $temp_oktet == 192 ]]; then
                seq $temp_min_ip_three_oktet $temp_max_ip_three_oktet | while read third_oktet; do
                    seq $temp_min_ip_four_oktet $temp_max_ip_four_oktet | parallel -j $potok ping -c5 -W 5 192.168.${third_oktet}.{}
                    done
            fi
            ;;

        нет|ytn|тщ|no)
            printf "что же ты тогда хочешь шьорт побъери???\nПопробуем еще раз..."
            Sbor_dannyh_iz_ipcalc
            ;;
        *)
            echo "Ты ошибся другалёчек"
            ;;
    esac
shopt -u nocasematch
}
Ping_Seti





function Vblvod-infbl {



}
Vblvod-infbl



