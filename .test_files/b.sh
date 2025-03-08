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
        HostMin=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}')
        HostMax=$(ipcalc $ipishnik_s_maskoy | grep HostMax | awk '{print $2}')
        temp_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}' | cut -d '.' -f 1)
        temp_min_ip_two_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}' | cut -d '.' -f 2)
        temp_max_ip_two_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMax | awk '{print $2}' | cut -d '.' -f 2)
        temp_min_ip_three_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}' | cut -d '.' -f 3)
        temp_max_ip_three_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMax | awk '{print $2}' | cut -d '.' -f 3)
        temp_min_ip_four_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMin | awk '{print $2}' | cut -d '.' -f 4)
        temp_max_ip_four_oktet=$(ipcalc $ipishnik_s_maskoy | grep HostMax | awk '{print $2}' | cut -d '.' -f 4)
        temp_broadcast=$(ipcalc $ipishnik_s_maskoy | grep Broadcast | awk '{print $2}')
        read -p "Вы хотите пингануть $HostMin - $HostMax адреса? (Да/Нет):   " pinging
        broadcast=$(ipcalc $ipishnik_s_maskoy | grep Broadcast | awk '{print $2}')
        maska=$(echo "$ipishnik_s_maskoy" | cut -d '/' -f 2)
        if [[ $maska -le 23 ]]; then
            temp_max_ip_four_oktet=255
        fi
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
                            

                        fi
                        done
                    done
                done
                echo ""
                sort_massiv=$(echo "Список адресов: ${massiv_ip_adresov[@]}" | tr ' ' '\n')
                #echo "$sort_massiv"
                #for value in "${massiv_ip_adresov[@]}"; do
                #    echo -ne "\r\033[KСейчас: $value"
                #    sleep 0.01
                #done

                #echo "Список адресов: ${massiv_ip_adresov[@]}" | tr ' ' '\n'
                echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j 20 -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP {} доступен\n" ' | tee /dev/tty | grep -c "доступен" | xargs -I {} echo -e "\nДоступно узлов : {}"




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
                        fi




                        done
                    done
                done
                echo ""
                #echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V
                echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j 20 -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP {} доступен\n" ' | tee /dev/tty | grep -c "доступен" | xargs -I {} echo -e "\nДоступно узлов : {}"
                echo -e "\nКоличество пропингованных всего ip адресов: ${#massiv_ip_adresov[@]}"

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
                        fi




                        done
                    done
                done
                echi ""
                #echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V
                echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j 20 -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP {} доступен\n" ' | tee /dev/tty | grep -c "доступен" | xargs -I {} echo -e "\nДоступно узлов : {}"
                echo -e "\nКоличество пропингованных всего ip адресов: ${#massiv_ip_adresov[@]}"

            elif [[ $temp_oktet == 192 ]]; then
                for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                do
                    for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k ++))
                    do
                        current_ip="$temp_oktet.168.$j.$k"
                        if [[ $current_ip != $broadcast ]]; then
                            massiv_ip_adresov+=("$current_ip")
                            echo -ne "\r\033[KСейчас: $current_ip"

                            sleep 0.01
                        fi



                    done
                done
                #echo -e "\n${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V
                echo ""


                #for ip in "${massiv_ip_adresov[@]}"; do
                #    echo -e "\r\nПингуется IP: $ip"
                #    if ping -c 4 -W 4 "$ip" > /dev/null 2>/dev/null; then
                #        echo -e "\nIP $ip доступен"
                #        available_ips+=("$ip")  # Добавляем доступный IP в массив
                #    fi
                #done

                # Подсчитываем количество доступных IP-адресов
                #echo -e "\nДоступно ${#available_ips[@]} узлов"


                echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j 20 -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP {} доступен\n" ' | tee /dev/tty | grep -c "доступен" | xargs -I {} echo -e "\nДоступно узлов : {}"
                echo -e "\nКоличество пропингованных всего ip адресов: ${#massiv_ip_adresov[@]}"

                #printf "%s\n" "${massiv_ip_adresov[@]}" | parallel -j4 "ping -c 5 -W 5 {} > /dev/null && echo 'IP адрес {} доступен'"


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







