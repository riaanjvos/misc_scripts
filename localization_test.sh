#!/bin/sh

#Possible placeholders in one sentence
#Change this to max used in one sentence
PLACEHOLDER_PER_SENTENCE=10
#Only using string and double atm
PLACHOLDER_TYPE_LIST="s d"

RED='\033[0;31m'
TOTAL_FAILURES=0

for (( i=1; i <= $PLACEHOLDER_PER_SENTENCE; i++ )) ; do

	for type in $PLACHOLDER_TYPE_LIST ; do

		SEARCH="%$i\$$type"
	
		echo "Searching - "$SEARCH	
		
		TOTAL_ENG=`find app/src/main/res/values/strings.xml | xargs grep -i $SEARCH | wc -l`
		
		for directory in app/src/main/res/values-*/strings.xml ; do
    
    		TOTAL=`find $directory | xargs grep -i $SEARCH | wc -l`
    		
    		if [ "$TOTAL_ENG" != "$TOTAL" ] ; then
    		
    			FAILS=$(expr $TOTAL_ENG - $TOTAL)
    		
    			TOTAL=`echo $TOTAL | xargs`
    			TOTAL_ENG=`echo $TOTAL_ENG | xargs`
    		
    			echo "\t${RED}"$FAILS" Issues detected in $directory\t($TOTAL / $TOTAL_ENG placeholders found)"
    			tput sgr0 
		
				TOTAL_FAILURES=$(expr $TOTAL_FAILURES + $FAILS)
    		fi
    	done
	done
done

echo "\n"$TOTAL_FAILURES" placeholder issues detected.\n"
echo "Done!"