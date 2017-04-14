#!/bin/ksh

clear
echo "🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 "
 banner Bowling
echo "🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳 🎳🎳 🎳 🎳 🎳 "

select CHOICE in "Begin a game" "Top Statstics" "Exit"
  do
    case $CHOICE in
      "Begin a game")
        clear
        verify_Name=''
          while [[ "$verify_Name" == "" ]]; do
            clear
            trap 'print "Sorry! you cannot leave the game"' INT TERM
            echo "Please Enter Your Name:"
            read NAME
            NOW=$(date +'%m/%d/%Y %r')
            verify_Name=`echo "$NAME" | grep "^[A-Za-z][A-Za-z ]*$"`
            if [[ "$verify_Name" == "" ]]; then
              echo "!!Invalid input!! please try again..."
              sleep 0.5
            else
              touch bowling.txt
              PLAYERCHECK=`grep -i "^$NAME" bowling.txt`

              if [[ $PLAYERCHECK != "" ]]; then
                echo "Welcome back $NAME!"
                echo "Let's start the game..."
                typeset -A SCORES
                typeset -A ROLL1ARRAY
                typeset -A ROLL2ARRAY
                let FRAME=0
                while [[ $FRAME -lt 10 ]]; do
                  ROLL1=""
                  ROLL2=""
                  while [[ "$ROLL1" == "" ]]; do
                    echo "------ FRAME $(($FRAME+1)) ---------"
                    echo "Roll 1: How many pins did you knock?"
                    read ROLL1
                    ROLL1=`echo "$ROLL1" | grep "^[0-9xX][0-9]*"`
                    if [[ "$ROLL1" == "" ]]; then
                      echo "!!Invalid input!! please try again..."
                      sleep 0.5
                    fi
                  done
                  ROLL1ARRAY[$FRAME]=$ROLL1
                  echo "Roll 2: How many pins did you knock?"
                  read ROLL2
                  while [[ "$ROLL2" == "" ]]; do
                    echo "------ FRAME $(($FRAME+1)) ---------"
                    echo "Roll 2: How many pins did you knock?"
                    read ROLL1
                    ROLL1=`echo "$ROLL2" | grep "^[0-9][0-9]*"`
                    if [[ "$ROLL2" == "" ]]; then
                      echo "!!Invalid input!! please try again..."
                      sleep 0.5
                    fi
                  done
                  ROLL2ARRAY[$FRAME]=$ROLL2
                  let SUM=$(($ROLL1 + $ROLL2))
                  SCORES[$FRAME]=$SUM
                  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                  echo "| ${ROLL1ARRAY[0]} # ${ROLL2ARRAY[0]} || ${ROLL1ARRAY[1]} # ${ROLL2ARRAY[1]} || ${ROLL1ARRAY[2]} # ${ROLL2ARRAY[2]} || ${ROLL1ARRAY[3]} # ${ROLL2ARRAY[3]} || ${ROLL1ARRAY[4]} # ${ROLL2ARRAY[4]} || ${ROLL1ARRAY[5]} # ${ROLL2ARRAY[5]} || ${ROLL1ARRAY[6]} # ${ROLL2ARRAY[6]} || ${ROLL1ARRAY[7]} # ${ROLL2ARRAY[7]} || ${ROLL1ARRAY[8]} # ${ROLL2ARRAY[8]} || ${ROLL1ARRAY[9]} # ${ROLL2ARRAY[9]} ||"
                  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~SCORE TOTAL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                  echo "|(1)   ${SCORES[0]}    ||(2)   ${SCORES[1]}    ||(3)   ${SCORES[2]}    ||(4)   ${SCORES[3]}    ||(5)   ${SCORES[4]}    ||(6)   ${SCORES[5]}    ||(7)   ${SCORES[6]}    ||(8)   ${SCORES[7]}    ||(9)   ${SCORES[8]}    ||(10)   ${SCORES[9]}    |"
                  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                  echo "Score: ${SCORES[$FRAME]}"
                  let FRAME=$(($FRAME+1));
                done
                echo "Total Score: ${SCORES}"
                echo "$NAME $NOW" >> bowling.txt
              else
                echo $PLAYERCHECK
                echo "$NAME $NOW" >> bowling.txt
              fi
            fi
          done

      break;;
      "Top Statstics")
      echo "show top score"
      break;;
      Exit)
      echo "quit"
      break;;
      *) echo "!!Please enter a valid choice!!"
    esac
  done
