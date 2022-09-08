#!/bin/bash
#Colores
green='\e[1;32m'
yellow='\e[1;33m'
red='\e[1;31m'
azul='\e[1;34m'
espabila='\e[1;35m'
end='\e[0m'
opciones=0

while  [ $opciones -ne 5 ] ; do

clear


echo -e "$red   ▄████████  ▄█        ▄█             ▄█  ███▄▄▄▄         ▄██████▄  ███▄▄▄▄      ▄████████ $end"
echo -e "$red  ███    ███ ███       ███            ███  ███▀▀▀██▄      ███    ███ ███▀▀▀██▄   ███    ███ $end"
echo -e "$red  ███    ███ ███       ███            ███▌ ███   ███      ███    ███ ███   ███   ███    █▀  $end"
echo -e "$yellow  ███    ███ ███       ███            ███▌ ███   ███      ███    ███ ███   ███  ▄███▄▄▄     $end"
echo -e "$yellow▀███████████ ███       ███            ███▌ ███   ███      ███    ███ ███   ███ ▀▀███▀▀▀     $end"
echo -e "$yellow  ███    ███ ███       ███            ███  ███   ███      ███    ███ ███   ███   ███    █▄  $end"
echo -e "$red  ███    ███ ███▌    ▄ ███▌    ▄      ███  ███   ███      ███    ███ ███   ███   ███    ███ $end"
echo -e "$red  ███    █▀  █████▄▄██ █████▄▄██      █▀    ▀█   █▀        ▀██████▀   ▀█   █▀    ██████████ $end"
echo -e "$red             ▀         ▀                                                                    $end"









        echo
        echo -e " 1)$azul Instalar docker en$end$espabila Ubuntu 20.04 $end"
        echo -e " 2)$azul Instalar portainer en docker$end$espabila Ubuntu 20.04 $end"
        echo -e " 3)$azul Instalar Tvheadend en docker$end$espabila Ubuntu 20.04 $end"
        echo -e " 4)$azul Instalar Oscam en docker$end$espabila Ubuntu 20.04 $end"
        echo
        echo -e " 5)$red Salir $end"
        echo
        read -p " Selecciona una opcion: " opciones
        case $opciones in
                1) echo -e "$green Actualizando lista de paquetes...$end"
                   sleep 2
                   sudo apt update -y
                   sleep 2
                   echo -e "$green Instalando paquetes necesarios...$end"
                   sleep 3
                   sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
                   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
                   sudo apt update -y
                   sudo apt install docker-ce -y
                   sudo systemctl status docker | grep active > /dev/null
                   if [ $? -eq 0 ]; then
                         echo " Comprobando estado..."
                         sleep 2
                         echo -e " $green ...sistema activo Ok $end"
                         sleep 1
                   else
                       echo "$red ...error $end"
                   fi
                   sleep 2
                   ;;
                2) read -p "introduce la ruta absoluta para crear el directorio de configuracion para el contenedor de portainer:" dir
                   echo -e "$yellow Creando directorio... $end"
                   sleep 2
                   sudo mkdir $dir
                   if [ $? -eq 0 ]; then
                         echo " Comprobando estado..."
                         sleep 2
                         echo -e " $green ...Directorio creado en $dir $end"
                         sleep 1
                         echo -e "$yellow Creando el contendor...$end"
                         sleep 2
                         sudo docker volume create portainer_data
                         sudo docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v $dir:/data portainer/portainer
                   else
                         echo "error"
                   fi
                   sleep 2
                   ;;
                3) read -p "introduce la ruta absoluta para crear el directorio de configuracion para el contenedor de tvheadend:" dirtvheadend
                   read -p "introduce la ruta absoluta para crear el directorio de grabaciones para el contenedor de tvheadend:" dirtvheadendgrab
                   read -p "introduce el nombre que quieres para tu contedor de tvheadend:" nombretvheadend
                   echo -e "$yellow Creando directorio... $end"
                   sleep 2
                   sudo mkdir $dirtvheadend $dirtvheadendgrab
                   if [ $? -eq 0 ]; then
                         echo " Comprobando estado..."
                         sleep 2
                         echo -e " $green ...Directorio creado en $dirtvheadend y $dirtvheadendgrab $end"
                         sleep 1
                         echo -e "$yellow Creando el contendor de tvheadend...$end"
                         sleep 2
                         sudo docker volume create tvheadend_data
                         sudo docker run -d --name=$nombretvheadend --net=host --device=/dev/dvb -e TZ=Europe/Madrid -v $dirtvheadend:/config -v $dirtvheadendgrab:/recordings --restart unless-stopped lscr.io/linuxserver/tvheadend
                   else
                         echo "error"
                   fi
                   sudo docker ps | grep $nombretvheadend | grep Up
                   if [ $? -eq 0 ]; then
                         echo " Comprobando estado..."
                         sleep 2
                         echo -e " $green ...Ok $end"
                   else
                         echo "error"
                   fi
                   sleep 2
                   ;;
                4) read -p "introduce la ruta absoluta para crear el directorio de configuracion para el contenedor de oscam:" diroscam
                   read -p "introduce los puertos para el contenedor (ejemplo 5555:5555):" puertososcam
                   read -p "introduce el nombre que quieres para tu contedor de oscam:" nombreoscam
                   echo -e "$yellow Creando directorio... $end"
                   sleep 2
                   sudo mkdir $diroscam
                   if [ $? -eq 0 ]; then
                         echo " Comprobando estado..."
                         sleep 2
                         echo -e " $green ...Directorio creado en $diroscam $end"
                         sleep 1
                         echo -e "$yellow Creando el contendor de oscam...$end"
                         sleep 2
                         sudo docker volume create oscam_data
                         sudo docker run -d --name=$nombreoscam -e PUID=1000 -e PGID=1000 -e TZ=Europe/Madrid -p $puertososcam -v $diroscam:/config --restart unless-stopped linuxserver/oscam
                         else
                          echo "error"
                   fi
                   sudo docker ps | grep $nombreoscam | grep Up
                   if [ $? -eq 0 ]; then
                         echo " Comprobando estado..."
                         sleep 2
                         echo -e " $green ...Ok $end"
                   else
                         echo "error"
                   fi
                   sleep 2
                   ;;
                5) exit;;
                *) echo "$opciones no es una opcion, selecciona una opcion correcta"
    esac
                read -p "Pulsa una tecla para continuar..." tecla
done
