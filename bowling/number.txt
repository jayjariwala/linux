#!/bin/ksh

#function to validate a number

NumValidator()
{
    while [ true ]
      clear
      do
      echo "please enter a number:"
      read NUMBER
      VERIFY_NUM=`echo "$NUMBER" | grep "^[0-9][0-9]*$"`
      if [ "$VERIFY_NUM" -ne "" ]
        then
        break;
      else
        echo "!!!!!!!!!!!!!!Invalid Number!!!!!!!!!!!!!!!!!!"
        sleep 2
      fi
    done
}

#Function to calculate EVEN and ODD numbers
EvenOdd()
{

  if [ `expr $NUMBER % 2` -ne 0 ]
    then echo "$NUMBER is an odd Number"
  else
    echo "$NUMBER is an even number"
  fi
}

#Function to calculate the number is prime or not
PrimeCalculate()
{
  if [ $NUMBER -eq 1 ]; then
    echo "$NUMBER is not a prime number"
  fi
  if [ $NUMBER -eq 2 ]; then
    echo "$NUMBER is a prime number"
  fi
  let i=2
  while [ $NUMBER -gt $i ];
  do
    if [ `expr $NUMBER % $i` -eq 0 ];
     then
      echo "$NUMBER is not a prime number"
      break;
    else
      echo "$NUMBER is a prime number"
      break;
    fi
    i=`expr $i + 1`
  done

}

read U_NAME?"Please Enter Your Full Name: "
verify_Name=`echo "$U_NAME" | grep "^[A-Za-z]* [A-Za-z]*$"`

read ID?"Enter ID: "
VERIFY_NUM=`echo "$ID" | grep "^[0-9][0-9]*$"`

if [ "$verify_Name" = "" ] || [ "$VERIFY_NUM" -eq "" ];
  then
  echo "SORRY! Please Understand the input requirement given as below"
  echo "*******************************************************"
  echo "1) Enter Your Full Name seprated by a space: (e.g Jay Jariwala) and it only contains letters"
  echo "2) Enter Your student Id (e.g 1721563) and it only contains numeric numbers"
  echo "*******************************************************"
else
  FIRST_NAME=$(echo $U_NAME | cut -d' ' -f1)
  while [ true ];
   do
    clear
     echo "How would you like to evalute a number?"
     select CHOICE in "Even/Odd" "Prime" "Both" "Exit"
       do
         case $CHOICE in
           Even/Odd)
             NumValidator
               echo "*******************************************************"
               echo "Hey $FIRST_NAME!"
               EvenOdd $NUMBER
           break;;
           Prime)
             NumValidator
               echo "*******************************************************"
               echo "Hey $FIRST_NAME!"
               PrimeCalculate $NUMBER
           break;;
           Both)
             NumValidator
               echo "*******************************************************"
               echo "Hey $FIRST_NAME!"
               EvenOdd $NUMBER
               PrimeCalculate $NUMBER
           break;;
           Exit)
               echo "I quit, bye bye!"
               exit
           break;;
           *) echo "Sorry! I don't know that choice"
         esac
       done
        echo "Press Enter to continue..."
        read BLANK
   done
fi