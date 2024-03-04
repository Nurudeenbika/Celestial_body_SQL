#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  
  if [[ -z $AVAILABLE_SERVICES ]]
  then
    echo "Sorry we do not have any servises available right now"
    else
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
     echo "$SERVICE_ID) $NAME"
    done

    read SERVICE_ID_SELECTED
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      MAIN_MENU "That is not a number"
      else
        SERV_AVAIL=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
        NAME_SERV=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
        if [[ -z $SERV_AVAIL ]]
        then
          MAIN_MENU "I could not find that service. What would you like today?"
          else
            echo -e "\nWhat's your phone number?"
            read CUSTOMER_PHONE
            CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
            if [[ -z $CUSTOMER_NAME ]]
            then
              echo -e "\nI don't have a record for that phone number, what's your name?"
              read CUSTOMER_NAME
              INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
            fi
            echo -e "\nWhat time would you like your $NAME_SERV, $CUSTOMER_NAME?"
            read SERVICE_TIME
            CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
            if [[ $SERVICE_TIME ]]
            then
              INSERT_SERV_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED,'$SERVICE_TIME')")
              if [[ $INSERT_SERV_RESULT ]]
              then
                NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
                echo -e "\nI have put you down for a $NAME_SERV at $SERVICE_TIME, $NAME_FORMATTED."
              fi
            fi
        fi
    fi    
  fi
}

MAIN_MENU




























# CREATE_APPOINTMENT() {
#   SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
#   CUST_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
#   CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#   NAME_FORMATTED=$(echo $SERVICE_NAME | sed -r 's/^ *| *$//g')
#   echo -e "\nWhat time would you like your $NAME_FORMATTED, $CUSTOMER_NAME?"
#   read SERVICE_TIME
#   TIME_SELECTED_INSERT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUST_ID, $SERVICE_ID_SELECTED,'$SERVICE_TIME')")
#   echo -e "\nI have put you down for a $NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."

# }
# # services I offer
# MAIN_MENU() {
#   if [[ $1 ]]
#   then
#     echo -e "\n$1"
#   fi

#   SERVICES=$($PSQL "SELECT service_id, name FROM services")
#   echo "$SERVICES" | while read SERVICE_ID BAR NAME
#   do
#     echo "$SERVICE_ID) $NAME"
#   done

#   read SERVICE_ID_SELECTED
#   HAVE_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
#   if [[ -z $HAVE_SERVICE ]]
#   then
#   MAIN_MENU "I could not find that service. What would you like today?"
#   else 
#     SERVICES_AVAILABLE=$($PSQL "SELECT service_id, name FROM services WHERE service_id=$SERVICE_ID")

#   fi

#   echo -e "\nWhat's your phone number?"
#   read CUSTOMER_PHONE
#   HAVE_CUSTOMER=$($PSQL "SELECT customer_id, phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#   if [[ -z $HAVE_CUSTOMER ]]
#   then
#   echo -e "\nI don't have a record for that phone number, what's your name?"
#   read CUSTOMER_NAME

#   NAME_SELECTED=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
 
#   CREATE_APPOINTMENT
#   else
#     CREATE_APPOINTMENT
#   fi

  
# }



# MAIN_MENU


