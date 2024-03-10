#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"

echo "Enter your username:"
read USERNAME

USERNAME_AVAIL=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(user_id) WHERE username='$USERNAME'")
BEST_GAMES=$($PSQL "SELECT MIN(number_guesses) FROM users INNER JOIN games USING(user_id) WHERE username='$USERNAME'")
if [[ -z $USERNAME_AVAIL ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAMES guesses."
fi

RANDOM_NUMBER=$(( 1 + $RANDOM % 1000 ))
GUESS=1
echo "Guess the secret number between 1 and 1000:"

while read NUM
do
  if [[ ! $NUM =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    else
    if [[ $NUM -eq  $RANDOM_NUMBER ]]
    then
      break;
    else
      if [[ $NUM -gt  $RANDOM_NUMBER  ]]
      then
        echo -n "It's lower than that, guess again:"
      elif [[ $NUM -lt  $RANDOM_NUMBER  ]]
      then
        echo -n "It's higher than that, guess again:"
      fi  
    fi
  fi
  GUESS=$(( $GUESS + 1 ))
done

if [[ $GUESS == 1 ]]
then
  echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
else
  echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
INSERT_GAME=$($PSQL "INSERT INTO games(number_guesses, user_id) VALUES($GUESS, $USER_ID)")



# if [[ $1 ]]
# then
#   #if [[ ! $1 =~ ^[0-9]+$ ]]
#   # then
#   # fi
# fi
# GET_USER=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
# GAME_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
# GUESS_NUMBER_ID=$($PSQL "SELECT guess_number_id FROM users WHERE username='$USERNAME'")
# echo "Enter your username:"
# read USERNAME
# if [[ -z $GET_USER ]]
# then
#   INSERT_USER=$($PSQL "INSERT INTO users(username, games_played) VALUES('$USERNAME', $GAME_PLAYED)")
#   GET_USER=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
#   Welcome, $GET_USER! It looks like this is your first time here.
#   else
#   Welcome back, $USERNAME! You have played $GAME_PLAYED games, and your best game took <best_game> guesses.
# fi



# RANDOM_NUMBER=$(( $RANDOM % 1000 ))
#echo "$RANDOM_NUMBER"
