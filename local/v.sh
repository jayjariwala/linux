#!/bin/ksh

game()
{
  echo "Let's start the game..."
  typeset -A FRAMESCORES
  typeset -A ROLL1SCORE
  typeset -A ROLL2SCORE
  typeset -A TOTALSCORE
  let FRAME=0
  let SCORE=0
  let STRIKEPOINTS=0
  while [[ $FRAME -lt 10 ]]; do
    ROLL1=""
    ROLL2=""
    let STRIKE=0
    while [[ "$ROLL1" == "" ]]; do
      echo "------ FRAME $(($FRAME+1)) ---------"
      echo "Roll 1: How many pins did you knock?"
      read ROLL1
      ROLL1=`echo "$ROLL1" | grep "^[0-9][0]\?$`
      if [[ "$ROLL1" == "" ]]; then
        echo "!!Invalid input!! please try again..."
        sleep 0.5
      fi
      if [ "$ROLL1" -eq 10 ]; then
        echo "yay!"
        banner "Strike!"
        STRIKE=1
        ROLL2="X"
        let STRIKEPOINTS=1;


      fi
    done
    ROLL1SCORE[$FRAME]=$ROLL1
    if [ "$STRIKE" -eq 0 ]; then
      let REMAINING_PINS=$((10-$ROLL1))
    echo "Remaining Pins $REMAINING_PINS"
    while [[ "$ROLL2" == "" ]]; do
      echo "Roll 2: How many pins did you knock?"
      read ROLL2
      echo "There are $REMAINING_PINS pins remaining!"
      ROLL2=`echo "$ROLL2" | grep "^[0-$REMAINING_PINS][0]\?$"`
      if [[ "$ROLL2" == "" ]]; then
        echo "!!Invalid input!! please try again..."
        sleep 0.5
      fi
      if [ "$STRIKEPOINTS" -eq 1 ]; then
        let SUM=$(($ROLL1 + $ROLL2))
        echo "SUM SUM : $SUM"
        TOTALSCORE[$(($FRAME- 1))]=$((10 + $SUM));
        SCORE=$((SCORE + $ROLL1 + $ROLL2 + TOTALSCORE[$(($FRAME - 1))]))
        TOTALSCORE[$FRAME]=$SCORE
        FRAMESCORES[$FRAME]=$SUM
        echo "STRIKE POINTS: $STRIKEPOINTS"
        if [ "${ROLL1SCORE[$(($FRAME-1))]}" -eq 10 ]; then
        STRIKEPOINTS=2;
        else
          STRIKEPOINTS=0;
        fi
      else
        let SUM=$(($ROLL1 + $ROLL2))
        SCORE=$((SCORE + $ROLL1 + $ROLL2))
        TOTALSCORE[$FRAME]=$SCORE
        FRAMESCORES[$FRAME]=$SUM
        echo "STRIKE POINTS: $STRIKEPOINTS"
    #    if ["$STRIKEPOINTS" -eq 2]; then
    #      echo "DO SOMETHING NOW!"
    #    fi
      fi
    done
    fi
    ROLL2SCORE[$FRAME]=$ROLL2
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "| ${ROLL1SCORE[0]} # ${ROLL2SCORE[0]} || ${ROLL1SCORE[1]} # ${ROLL2SCORE[1]} || ${ROLL1SCORE[2]} # ${ROLL2SCORE[2]} || ${ROLL1SCORE[3]} # ${ROLL2SCORE[3]} || ${ROLL1SCORE[4]} # ${ROLL2SCORE[4]} || ${ROLL1SCORE[5]} # ${ROLL2SCORE[5]} || ${ROLL1SCORE[6]} # ${ROLL2SCORE[6]} || ${ROLL1SCORE[7]} # ${ROLL2SCORE[7]} || ${ROLL1SCORE[8]} # ${ROLL2SCORE[8]} || ${ROLL1SCORE[9]} # ${ROLL2SCORE[9]} ||"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~SCORE TOTAL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "|(1)   ${TOTALSCORE[0]}    ||(2)   ${TOTALSCORE[1]}    ||(3)   ${TOTALSCORE[2]}    ||(4)   ${TOTALSCORE[3]}    ||(5)   ${TOTALSCORE[4]}    ||(6)   ${TOTALSCORE[5]}    ||(7)   ${TOTALSCORE[6]}    ||(8)   ${TOTALSCORE[7]}    ||(9)   ${TOTALSCORE[8]}    ||(10)   ${TOTALSCORE[9]}    |"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Score: ${FRAMESCORES[$FRAME]}"
    echo "Total Score: $SCORE"
    FRAME=$(($FRAME+1));
      if [ $(($ROLL1 + $ROLL2)) -eq 0 ]; then
        echo "Opss, Its a miss! better luck next time."
      fi
      if [ "$ROLL1" -ne 10 -a "$(($ROLL1+$ROLL2))" -eq 10 ]; then
        echo "wohoo!"
        banner "spare!"
      fi

  done
  echo "Total Score: ${FRAMESCORES}"
}

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
                game
                echo "$NAME $NOW" >> bowling.txt
              else
                echo $PLAYERCHECK
                game
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
