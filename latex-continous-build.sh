#!/bin/bash

# this script continously build a Latex source if the source file is modified.
# A single source file is assumed.
# Works only in Mac OSX because of the stat command used to get the last modidied time stamp.
echo "Provide the Latex project file name (without .tex): "
read latex_file

if [ -e $latex_file'.tex' ]
then
	echo "Building the latex project $latex_file"
else
	echo "No such file as $latex_file"
	exit
fi

# Latex Build function
function build
{
	``pdflatex $latex_file'.tex'``	
	``bibtex $latex_file'.aux'``
	``bibtex $latex_file'.aux'``
	``pdflatex $latex_file'.tex'``
	``pdflatex $latex_file'.tex'``
}

# start with a build
build
# last build timestamp
last_build=$(date +%s)
# last modified time. Works only with Mac OSX
modified_time=$(stat -f %m $latex_file'.tex')

while :
 do
	echo 'Last Build :'$last_build', Last Modified: '$modified_time
	# build the latex source if the last modified time > last build.
	if [ $last_build -lt $modified_time ];then
		echo "Going to build.."
		build
		last_build=$modified_time
	fi
	# sleep for 5 seconds and check again.
	sleep 5s
	# read the last modified time
	modified_time=$(stat -f %m $latex_file'.tex')
done

