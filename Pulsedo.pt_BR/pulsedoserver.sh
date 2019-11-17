#!/data/data/com.termux/files/usr/bin/bash
#############################################
# PulsedoServer                             #
# Versão 1.0.5                              #
#                                           #
# Este script é parte do Pulsedo.           #
# Cledson Cavalcanti (c) 2019               #
# cledsonitgames@gmail.com                  #
# https://ledsotips.wordpress.com/          #
#############################################

PulsedoVer=1.0.5
PulsedoCfgFolder=$HOME/.config/PulsedoServer

function PulsedoHelp() {
    echo "USE: $0 [--start | --stop | -k, kill-server | -r, --remove-def-ip | -h, --help]"
    echo ""
    echo "DESCRIÇÕES DAS OPÇÕES"
    echo "              --start - carrega o módulo native-protocol-tcp do PulseAudio para reproduzir os sons dos dispositivos da sua rede local."
    echo "               --stop - descarrega o módulo native-protocol-tcp do PulseAudio para não reproduzir os sons dos dispositivos da sua rede local."
    echo "    -k, --kill-server - gentilmente, mata o servidor PulseAudio."
    echo "  -r, --remove-def-ip - remove o endereço IP que você aceitou salvar como padrão, assim este script volta a te perturbar de novo pelo IP."
    echo "           -h, --help - mostra este texto de ajuda."
    echo "Aviso: todas as opções sem traços foram abandonadas!!!"
    echo ""
    echo "PulsedoClient versão $PulsedoVer."
    echo "by Lesdo Upper (também conhecido como: Ledso, Cledson, Tales)"
    echo "Envie um e-mail para cledsonitgames@gmail.com se tiver problemas."
}

case $1 in
    --start)
        ls $PulsedoCfgFolder/defip 2> /dev/null 1> /dev/null
        if [ $? -ne 0 ]; then
            echo "Digite o IP do PC que está conectado à mesma rede deste celular: [e.g.: 192.168.0.123]"
            echo "OU você pode digitar uma máscara de IP se quiser receber conexões de qualquer PC conectado à mesma rede, ex.: 192.168.0.0/24"
            read dev_ip

            echo "Deseja tornar o IP padrão? Ao fazer isso, este script não lhe pertubará mais."
            echo "Você pode deletar o IP padrão executando '$0 remove-def-ip' em um terminal. [S/n]"
            read uoption

        if [ "$uoption" == "S" -o "$uoption" == "s" ]; then
            mkdir -p $PulsedoCfgFolder
            echo "$dev_ip" > $PulsedoCfgFolder/defip
            echo "$dev_ip configurado como IP padrão!"
        fi

        else
            dev_ip=`cat $PulsedoCfgFolder/defip`
        fi

        pulseaudio --check
        if [ $? -eq 1 ]; then
            pulseaudio --start --exit-idle-time=-1
            error_code=$?
            if [ $error_code -ne 0 ]; then
                echo "Tenha certeza que o PulseAudio está corretamente instalado e configurado."
                echo "Você pode, gentilmente, matá-lo com \"pulseaudio --kill\" pra ter certeza que está tudo bem."
                exit $error_code
            fi
        fi
        pacmd load-module module-native-protocol-tcp auth-ip-acl=$dev_ip auth-anonymous=1
        ;;

    --stop)
        pacmd unload-module module-native-protocol-tcp
        echo "Mate o servidor PulseAudio se estiver utilizando este script no Termux!"
        echo "Você pode fazer isso executando o comando '$0 kill-server'" ;;

    -k|--kill-server)
        pulseaudio --kill
        ;;

    -r|--remove-def-ip)
        rm $PulsedoCfgFolder/defip 2> /dev/null
        ls $PulsedoCfgFolder/defip 1> /dev/null 2> /dev/null
        if [ $? -ne 0 ]; then
            echo "IP padrão removido!"
        else
            echo "Erro ao tentar remover IP. Por favor, cheque as permissões para escrita de 'defip' em $PulsedoCfgFolder e tente novamente."
        fi
        ;;

    *)
        PulsedoHelp
        ;;
esac
