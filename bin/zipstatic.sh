#!/bin/bash
ROOTDIR=$(cd `dirname "${0}"`/.. && pwd)
RESOURCESDIR=${ROOTDIR}/src/staticresources
PROJECTNAME=`basename $ROOTDIR`
MM_WORKSPACE=`dirname $ROOTDIR`

TARGET=$1

if [ -z "$TARGET" -o ! -d "$RESOURCESDIR/$TARGET" ]
then
	echo "Invalid static resource container $TARGET"
	exit 1
fi

echo "Start watching for changes in $TARGET"

MM_LOGFILE="$RESOURCESDIR/$TARGET/mm.log"

fswatch -0 $RESOURCESDIR/$TARGET | while read -d "" event
do
	if [ "${event}" != "${MM_LOGFILE}" ]
	then
		echo "File changed: ${event}"

		cd $RESOURCESDIR/$TARGET
		if [ -f "${MM_LOGFILE}" ]
		then
			rm "${MM_LOGFILE}"
		fi

		echo "Compressing files in $TARGET"

		zip -r ../${TARGET}.resource *

		echo "Uploading archive to SalesForce"

		~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/MavensMate/mm/mm -o compile -c SUBLIME_TEXT_3 <<< '{"project_name": "'${PROJECTNAME}'", "workspace": "'${MM_WORKSPACE}'", "files": ["'${RESOURCESDIR}/${TARGET}'.resource"]}'

		if [ -f "${MM_LOGFILE}" ]
		then
			rm "${MM_LOGFILE}"
		fi

		echo
	fi
done
