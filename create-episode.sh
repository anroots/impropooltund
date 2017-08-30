#!/bin/bash

# New podcast episode release script
#
# This will:
#   - take an input file from .mp3 editor
#   - ask some metadata about the new episode
#   - rename the input file to a standard filename format
#   - create a .m4a encoded file
#   - write ID3 tags to both audio files

if [ $# -eq 0 ]
  then
    echo "No arguments supplied - give me a .mp3 file as a input!"
    exit 1
fi

if [ ! -f player.html ]; then
    echo "Run me from the web root folder!"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "The input file $1 does not exist!"
    exit 1
fi


# ID3 tag an audio file
# The argument to this needs to be a path to an audio file
function id3tag {
	
	eyeD3 --remove-all $1
	
	eyeD3 --artist "$ARTIST" $1
	eyeD3 --album "$ALBUM" $1
	eyeD3 --title "$TITLE" $1
	eyeD3 --track "$TRACK" $1
	eyeD3 --genre "$GENRE" $1
	eyeD3 -Y `date +"%Y"` $1
	eyeD3 --add-comment="https://pooltund.improv.ee" $1
	eyeD3 --add-image ./images/cover.jpg:FRONT_COVER $1
	eyeD3 --url-frame "WOAF:https\://pooltund.improv.ee/osad/$TRACK" $1
	eyeD3 --url-frame "WPUB:https\://pooltund.improv.ee" $1
}


echo "Creating a new podcast episode - provide some metadata."
echo ""

echo 'Episode Title (Minu Relv On Minu Keha): '
read TITLE
TITLE_SAFE=`echo $TITLE | tr ' ' '-'`
echo ""

echo "List of Participants (comma-separated names: Ando Roots, Timo Talvik): "
read ARTIST
echo ""

echo "Episode Number: "
read TRACK

echo ""
echo "Publish Date (2017-02-21): "
read PUBLISH_DATE


ALBUM="Impropooltund"
GENRE="Podcast"

INPUT_AUDIO_FILE="$1"
MP3_FILE="$PUBLISH_DATE-$ALBUM-$TRACK-$TITLE_SAFE.mp3"
M4A_FILE="$PUBLISH_DATE-$ALBUM-$TRACK-$TITLE_SAFE.m4a"


echo ""
echo "-------------------------------------------------------------------"
echo "Input file:  $INPUT_AUDIO_FILE"
echo "Output .mp3: $MP3_FILE"
echo "Output .m4a: $M4A_FILE"
echo ""
echo "Episode Title: $TITLE"
echo "Artists: $ARTIST"
echo "Track: $TRACK"
echo "Published: $PUBLISH_DATE"
echo "-------------------------------------------------------------------"
echo ""

read -p "Does that look OK? [y/n]" -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo "Aborting"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

mv $INPUT_AUDIO_FILE $MP3_FILE

id3tag $MP3_FILE

# Create a 128-bit .m4a file
ffmpeg -y -i $MP3_FILE -vn -c:a aac \
	-b:a 128k -ac 2 \
	-r:a 48000 -b:a 128k \
	"$M4A_FILE" 

if [ $? -ne 0 ]; then
    echo "Transcoding failed!"
    exit 1
fi

id3tag $M4A_FILE

echo "Done"