#!/bin/bash

# set bunny api key and library id here
API_KEY="la_tua_chiave_api"
LIBRARY_ID="il_tuo_id_della_libreria"
VIDEO_FILE="/percorso/al/tuo_video.mp4"
VIDEO_TITLE="Titolo del tuo video"

# create video object and get video id
RESPONSE=$(curl -s -X POST "https://video.bunnycdn.com/library/$LIBRARY_ID/videos" \
  -H "Content-Type: application/json" \
  -H "AccessKey: $API_KEY" \
  -d "{\"title\": \"$VIDEO_TITLE\"}")

# extract video id from response
VIDEO_ID=$(echo $RESPONSE | grep -o '"guid":"[^"]*' | grep -o '[^"]*$')

# upload video file
curl -X PUT "https://video.bunnycdn.com/library/$LIBRARY_ID/videos/$VIDEO_ID" \
  -H "AccessKey: $API_KEY" \
  --upload-file "$VIDEO_FILE"
