#!/bin/bash


HOST=$1
USER=$2
PASSWORD=$3

review_negative=("C'est un mauvais restaurant" "Ce restaurant est tres mauvais, je ne reviendrai plus" "Un restaurant horrible" "Repas vraiment decevant" "Je ne recommande pas ce restaurant" "Je ne reviendrai plus jamais ici" "Un restaurant de qualite mediocre")
review_positive=("Un restaurant tres tres positif" "Ce restaurant est incroyable,je n'ai jamais rien mange d'aussi delicieux" "C'est le meilleur restaurant que je connaisse" "un vrai delice" "un restaurant de qualite" "un restaurant de qualite exceptionnelle")

DATE=$(date "+%Y-%m-%d %H:%M:%S")
RESTAURANT_ID_NEG=$(mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "SELECT r_id FROM restaurant ORDER BY RAND() LIMIT 1" | sed '1d')
RESTAURANT_NAME_NEG=$(mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "SELECT r_name FROM restaurant WHERE r_id = $RESTAURANT_ID_NEG;" | sed '1d')
RESTAURANT_ADDRESS_NEG=$(mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "SELECT r_address FROM restaurant WHERE r_id = $RESTAURANT_ID_NEG;" | sed '1d')

RESTAURANT_ID_POS=$(mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "SELECT r_id FROM restaurant ORDER BY RAND() LIMIT 1" | sed '1d')
RESTAURANT_NAME_POS=$(mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "SELECT r_name FROM restaurant WHERE r_id = $RESTAURANT_ID_POS;" | sed '1d')
RESTAURANT_ADDRESS_POS=$(mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "SELECT r_address FROM restaurant WHERE r_id = $RESTAURANT_ID_POS;" | sed '1d')

for ((x=0;x<500;x++))
do
	size=${#review_negative[@]}
	index=$(($RANDOM % $size))
	echo ${review_negative[$index]}

	REVIEW_NEG=${review_negative[$index]}
	USER_NEG=$(mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "SELECT u_id FROM users ORDER BY RAND() LIMIT 1" | sed '1d')
	mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "INSERT INTO \`review\` (\`r_name\`, \`r_address\`, \`review\`, \`r_by\`, \`rating\`) VALUES ('$RESTAURANT_NAME_NEG', '$RESTAURANT_ADDRESS_NEG', '$REVIEW_NEG','$USER_NEG', '1')"

        size=${#review_positive[@]}
        index=$(($RANDOM % $size))
        echo ${review_positive[$index]}
	USER_POS=$(mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "SELECT u_id FROM users ORDER BY RAND() LIMIT 1" | sed '1d')
        REVIEW_POS=${review_positive[$index]}

	mysql -h $HOST -u$USER -p$PASSWORD -B maki2 -e "INSERT INTO \`review\` (\`r_name\`, \`r_address\`, \`review\`, \`r_by\`, \`rating\`) VALUES ('$RESTAURANT_NAME_POS', '$RESTAURANT_ADDRESS_POS', '$REVIEW_NEG_POS','$USER_POS', '5')"

done