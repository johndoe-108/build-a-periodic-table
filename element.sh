#! /bin/bash
PSQL="psql -X -U freecodecamp -d periodic_table -t -c"
if [[ -z $1 ]]
then
  echo Please provide an elmeent as an argument.
else
  # find element
  ELEMENT=$($PSQL "
    SELECT 
      atomic_number, symbol, name, 
      atomic_mass, melting_point_celsius, boiling_point_celsius,
      types.type
    FROM elements 
    INNER JOIN properties USING (atomic_number)
    INNER JOIN types USING (type_id)
    WHERE atomic_number=$1 OR 
    symbol='$1' OR name='$1'")
  
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