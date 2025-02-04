#!/bin/bash
sudo nohup glxgears > /dev/null &
if [ $# = 1  ] && [ $1 >=2 ]
then
cnt=$1
echo 'Количество прогонов:' $1
else
cnt=5
echo 'Прогонов по умолчанию 5'
fi
echo 'Создаём временный файл'
sudo dd if=/dev/urandom bs=$(cat /proc/meminfo | awk '/'MemTotal'/ {print $2}') of=/tmp/memtest count=1050
#sudo dd if=/dev/urandom bs=4096 of=/tmp/memtest count=1050
j=0 ; k=0 ; errm='false'
for ((i=1; i<=$cnt; i++ ))
do
echo 'идёт прогон' $i
k=$j
j=$(md5sum /tmp/memtest | awk '{print $1}')
#echo $j
#echo $k
if [ $j != $k ] && [ $i -gt 1 ]
then
echo 'Выявлены ошибки.'
errm='true'
else
echo 'Тестирование успешно.'
fi
done
if [ $errm = 'true' ]
then
echo -e '\n\033[31m Тестирование памяти завершилось с ошибками. Возможно имеются аппаратные проблемы.\n\033[0m'
else
echo -e '\n\033[32m Тестирование памяти завершилось без ошибок.\n\033[0m'
fi
rm /tmp/memtest
echo -e '\n\033[36m Начало проверки поверхности НЖМД.\n\033[0m'
sudo badblocks -vs /dev/sda -o ~/badblocks.txt
