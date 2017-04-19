#!/bin/ksh

game()
{
  echo "##### Let's Play #####"
  #TOTAL NUMBER OF FRAMES IN THE GAME
  FRAME_NO=0;

  #ARRAY TO STORE HISTORY OF ALL FRAMES
    #STORES ALL ROLL1 SCORES PER GAME
    typeset -A ROLL1_SCORES
    #SORES ALL ROLL2 SOCRES PER GAME
    typeset -A ROLL2_SCORES
    #STOERS ROLL1 + ROLL2 = FRAME
    typeset -A FRAME_TOTAL
    #KEEP TRACK OF UPTODATE GAME SCORE
    typeset -A ENDOF_FRAME_SCORE

    #FLAGS SET ACCORDING TO GAME VARIATIONS
    let SPARE=0
    let SPECIAL_CASE=0
    STRIKE_OCCURENCE=""
    let STRIKE=0
  while [[ FRAME_NO -lt 10 ]]; do
    echo "-----------------------FRAME $(($FRAME_NO+1))---------------------------------------"
    ROLL1=""
    ROLL2=""
    ROLL3=""
    while [[ "$ROLL1" -eq "" ]]; do
      read ROLL1?"Roll 1 Score:"
      ROLL1=`echo "$ROLL1" | grep "^[0-9][0]\?$`

      #CHECK INPUT FOR ROLL1 (ENTERED NUMBER IS VALID OR NOT)
      if [[ "$ROLL1" -eq "" ]]; then
        echo "!!Invalid input!! please try again..."
        sleep 1
      else
        let REMAINING_PINS=$((10-$ROLL1))
        echo "There are $REMAINING_PINS pins left..."
      fi
      #PUSH ROLL1
      ROLL1_SCORES[$FRAME_NO]=$ROLL1
    done




    if [[ "$ROLL1" -ne 10 ]]; then
      echo "STRIKE_OCCURENCE TIMES $STRIKE_OCCURENCE"
      while [[ "$ROLL2" -eq "" ]]; do
        read ROLL2?"Roll 2 Score:"
        if [[ "$ROLL1" -eq 0 ]]; then
          ROLL2=`echo "$ROLL2" | grep "^[0-$REMAINING_PINS][0]\?$"`
        else
          ROLL2=`echo "$ROLL2" | grep "^[0-$REMAINING_PINS]$"`
        fi

        #CHECK INPUT FOR ROLL2 (ENTERED NUMBER IS VALID OR NOT)
        if [[ "$ROLL2" -eq "" ]]; then
          echo "!!Invalid input!! please try again..."
          sleep 1
        fi
        #PUSH ROLL2
        ROLL2_SCORES[$FRAME_NO]=$ROLL2
      done
    fi




    #OVERALL SCORE COUTING FOR PREVIOUS FRAME
    #IF SPARE OCCURED PREVIOUSLY
    if [[ "$SPARE" -eq 1 ]]; then
      if [[ "$FRAME_NO" -eq 1 ]]; then
        ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$(( 10 +  $(($ROLL1))))
      else
        ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$(( ${ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]} + 10 +  $(($ROLL1))))
      fi
        SPARE=0
    fi


    #FRAME SCORE COUNTING
    #IF THE SPARE OCCURES (SKIP THE FRAME SCORE)
    if [[ "$ROLL1" -ne 10 && "$ROLL1" -ne "" && "$ROLL2" -ne "" && "$(($ROLL1+$ROLL2))" -eq 10 ]]; then
      #CALCULTE SPECIAL CASE FOR 10TH FRAME
      if [[ "$FRAME_NO" -eq 9 ]]; then
        #IF STIKE OCCURS
        if [[ "$ROLL1" -ne 10 && "$(($ROLL1 + $ROLL2))" -eq 10 ]]; then
          while [[ "$ROLL3" -eq "" ]]; do
            read ROLL3?"Roll 3 Score:"
            ROLL1=`echo "$ROLL3" | grep "^[0-9][0]\?$`

            #CHECK INPUT FOR ROLL1 (ENTERED NUMBER IS VALID OR NOT)
            if [[ "$ROLL3" -eq "" ]]; then
              echo "!!Invalid input!! please try again..."
              sleep 1
            fi
          done

          SPECIAL_CASE=1
        fi
      fi

      FRAME_TOTAL[$FRAME_NO]=10
      SPARE=1;

      #IF STRIKE_OCCURENCE
    elif [[ "$STRIKE" -eq 1 && "$ROLL1" -eq 10 ]]; then
        FRAME_TOTAL[$FRAME_NO]=$ROLL1

      #CALCULATE THE FRAME SCORE NOMAL WAY
      elif [[ "$ROLL1" -ne 10 && "$ROLL1" -ne "" && "$ROLL2" -ne "" && "$(($ROLL1+$ROLL2))" -ne 10 ]]; then
        FRAME_TOTAL[$FRAME_NO]=$(($ROLL1+$ROLL2))
    fi


    # OVERALL SCORE COUNTING FOR CURRENT FRAME
    if [[ "$SPECIAL_CASE" -eq 1 ]]; then
      ENDOF_FRAME_SCORE[$FRAME_NO]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]} + $ROLL1 + $ROLL2 + $ROLL3))
    elif [[ "$SPARE" -eq 1 && "$SPECIAL_CASE" -eq 0 ]]; then
      ENDOF_FRAME_SCORE[$FRAME_NO]=""
      # STRIKE AND SPARE COMBO
      if [[ "$STRIKE" -eq 1 ]]; then
        if [[ "$STRIKE_OCCURENCE" == "FIRST_TIME" ]]; then
          if [[ "$FRAME_NO" -eq 0 ]]; then
          ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$((${ROLL1_SCORES[$((FRAME_NO-1))]} + $ROLL1 + $ROLL2))
          STRIKE_OCCURENCE=""
          STRIKE=0
          else
          ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$(( ${ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$((FRAME_NO-1))]} + $ROLL1 + $ROLL2))
          STRIKE_OCCURENCE=""
          STRIKE=0
          fi
        elif [[ "$STRIKE_OCCURENCE" == "SECOND_TIME" ]]; then
          echo "COMBO !!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        elif [[ "$STRIKE_OCCURENCE" == "THIRD_TIME" ]]; then
          echo "THIRD COMBO !!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        fi
      fi
    elif [[ "$ROLL1" -eq 10 && $STRIKE_OCCURENCE -eq "" ]]; then
      ENDOF_FRAME_SCORE[$FRAME_NO]=""
    elif [[ "$ROLL1" -ne 10 && "$STRIKE" -eq 1 && $STRIKE_OCCURENCE == "FIRST_TIME" ]]; then
      if [[ $FRAME_NO = 1 ]]; then
      ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$((${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 + $ROLL2 ))
      ENDOF_FRAME_SCORE[$FRAME_NO]=$(( ${ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]} + $ROLL1 + $ROLL2 ))
      STRIKE_OCCURENCE=""
      STRIKE=0
      else
      ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 + $ROLL2 ))
      ENDOF_FRAME_SCORE[$FRAME_NO]=$(( ${ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]} + $ROLL1 + $ROLL2 ))
      STRIKE_OCCURENCE=""
      STRIKE=0
      fi
    elif [[ "$ROLL1" -ne 10 && "$STRIKE" -eq 1 && $STRIKE_OCCURENCE == "SECOND_TIME" ]]; then
      if [[ "$FRAME_NO" -eq 2 ]]; then
      ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]=$((${ROLL1_SCORES[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 ))
      ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 + $ROLL2 ))
      ENDOF_FRAME_SCORE[$FRAME_NO]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]} + ${FRAME_TOTAL[$FRAME_NO]}))
      STRIKE_OCCURENCE=""
      STRIKE=0
      else
        ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-3))]} + ${ROLL1_SCORES[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 ))
        ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 + $ROLL2 ))
        ENDOF_FRAME_SCORE[$FRAME_NO]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]} + ${FRAME_TOTAL[$FRAME_NO]}))
        STRIKE_OCCURENCE=""
        STRIKE=0
      fi
    elif [[ "$STRIKE_OCCURENCE" == "THIRD_TIME" && "$STRIKE" -eq 1 && "$ROLL1" -ne 10 ]]; then
      ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-3))]} + ${ROLL1_SCORES[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 ))
      ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 + $ROLL2 ))
      ENDOF_FRAME_SCORE[$FRAME_NO]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]} + ${FRAME_TOTAL[$FRAME_NO]}))
      STRIKE_OCCURENCE=""
      STRIKE=0
    echo "do something"
    else
      #COUNT THE NORMAL WAY (LASTFRAMESCORE + CURRENT FRAME SCORE)
      if [[ "$FRAME_NO" -eq 0 ]]; then
      ENDOF_FRAME_SCORE[$FRAME_NO]=$(( 0 + ${FRAME_TOTAL[$FRAME_NO]}))
      fi
      ENDOF_FRAME_SCORE[$FRAME_NO]=$((${ENDOF_FRAME_SCORE[$(($FRAME_NO-1))]} + ${FRAME_TOTAL[$FRAME_NO]}))
    fi

    #CALCULTE HOW MANY TIMES STRIKE_OCCURENCE OCCURED
        if [[ "$ROLL1" -eq  10 ]]; then
            STRIKE=1
          if [[ "$FRAME_NO" -eq 0 ]]; then
            STRIKE_OCCURENCE="FIRST_TIME"
            echo "FIRST_TIME"
          elif [[ "$FRAME_NO" -eq 1 ]]; then
            if [[ "${ROLL1_SCORES[$(($FRAME_NO-1))]}" -eq 10 ]]; then
              STRIKE_OCCURENCE="SECOND_TIME"
              echo "SECOND_TIME"
            else
              STRIKE_OCCURENCE="FIRST_TIME"
              echo "FIRST_TIME"
            fi
          else
            if [[ "${ROLL1_SCORES[$(($FRAME_NO - 2))]}" -eq 10 && "${ROLL1_SCORES[$(( $FRAME_NO - 1))]}" -eq 10 ]]; then
              if [[ "$FRAME_NO" -eq 2 ]]; then
              ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]=$((${ROLL1_SCORES[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 ))
              else
              ENDOF_FRAME_SCORE[$(($FRAME_NO-2))]=$(( ${ENDOF_FRAME_SCORE[$(($FRAME_NO-3))]} + ${ROLL1_SCORES[$(($FRAME_NO-2))]} + ${ROLL1_SCORES[$(($FRAME_NO-1))]} + $ROLL1 ))
              fi
              STRIKE_OCCURENCE="THIRD_TIME"
            elif [[ "${ROLL1_SCORES[$(($FRAME_NO - 1))]}" -eq 10 && "$ROLL1" -eq 10 && "${ROLL1_SCORES[$(($FRAME_NO - 2))]}" -ne 10 ]]; then
              STRIKE_OCCURENCE="SECOND_TIME"
              echo "SECOND_TIME"
            elif [[ "${ROLL1_SCORES[$(($FRAME_NO - 1))]}" -ne 10 && "$ROLL1" -eq 10 ]]; then
              STRIKE_OCCURENCE="FIRST_TIME"
              echo "FIRST_TIME"
            fi
          fi
        fi



    #RESULT AT THE END OF EACH FRAMES
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      echo "| ${ROLL1_SCORES[0]} # ${ROLL2_SCORES[0]} || ${ROLL1_SCORES[1]} # ${ROLL2_SCORES[1]}  || ${ROLL1_SCORES[2]} # ${ROLL2_SCORES[2]} || ${ROLL1_SCORES[3]} # ${ROLL2_SCORES[3]} || ${ROLL1_SCORES[4]}  # ${ROLL2_SCORES[4]} || ${ROLL1_SCORES[5]} # ${ROLL2_SCORES[5]} || ${ROLL1_SCORES[6]}  # ${ROLL2_SCORES[6]} || ${ROLL1_SCORES[7]} # ${ROLL2_SCORES[7]} || ${ROLL1_SCORES[8]} # ${ROLL2_SCORES[8]} || ${ROLL1_SCORES[9]} # ${ROLL2_SCORES[9]} ||"
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~SCORE TOTAL~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      echo "|(1) ${ENDOF_FRAME_SCORE[0]}  ||(2) ${ENDOF_FRAME_SCORE[1]}  ||(3) ${ENDOF_FRAME_SCORE[2]}  ||(4) ${ENDOF_FRAME_SCORE[3]} ||(5) ${ENDOF_FRAME_SCORE[4]} ||(6) ${ENDOF_FRAME_SCORE[5]}  ||(7) ${ENDOF_FRAME_SCORE[6]} ||(8) ${ENDOF_FRAME_SCORE[7]} ||(9) ${ENDOF_FRAME_SCORE[8]}     ||(10) ${ENDOF_FRAME_SCORE[9]} |"
      echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

    #INCREMENT THE FRAME NO
    FRAME_NO=$((FRAME_NO+1))

  done


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
                clear
                echo "Welcome back $NAME!"
                game
                echo "$NAME $NOW" >> bowling.txt
              else
                clear
                echo "Welcome $NAME! Looks like you are here for the first time."
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
