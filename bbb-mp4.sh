#!/bin/bash

# Load .env variables
set -a
source <(cat  /var/www/bbb-mp4/.env | \
    sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
set +a

MEETING_ID=$1

echo "converting $MEETING_ID to mp4" |  systemd-cat -p warning -t bbb-mp4

docker run --rm -d \
                --name $MEETING_ID \
                -v $COPY_TO_LOCATION:/usr/src/app/processed \
                --env REC_URL=https://$BBB_DOMAIN_NAME/playback/presentation/2.3/$MEETING_ID \
                manishkatyan/bbb-mp4

# waiting for the conversion to complete
docker wait $MEETING_ID
echo "conversion completed. uploading to bunny library..." | systemd-cat -p warning -t bbb-mp4

# adapt this path to your needs -- i'm using the default one i got on my bbb installation
MP4_FILE="/var/www/bigbluebutton-default/recording/$MEETING_ID.mp4"

# checking if file exists
if [ -f "$MP4_FILE" ]; then
    echo "Uploading $MP4_FILE to Bunny.net" | systemd-cat -p warning -t bbb-mp4
    
    # upload to bunny library
    /path/to/upload_to_bunny.sh "$MEETING_ID" "$MP4_FILE"
else
    echo "File $MP4_FILE not found. Upload skipped." | systemd-cat -p err -t bbb-mp4
fi
