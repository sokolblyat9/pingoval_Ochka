#!/bin/bash

function Proverka_OS {
    os_info=$(uname -a)
    proverka_parallel=$(parallel -V 2>&1)
    if [[ $os_info == *"Debian"* || $os_info == *"Ubuntu"* ]]; then
        echo "Проверка на наличие нужного пакета - parallel - для будущего пинга сети в несколько потоков одновременно"
        if [[ $proverka_parallel == *"License"* ]]; then
            echo -e "\nParallel установлен\n"
        elif [[ $proverka_parallel == *"Error"* ]]; then
            parallel -V --unsafe >/dev/null
            if [[ $(parallel -V --unsafe) == *"License"* ]]; then
                echo -e "\nParallel установлен\n"
            fi
        else
            sudo apt update && sudo apt install -y parallel
        fi
    elif [[ $os_info == *"Linux calculate"* ]]; then
        echo "Проверка на наличие нужного пакета - parallel - для будущего пинга сети в несколько потоков одновременно"
        if [[ $proverka_parallel == *"License"* ]]; then
            echo -e "\nParallel установлен\n"
        elif [[ $proverka_parallel == *"Error"* ]]; then
            parallel -V --unsafe >/dev/null
            if [[ $(parallel -V --unsafe) == *"License"* ]]; then
                echo -e "\nParallel установлен\n"
            fi
        else
            cl-update -s && sudo emerge sys-process/parallel
        fi
    elif [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then
        echo "Проверка на наличие нужного пакета - parallel - для будущего пинга сети в несколько потоков одновременно"
        if [[ $proverka_parallel == *"License"* ]]; then
            echo -e "\nParallel установлен\n"
        elif [[ $proverka_parallel == *"Error"* ]]; then
            parallel -V --unsafe >/dev/null
            if [[ $(parallel -V --unsafe) == *"License"* ]]; then
                echo -e "\nParallel установлен\n"
            fi
        else
            sudo pacman -Sy && sudo pacman -S parallel
        fi

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
    os_info=$(uname -a)
    vyvod=$(ipcalc --version 2>&1)
        if [[ $os_info == *"Debian"* || $os_info == *"Ubuntu"* ]]; then
            ipcalc --version >/dev/null
                if [[ $vyvod == *"команда не найдена"* || $vyvod == *"command not found"* ]]; then
                    sudo apt install ipcalc
                else
                    echo -e "\nIPCALC установлен\n"
                fi
        elif [[ $os_info == *"Linux calculate"* ]]; then
            ipcalc --version >/dev/null
                if [[ $vyvod == *"команда не найдена"* || $vyvod == *"command not found"* ]]; then
                    sudo emerge ipcalc
                else
                    echo -e "\nIPCALC установлен\n"
                fi
        elif [[ $os_info == *"MANJARO"* ]]; then
            ipcalc --version >/dev/null
                if [[ $vyvod == *"команда не найдена"* || $vyvod == *"command not found"* ]]; then
                    sudo pacman -S ipcalc
                else
                    echo -e "\nIPCALC установлен\n"
                fi
        fi
}

Proverka_ystanovki_ipcalc




function Sbor_dannyh_iz_ipcalc {
        echo ""
        read -p $'Впиши какую сеть ты хочешь пингануть. Например: 192.168.0.0/24:\n\n' ipishnik_s_maskoy
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
                            echo -ne "\r\033[KСбор ip адресов в массив: $current_ip"
                            sleep 0.01


                        fi
                        done
                    done
                done
                echo ""

                os_info=$(uname -a)
                if [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                elif [[ $os_info == *"Linux calculate"* ]]; then
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }

                else
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                fi

                echo -e "\nКоличество пропингованных всего ip адресов: ${#massiv_ip_adresov[@]}\n"

                repeat() {
                echo -e "\n=================================\nХочешь повторить?\n=================================\n"
                read otvet
                shopt -s nocasematch
                if [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then

                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                            echo -e "\nВсё!\n"
                            ;;
                    esac
                elif [[ $os_info == *"Linux calculate"* ]]; then

                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                                echo -e "\nВсё!\n"
                            ;;
                    esac
                else
                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                                echo -e "\nВсё!\n"
                            ;;
                    esac
                fi
                shopt -u nocasematch
                }
                repeat


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
                            echo -ne "\r\033[KСбор ip адресов в массив: $current_ip"
                            sleep 0.01
                        fi




                        done
                    done
                done
                echo ""


                os_info=$(uname -a)
                if [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                elif [[ $os_info == *"Linux calculate"* ]]; then
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                else
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                fi

                echo -e "\nКоличество пропингованных всего ip адресов: ${#massiv_ip_adresov[@]}\n"

                repeat() {
                echo -e "\n=================================\nХочешь повторить?\n=================================\n"
                read otvet
                shopt -s nocasematch
                if [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then

                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                            echo -e "\nВсё!\n"
                            ;;
                    esac
                elif [[ $os_info == *"Linux calculate"* ]]; then

                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                                echo -e "\nВсё!\n"
                            ;;
                    esac
                else
                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                                echo -e "\nВсё!\n"
                            ;;
                    esac
                fi
                shopt -u nocasematch
                }
                repeat

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
                            echo -ne "\r\033[KСбор ip адресов в массив: $current_ip"
                            sleep 0.01
                        fi




                        done
                    done
                done
                echo ""


                os_info=$(uname -a)
                if [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                elif [[ $os_info == *"Linux calculate"* ]]; then
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                else
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                fi

                echo -e "\nКоличество пропингованных всего ip адресов: ${#massiv_ip_adresov[@]}\n"

                repeat() {
                echo -e "\n=================================\nХочешь повторить?\n=================================\n"
                read otvet
                shopt -s nocasematch
                if [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then

                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                            echo -e "\nВсё!\n"
                            ;;
                    esac
                elif [[ $os_info == *"Linux calculate"* ]]; then

                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                                echo -e "\nВсё!\n"
                            ;;
                    esac
                else
                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                                echo -e "\nВсё!\n"
                            ;;
                    esac
                fi
                shopt -u nocasematch
                }
                repeat

            elif [[ $temp_oktet == 192 ]]; then
                for ((j=$temp_min_ip_three_oktet; j <= $temp_max_ip_three_oktet; j ++))
                do
                    for ((k=$temp_min_ip_four_oktet; k <= $temp_max_ip_four_oktet; k ++))
                    do
                        current_ip="$temp_oktet.168.$j.$k"
                        if [[ $current_ip != $broadcast ]]; then
                            massiv_ip_adresov+=("$current_ip")
                            echo -ne "\r\033[KСбор ip адресов в массив: $current_ip"

                            sleep 0.01
                        fi



                    done
                done
                echo ""


                os_info=$(uname -a)
                if [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                elif [[ $os_info == *"Linux calculate"* ]]; then
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                else
                    echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                    available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                    count=$(echo "$available_ips" | grep -c .)
                    echo -e "\nДоступные узлы:"
                    echo "$available_ips"
                    echo -e "\nДоступно узлов: $count"
                }
                fi

                echo -e "\nКоличество пропингованных всего ip адресов: ${#massiv_ip_adresov[@]}\n"

                repeat() {
                echo -e "\n=================================\nХочешь повторить?\n=================================\n"
                read otvet
                shopt -s nocasematch
                if [[ $os_info == *"MANJARO"* || $os_info == *"Arch"* ]]; then

                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k --unsafe 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                            echo -e "\nВсё!\n"
                            ;;
                    esac
                elif [[ $os_info == *"Linux calculate"* ]]; then

                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                                echo -e "\nВсё!\n"
                            ;;
                    esac
                else
                    case $otvet in
                        да|yes|нуа|lf)
                            echo -e "${massiv_ip_adresov[@]}" | tr ' ' '\n' | parallel -j $potok -k 'echo -e "\r\nПингуется IP: {}" && ping -c 4 -W 4 {} > /dev/null 2>/dev/null && echo -e "\nIP - {} доступен\n"' | tee /dev/tty | {
                                available_ips=$(grep "доступен" | awk -F' - ' '{print $2}' | awk '{print $1}')
                                count=$(echo "$available_ips" | grep -c .)
                                echo -e "\nДоступные узлы:"
                                echo "$available_ips"
                                echo -e "\nДоступно узлов: $count"
                            }
                            repeat
                            ;;
                            *)
                                echo -e "\nВсё!\n"
                            ;;
                    esac
                fi
                shopt -u nocasematch
                }
                repeat

            fi
            ;;

        нет|ytn|тщ|no)
            printf "\nЧто же ты тогда хочешь шьорт побъери???\n\nПопробуем еще раз...\n"
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




