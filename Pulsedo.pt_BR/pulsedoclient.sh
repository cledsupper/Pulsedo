#!/bin/bash
#############################################
# PulsedoClient                             #
# Versão 1.0.5                              #
#                                           #
# Este script é parte do Pulsedo.           #
# Cledson Cavalcanti (c) 2019               #
# cledsonitgames@gmail.com                  #
# https://ledsotips.wordpress.com/          #
#############################################

PulsedoVer=1.0.5
PulsedoCfgFolder=$HOME/.config/PulsedoClient

function PulsedoHelp() {
    echo "USE: $0 [<command> | <-r |--remove-def-ip> | <-h | --help>]"
    echo ""
    echo "DESCRIÇÕES DAS OPÇÕES"
    echo "            <command> - uma linha de comando ou programa para abrir com Pulsedo. Isto é, com a variável de ambiente PULSE_SERVER espec."
    echo "  -r, --remove-def-ip - remove o endereço IP que você aceitou salvar como padrão, assim este script volta a te perturbar de novo pelo IP."
    echo "           -h, --help - mostra este texto de ajuda."
    echo "Aviso: todas as opções sem traços foram abandonadas!!!"
    echo ""
    echo "PulsedoClient versão $PulsedoVer"
    echo "by Lesdo Upper (também conhecido como: Ledso, Cledson, Tales)"
    echo "Envie um e-mail para cledsonitgames@gmail.com se tiver problemas."
}

ls $PulsedoCfgFolder/defip 2> /dev/null 1> /dev/null
ls_return=$?
use_new_opening_method=1
run_command=0

case $1 in
    stream)
        use_new_opening_method=0
        echo "AVISO: 'stream' foi abandonado desde a ver. 1.0.5!"
        echo "Você deve inserir uma linha de comando em vez disso."

        echo "Insira um comando/nome de um programa para executar com o Pulsedo:"
        read sh_cmd
        run_command=1
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

    help|-h|--help)
        PulsedoHelp
        ;;

    *)
        # Nothing seems like a help ask
        if [ "$1" == "" ]; then
            PulsedoHelp
        else
            run_command=1
        fi
        ;;
esac

if [ $run_command -eq 0 ]; then
    exit 0
fi

if [ $ls_return -ne 0 ]; then
    echo "Digite o IP do PulsedoServer (o mesmo IP onde o PulsedoServer está executando): [exemplo: 192.168.0.132]"
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

if [ $use_new_opening_method -eq 1 ]; then
    sh_cmd=$@
fi

env PULSE_SERVER=$dev_ip $sh_cmd &
echo "Você precisa encerrar este programa antes de desligar o servidor no seu celular."
