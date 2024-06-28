#!/bin/bash

echo
echo "Para ejecutar:   ./solisdelcastilloAltaUser-Groups.sh parametro:nombre Lista_Usuarios.txt"
echo

USUARIO_CONSTASENA=$1
LISTA=$2

ANT_IFS=$IFS
IFS=$'\n'
for i in `cat $LISTA | awk -F ',' '{print $1, $2, $3}' | grep -v ^#`
do
    USUARIO=$(echo  $i | awk '{print $1}')
    GRUPO=$(echo  $i | awk '{print $2}')
    DIRECTORIO=$(echo  $i | awk '{print $3}')
    HASH=$(sudo grep $USUARIO_CONSTASENA /etc/shadow | awk -F ':' '{print $2}')
    # Verificar si el grupo existe, si no, crear el grupo
    if ! grep -q "^$GRUPO:" /etc/group; then
        sudo groupadd $GRUPO
        if [ $? -eq 0 ]; then
            echo "Grupo $GRUPO creado exitosamente."
        else
            echo "Error al crear el grupo $GRUPO."
        fi
    fi
    
    # Crear el usuario
    sudo useradd -d $DIRECTORIO -s /bin/bash -g $GRUPO $USUARIO
    if [ $? -eq 0 ]; then
        echo "Usuario $USUARIO creado exitosamente."
    else
        echo "Error al crear el usuario $USUARIO."
    fi
    sudo usermod --password "$HASH" "$USUARIO"
done

IFS=$ANT_IFS

# darle permisos de ejecucion al .sh # lo ejecute en donde esta la lista de usuarios
# chmod +x archivo.sh

