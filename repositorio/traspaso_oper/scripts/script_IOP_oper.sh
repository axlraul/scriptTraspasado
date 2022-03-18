#!/bin/bash
#19/03/2022
#Raul Perez Sanchiz
#V3.0

BASE="/tools/scripts/traspaso_oper"
cambios="$BASE/cambios.txt"
LOG="$BASE/log/log.txt"
checkpoint=FALSE
/bin/touch $LOG
echo "¿Numero de CH?"
read cambio
while IFS= read -r line
do
  CH=$(echo $line | awk '{printf "%s", $1}')
  modulo=$(echo $line | awk '{printf "%s", $2}')
  arg1=$(echo $line | awk '{printf "%s", $3}')
  arg2=$(echo $line | awk '{printf "%s", $4}')

  if [[ "$CH" == "$cambio" ]]
  then
    checkpoint=TRUE
    if [[ "$modulo" == "custom" ]]
    then
      /bin/sh $BASE/custom/$CH/$CH.sh
    else
      /bin/sh $BASE/modulos/$modulo/$modulo.sh $arg1 $arg2
    fi
  /bin/sed -i "s|$line|EJECUTADO $line|g" $cambios
  echo "Cambio ejecutado. $line" - `date +%Y-%m-%d_%H-%M-%S` >> $LOG
  fi
done <"$cambios"


if [[ "$checkpoint" == "FALSE" ]]
then
    echo "Codigo introducido incorrecto." - `date +%Y-%m-%d_%H-%M-%S` >> $LOG
    echo "Codigo introducido incorrecto. Prueba de reintroducir correctamente el codigo y si vuelve a aparecer este mensaje, contacta con la TS"
fi
