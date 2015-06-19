#!/bin/bash

: '
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License version 3 as published by
the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.
'

cabecera() {
    clear
    echo "------------"
    echo "PyAdmin v1.4"
    echo "------------"
    echo
}
opciones() {
    cabecera
    echo "contacto AT analizo DOT info"
    echo
    echo "Modo de empleo: sh pyadmin.sh [ARGUMENTO]"
    echo
    echo "-------------"
    echo "Ubuntu Server"
    echo "-------------"
    echo
    echo "sh pyadmin.sh  1 -> Realizar mantenimiento"
    echo "sh pyadmin.sh  2 -> Actualizar lista de paquetes disponibles"
    echo "sh pyadmin.sh  3 -> Actualizar paquetes"
    echo "sh pyadmin.sh  4 -> Actualizar paquetes (puede desinstalar otros)"
    echo "sh pyadmin.sh  5 -> Eliminar instaladores de software descargado"
    echo "sh pyadmin.sh  6 -> Eliminar paquetes deb obsoletos"
    echo
    echo "-------"
    echo "PyBossa"
    echo "-------"
    echo
    echo "sh pyadmin.sh  7 -> Activar proyectos.analizo.info"
    echo "sh pyadmin.sh  8 -> Forzar activar proyectos.analizo.info"
    echo "sh pyadmin.sh  9 -> Activar modo mantenimiento proyectos.analizo.info"
    echo "sh pyadmin.sh 10 -> Forzar activar modo mantenimiento proyectos.analizo.info"
    echo
    echo "----------------------"
    echo "Servidor web (Apache)"
    echo "----------------------"
    echo
    echo "sh pyadmin.sh 11 -> Recargar módulos Apache"
    echo "sh pyadmin.sh 12 -> Detener Apache"
    echo "sh pyadmin.sh 13 -> Iniciar Apache"
    echo "sh pyadmin.sh 14 -> Reiniciar Apache"
    echo "sh pyadmin.sh 15 -> Recargar Apache"
    echo "sh pyadmin.sh 16 -> Forzar recargar Apache"
    echo
    echo "----------------------------"
    echo "Servidor de correo (Postfix)"
    echo "----------------------------"
    echo
    echo "sh pyadmin.sh 17 -> Detener Postfix"
    echo "sh pyadmin.sh 18 -> Iniciar Postfix"
    echo "sh pyadmin.sh 19 -> Reiniciar Postfix"
    echo "sh pyadmin.sh 20 -> Recargar Postfix"
    echo "sh pyadmin.sh 21 -> Forzar recargar Postfix"
    echo
    echo "-----"
    echo "Redis"
    echo "-----"
    echo
    echo "sh pyadmin.sh 22 -> Test redis"
    echo "sh pyadmin.sh 23 -> Detener redis"
    echo "sh pyadmin.sh 24 -> Iniciar redis"
    echo "sh pyadmin.sh 25 -> Purgar cache redis"
    echo
    exit 1
}
activarProyectosAnalizoInfo() {
    echo "Desactivando el modo de mantenimiento..."
    echo
    a2dissite pybossa-maintenance-mode # Deshabilitar el host virtual actual
    echo
    echo "Activando proyectos.analizo.info..."
    echo
    a2ensite pybossa-site # Habilitar el nuevo host virtual
    echo
}
activarModoDeMantenimiento() {
    echo "Desactivando proyectos.analizo.info..."
    echo
    a2dissite pybossa-site # Deshabilitar el host virtual actual
    echo
    echo "Activando el modo de mantenimiento..."
    echo
    a2ensite pybossa-maintenance-mode # Habilitar el nuevo host virtual
    echo
}
recargarApache() {
    service apache2 reload
}
recargarApacheForzado() {
    service apache2 stop
    echo
    service apache2 start
    echo
    service apache2 force-reload
}
if test $# -eq 0 # Requiere un argumento
then
    opciones
else
    cabecera
    case $1 in
    "1")
        activarModoDeMantenimiento
        recargarApache
        aptitude update
        aptitude safe-upgrade
        aptitude full-upgrade
        aptitude clean
        aptitude autoclean
        activarProyectosAnalizoInfo
        recargarApache
    ;;
    "2")
        aptitude update
    ;;
    "3")
        aptitude safe-upgrade
    ;;
    "4")
        aptitude full-upgrade
    ;;
    "5")
        aptitude clean
    ;;
    "6")
        aptitude autoclean
    ;;
    "7")
        activarProyectosAnalizoInfo
        recargarApache
    ;;
    "8")
        activarProyectosAnalizoInfo
        recargarApacheForzado
    ;;
    "9")
        activarModoDeMantenimiento
        recargarApache
    ;;
    "10")
        activarModoDeMantenimiento
        recargarApacheForzado
    ;;
    "11")
        a2enmod rewrite
        echo
        a2enmod headers
    ;;
    "12")
        service apache2 stop
    ;;
    "13")
        service apache2 start
    ;;
    "14")
        service apache2 restart
    ;;
    "15")
        service apache2 reload
    ;;
    "16")
        service apache2 force-reload
    ;;
    "17")
        /etc/init.d/postfix stop
    ;;
    "18")
        /etc/init.d/postfix start
    ;;
    "19")
        /etc/init.d/postfix restart
    ;;
    "20")
       /etc/init.d/postfix reload
    ;;
    "21")
       /etc/init.d/postfix force-reload
    ;;
    "22")
        ps aux | grep redis-server
    ;;
    "23")
        /etc/init.d/redis_6379 stop
    ;;
    "24")
        /etc/init.d/redis_6379 start
    ;;
    "25")
        redis-cli FLUSHALL
    ;;
    *)
        opciones
    ;;
    esac
    echo
    read -p "Pulsa una tecla para contiuar..."
    opciones
    exit 0
fi
