#!/bin/bash








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
            echo -e "\nIPCALC установлен\n"
        fi
}

Proverka_ystanovki_ipcalc




function Sbor_dannyh_iz_ipcalc {
        read -p $'Впиши какую подсеть ты хочешь пингануть. Например: 192.168.0.0/24:\n\n' ipishnik_s_maskoy
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
        broadcast=$(ipcalc $ipishnik_s_maskoy | grep Broadcast | awk '{print $2}')
}
Sbor_dannyh_iz_ipcalc





function Ping_Seti_Podgotovka {
    massiv_ip_adresov=()
    shopt -s nocasematch

    case $pinging in
        да|yes|нуа|lf)
            if [[ $temp_oktet == 10 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j++))
                    do
                        for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k++))
                        do
                        current_ip="$temp_oktet.$i.$j.$k"
                        if [[ $current_ip != $broadcast ]]; then
                            massiv_ip_adresov+=("$current_ip")
                            echo -ne "\r\033[KСейчас: $current_ip"
                            sleep 0.01
                            parallel -j $potok  ping -c 5 -W 5 ${sort_massiv[@]}
                            if [[ icmp_seq == "*" ]]; then
                                echo -e "${massiv_ip_adresov[@]} доступен\n"
                            fi



                        fi

                    done
                done
                done
                sort_massiv=$(echo "Список адресов: ${massiv_ip_adresov[@]}" | tr ' ' '\n')
                echo "$sort_massiv"
                #for value in "${massiv_ip_adresov[@]}"; do
                #    echo -ne "\r\033[KСейчас: $value"
                #    sleep 0.01
                #done

                #echo "Список адресов: ${massiv_ip_adresov[@]}" | tr ' ' '\n'




                echo -e "\nКоличество пропингованных всего ip адресов: ${#massiv_ip_adresov[@]}"
                #echo -e "\nБыло найдено ${[@]} ip адресов"



            elif [[ $temp_oktet == 100 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                    do
                        for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k++))
                        do
                        current_ip="$temp_oktet.$i.$j.$k"
                        if [[ $current_ip != $broadcast ]]; then
                            massiv_ip_adresov+=("$current_ip")
                            echo -ne "\r\033[KСейчас: $current_ip"
                            sleep 0.01




                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

            elif [[ $temp_oktet == 172 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                    do
                        for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k++))
                        do
                        current_ip="$temp_oktet.$i.$j.$k"
                        if [[ $current_ip != $broadcast ]]; then
                            massiv_ip_adresov+=("$current_ip")
                            echo -ne "\r\033[KСейчас: $current_ip"
                            sleep 0.01




                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

            elif [[ $temp_oktet == 192 ]]; then
                for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                do
                    for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k ++))
                    do
                        current_ip="$temp_oktet.$i.$j.$k"
                        if [[ $current_ip != $broadcast ]]; then
                            massiv_ip_adresov+=("$current_ip")
                            echo -ne "\r\033[KСейчас: $current_ip"
                            sleep 0.01



                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V


            fi
            ;;
                #echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

        нет|ytn|тщ|no)
            #Poloski
            printf "Что же ты тогда хочешь шьорт побъери???\nПопробуем еще раз..."
            #Poloski
            Sbor_dannyh_iz_ipcalc
            Ping_Seti_Podgotovka
            ;;
        *)
            echo "Ты ошибся другалёчек"
            ;;
    esac

    shopt -u nocasematch
}
Ping_Seti_Podgotovka







