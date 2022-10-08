#! /bin/bash
PSQL="psql -X -U freecodecamp -d periodic_table -t -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # find element
  QUERY="SELECT 
      atomic_number, symbol, name, 
      atomic_mass, melting_point_celsius, boiling_point_celsius,
      types.type
    FROM elements 
    INNER JOIN properties USING (atomic_number)
    INNER JOIN types USING (type_id)"
  
  if [[ $1 =~ [0-9]+ ]]
  then
    WHERE_CONDITION="
      WHERE atomic_number=$1"
  else
    WHERE_CONDITION="
      WHERE symbol='$1' OR name='$1'"
  fi
  
  ELEMENT=$($PSQL "$QUERY $WHERE_CONDITION")
  
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi