#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
if [[ $WINNER != 'winner' ]]
then
  # get winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  
  # if not found
  if [[ -z $WINNER_ID ]]
  then
    #get new winner
    INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER == "INSERT 0 1" ]]
    then
    echo Inserted into teams, $WINNER
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  fi


  # get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
  # if not found
  if [[ -z $OPPONENT_ID ]]
  then
    #get new opponent
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
    then
    echo Inserted into teams, $OPPONENT
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  fi

 fi

  

  if [[ $YEAR != 'year' ]]
  then
  # Insert_game
  GAME_ID=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES( $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $GAME_ID == 'INSERT 0 1' ]]
  then
    echo Inserted into winner teams, $ROUND - $WINNER
    fi
  fi

done

