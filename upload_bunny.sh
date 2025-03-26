#!/bin/bash

# Configurazione
API_KEY="la_tua_chiave_api"
LIBRARY_ID="il_tuo_id_della_libreria"
VIDEO_FILE="/percorso/al/tuo_video.mp4"
VIDEO_TITLE="Titolo del tuo video"

# Creare un nuovo video nella libreria
RESPONSE=$(curl -s -X POST "https://video.bunnycdn.com/library/$LIBRARY_ID/videos" \
  -H "Content-Type: application/json" \
  -H "AccessKey: $API_KEY" \
  -d "{\"title\": \"$VIDEO_TITLE\"}")

# Estrarre l'ID del video dalla risposta
VIDEO_ID=$(echo $RESPONSE | grep -o '"guid":"[^"]*' | grep -o '[^"]*$')

# Caricare il file video
curl -X PUT "https://video.bunnycdn.com/library/$LIBRARY_ID/videos/$VIDEO_ID" \
  -H "AccessKey: $API_KEY" \
  --upload-file "$VIDEO_FILE"
