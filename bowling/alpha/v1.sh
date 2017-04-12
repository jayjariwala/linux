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
        verify_Name=""
          while [[ "$verify_Name" = "" ]]; do
            clear
            trap 'print "Sorry! you cannot leave the game"' INT TERM
            echo "Please Enter Your Name:"
            read NAME
            NOW=$(date +'%m/%d/%Y %r')
            verify_Name=`echo "$NAME" | grep "^[A-Za-z][A-Za-z ]*$"`
            if [[ "$verify_Name" =  "" ]]; then
              echo "!!Invalid input!! please try again..."
              sleep 1
            fi
            echo "your name : $NAME"
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
