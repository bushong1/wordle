#!/bin/bash

# Usage:
# * Run with ./regex.sh
# * Edit the below variables to tweak your search, either with info you have, or to explore options
# * All letters should be lowercase, without any spaces between
# * Other Commands:
#   * ./regex.sh unique
#     If you want only words with 5 different letters
#   * ./regex.sh count
#     If you want a count of how many of each letter appear in the output

# When you're exploring for words and just want some specific letters
yes_somewhere=

# Black/White: When you know a letter isn't anywhere
not_anywhere=ay

# Green: When you definitely know a letter
letter1_is=
letter2_is=
letter3_is=r
letter4_is=d
letter5_is=

# Yellow: When you definitely know where a letter isn't, but know it's in the word somewhere
letter1_is_not=
letter2_is_not=w
letter3_is_not=
letter4_is_not=
letter5_is_not=

###############################################
## Do not edit below
###############################################
letter1block=${letter1_is:-^${letter1_is_not:-,}${not_anywhere}}
letter2block=${letter2_is:-^${letter2_is_not:-,}${not_anywhere}}
letter3block=${letter3_is:-^${letter3_is_not:-,}${not_anywhere}}
letter4block=${letter4_is:-^${letter4_is_not:-,}${not_anywhere}}
letter5block=${letter5_is:-^${letter5_is_not:-,}${not_anywhere}}
yes_letters=$(echo "${yes_somewhere}${letter1_is_not}${letter2_is_not}${letter3_is_not}${letter4_is_not}${letter5_is_not}" | sed -E 's/(.)/\1,/g')

narrowed_down=$(cat wordle-allowed-guesses.txt | grep -e "[$letter1block][$letter2block][$letter3block][$letter4block][$letter5block]")

for letter in ${yes_letters//,/ }; do
  #echo "Narrowing further by requiring: $letter";
  narrowed_down=$(echo $narrowed_down | sed 's/ /\n/g' | grep "$letter")
done


case $1 in
  unique)
    for word in `echo "$narrowed_down" | sed 's/ /\n/g'`; do
      length=$(grep -o . <<< $word | sort -u | paste -s -d '\0' - | awk '{ print length }')
      if [[ $length > 4 ]]; then echo $word; fi
    done
    ;;
  count)
    echo "$narrowed_down" | sed 's/./&\n/g' | sort | uniq -ic | sort -n
    ;;
  *)
    echo $narrowed_down | sed 's/ /\n/g'
    ;;
esac
