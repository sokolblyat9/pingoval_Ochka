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

function Poloski {
printf "\n"
printf "========================================================================================"
printf "\n"
printf "|                                                                                      |"
printf "\n"
printf "|                                                                                      |"
printf "\n"
printf "========================================================================================"
printf "\n"

}




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
        two_broad=255
        three_broad=255
        four_broad=255
}
Sbor_dannyh_iz_ipcalc





function Ping_Seti_Podgotovka {
    massiv_ip_adresov=()
    shopt -s nocasematch

    # Определяем броадкаст-адрес подсети
    broadcast=$(ipcalc $ipishnik_s_maskoy | grep Broadcast | awk '{print $2}')

    case $pinging in
        да|yes|нуа|lf)
            if [[ $temp_oktet == 10 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j++))
                    do
                        # Проверяем: если текущий диапазон октетов меняется, сбрасываем k
                        start_k=$temp_min_ip_four_oktet
                        end_k=$temp_max_ip_four_oktet
                        if [[ $j -ne $temp_min_ip_three_oktet ]]; then
                            start_k=0
                        fi
                        if [[ $j -ne $temp_max_ip_three_oktet ]]; then
                            end_k=255
                        fi

                        for ((k=$start_k; k <= $end_k; k++))
                        do
                            ip_adresa="10.$i.$j.$k"
                            # Исключаем только броадкаст-адрес
                            if [[ $ip_adresa != $broadcast ]]; then
                                massiv_ip_adresov+=("$ip_adresa")
                            fi
                        done
                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

            elif [[ $temp_oktet == 100 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                    do

                        start_k=$temp_min_ip_four_oktet
                        end_k=$temp_max_ip_four_oktet
                        if [[ $j -ne $temp_min_ip_three_oktet ]]; then
                            start_k=0
                        fi
                        if [[ $j -ne $temp_max_ip_three_oktet ]]; then
                            end_k=255
                        fi

                        for ((k=$start_k; k <= $end_k; k++))
                        do
                            ip_adresa="100.$i.$j.$k"
                            # Исключаем только броадкаст-адрес
                            if [[ $ip_adresa != $broadcast ]]; then
                                massiv_ip_adresov+=("$ip_adresa")
                            fi
                        done
                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

            elif [[ $temp_oktet == 172 ]]; then
                for ((i=$temp_min_ip_two_oktet; i <= $temp_max_ip_two_oktet; i++ ))
                do
                    for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                    do

                        start_k=$temp_min_ip_four_oktet
                        end_k=$temp_max_ip_four_oktet
                        if [[ $j -ne $temp_min_ip_three_oktet ]]; then
                            start_k=0
                        fi
                        if [[ $j -ne $temp_max_ip_three_oktet ]]; then
                            end_k=255
                        fi

                        for ((k=$start_k; k <= $end_k; k++))
                        do
                            ip_adresa="172.$i.$j.$k"
                            # Исключаем только броадкаст-адрес
                            if [[ $ip_adresa != $broadcast ]]; then
                                massiv_ip_adresov+=("$ip_adresa")
                            fi
                        done
                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

            elif [[ $temp_oktet == 192 ]]; then
                for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                do
                    for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k ++))
                    do
                        start_k=$temp_min_ip_four_oktet
                        end_k=$temp_max_ip_four_oktet
                        if [[ $j -ne $temp_min_ip_three_oktet ]]; then
                            start_k=0
                        fi
                        if [[ $j -ne $temp_max_ip_three_oktet ]]; then
                            end_k=255
                        fi

                        for ((k=$start_k; k <= $end_k; k++))
                        do
                            ip_adresa="$temp_oktet.168.$j.$k"
                            # Исключаем только броадкаст-адрес
                            if [[ $ip_adresa != $broadcast ]]; then
                                massiv_ip_adresov+=("$ip_adresa")
                            fi
                        done
                    done
                done
                echo "${massiv_ip_adresov[@]}" | tr ' ' '\n' | sort -u -V

            fi
            # Аналогично для остальных диапазонов (100, 172, 192)
        ;;
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






#function Vblvod-infbl {



#}
#Vblvod-infbl
function RainbowText {
    local text="Текст в цветах радуги" # Текст, который нужно вывести
    local colors=(31 33 32 36 34 35) # Цвета радуги (коды ANSI)
    local color_count=${#colors[@]}
    local index=0

    for ((i = 0; i < ${#text}; i++)); do
        char="${text:i:1}" # Получаем текущий символ
        if [[ $char == " " ]]; then
            printf " " # Пропускаем пробелы
        else
            printf "\e[1;${colors[index]}m%s\e[0m" "$char" # Выводим символ с цветом
            index=$(( (index + 1) % color_count )) # Сдвиг по цветам
        fi
    done
    echo # Переход на новую строку
}

# Пример вызова функции
RainbowText



function RainbowText {
    local text="$1"  # Текст, который передается в функцию
    local colors=(31 33 32 36 34 35)  # Массив цветов (коды ANSI)
    local color_count=${#colors[@]}  # Количество цветов в массиве
    local index=0  # Индекс для массива цветов

    # Разделяем строку на две части: до двоеточия и после двоеточия
    local before_colon="${text%%:*}"   # Текст до двоеточия
    local after_colon="${text#*:}"    # Текст после двоеточия

    # Проходим по символам текста до двоеточия
    for ((i = 0; i < ${#before_colon}; i++)); do
        char="${before_colon:i:1}"  # Получаем текущий символ

        # Если это пробел, выводим пробел без цвета
        if [[ $char == " " ]]; then
            printf " "
        else
            # Выводим символ с цветом из массива
            printf "\e[1;${colors[index]}m%s\e[0m" "$char"
            # Переходим к следующему цвету
            index=$(( (index + 1) % color_count ))
        fi
    done

    # Выводим текст после двоеточия без изменения цвета
    printf ":%s\n" "$after_colon"
}

# Пример вызова функции
RainbowText "Найдено количество IP адресов: 192.168.1.1 192.168.1.2 192.168.1.3"



RainbowTextSmooth() {
    local text="$1"  # Текст, который передан в функцию
    local colors=(31 33 32 36 34 35)  # Цвета радуги (коды ANSI)
    local color_count=${#colors[@]}  # Количество цветов
    local index=0  # Начальный индекс для цветов

    # Пробегаем по всем символам строки
    for ((i = 0; i < ${#text}; i++)); do
        char="${text:i:1}"  # Берем текущий символ
        if [[ $char == " " ]]; then
            printf " "  # Пропускаем пробелы
        else
            # Выводим символ с цветом
            printf "\e[1;${colors[index]}m%s\e[0m" "$char"
            # Сдвигаем индекс цвета по кругу
            index=$(( (index + 1) % color_count ))
        fi
        sleep 0.1  # Добавляем небольшую задержку для плавности
    done
    echo  # Переход на новую строку
}

# Пример вызова
RainbowTextSmooth "Текст с плавным переходом цвета"

