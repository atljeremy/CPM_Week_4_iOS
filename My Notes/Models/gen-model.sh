#! /bin/sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ACTIONS
# These are implemented as functions, and just called by the
# short MAIN section below

buildAction () {
    	echo "Building..."
	modeld=./My_Notes.xcdatamodeld
	modelversion=$(/usr/libexec/PlistBuddy -c 'print _XCCurrentVersionName' $modeld/.xccurrentversion)
	model=$modeld/$modelversion
	echo "Mo'Generating code for $model..."
	mogenerator -m "$model" --template-var arc=true --human-dir . --machine-dir ./Generated
}

cleanAction () {
    	echo "Cleaning..."
	rm -f ./Generated/*
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# MAIN

echo "Running with ACTION=${ACTION}"

case $ACTION in
    # NOTE: for some reason, it gets set to "" rather than "build" when
    # doing a build.
    "")
        buildAction
        ;;

    "clean")
        cleanAction
        ;;
esac

exit 0
