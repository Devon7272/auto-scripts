#!/bin/bash

# clear the screen
clear

# set a counting variable, if they answer NO, they only get two more tries
COUNT=1

# read the answer, if they answer NO, loop until COUNT=3, then exit with an error
while [ $COUNT -le 3 ]; do

  # prompt for the user input, hold in a variable to test
  echo "Please enter text and numbers to test your keyboard and press enter when you are done."
  echo ""
  read USERINPUT
  echo ""

  # display the value that was read in
  echo "--------------------------------------------------"
  echo "The values that you entered were - $USERINPUT"
  echo ""
  echo "Did you see everything you typed? (Respond YES or NO)"
  echo ""

  # get the response
  read CONFIRM

  # test the response
  if [[ $CONFIRM = "YES" ]]; then
  
    # display a nice message and exit the program
    echo "Excellent - Have a Great Day"
    echo ""
    exit 0

  else

    # increment the counter and let the loop continue
    COUNT=$[ COUNT + 1 ]

    # clear the screen for the next try
    clear
  
    # let us make sure we do not display the text after we reach COUNT=3
    if [[ $COUNT < 4 ]]; then

      # display a clean message to prompt for another try
      echo "Let us try again. Please enter some text. This is try number $COUNT"
      echo ""
    
    fi

  fi

done

# if we got here, then they unsuccessfully tested their keyboard, send them to support desk
echo ""
echo "I am sorry, it appears your keyboard needs to be replaced."
echo "   Please contact the Help Desk at 514 744 2911 ext 311 "
echo ""

# custom error message for the exit
exit 60

