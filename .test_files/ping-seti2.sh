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
        temp_broadcast=$(ipcalc $ipishnik_s_maskoy | grep Broadcast | awk '{print $2}')
        read -p "Вы хотите пингануть $HostMin - $HostMax адреса?" pinging
}
Sbor_dannyh_iz_ipcalc





function Ping_Seti {
massiv_ip_adresov=()
shopt -s nocasematch
    case $pinging in
        да|yes|нуа|lf)
            if [[ $temp_oktet == 10 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                    do
                        for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k ++))
                        do
                            ip_adresa="$temp_oktet.$i.$j.$k"
                            massiv_ip_adresov+=("$ip_adresa")
                            #echo "${massiv_ip_adresov[@]}"

                        done
                    done
                done

#Тоже хорошее решение как в строке ниже для сортировки массива
#for ip in "${massiv_ip_adresov[@]}"
#do
#    echo "$ip"
#done

                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V



            elif [[ $temp_oktet == 100 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                    do
                        for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k ++))
                        do
                            ip_adresa="$temp_oktet.$i.$j.$k"
                            massiv_ip_adresov+=("$ip_adresa")
                            #echo "${massiv_ip_adresov[@]}"

                        done
                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

            elif [[ $temp_oktet == 172 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                    do
                        for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k ++))
                        do
                            ip_adresa="$temp_oktet.$i.$j.$k"
                            massiv_ip_adresov+=("$ip_adresa")
                            #echo "${massiv_ip_adresov[@]}"

                        done
                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

            elif [[ $temp_oktet == 192 ]]; then
                for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                do
                    for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k ++))
                    do
                        ip_adresa="$temp_oktet.168.$j.$k"
                        massiv_ip_adresov+=("$ip_adresa")
                        #echo "${massiv_ip_adresov[@]}"
                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V


            fi
        ;;
        нет|ytn|тщ|no)
            printf "что же ты тогда хочешь шьорт побъери???\nПопробуем еще раз..."
            Sbor_dannyh_iz_ipcalc
            Ping_Seti
            ;;
        *)
            echo "Ты ошибся другалёчек"
            ;;
    esac
shopt -u nocasematch
}
Ping_Seti





#function Vblvod-infbl {



#}
#Vblvod-infbl



