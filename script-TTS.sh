#!/bin/bash

# Commande pour générer le fichier audio
#echo "I have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin but by the content of their character." | ./piper/piper --model ./voices/en_US-amy-medium.onnx --output_file ./TEST/testEN2.wav


## CONSTANTES
VOICES_PATH="./voices/"
OUTPUT_PATH="./TTS_OUTPUT/"
PIPER_COMMAND="./piper/piper"
MPLAYER_COMMAND="mplayer"

## LANGUES
FR="fr_FR-mls-medium.onnx"
EN="en_US-amy-medium.onnx"
nb_languages=2


# demander à l'utilisateur la phrase à dire
echo "Veuillez saisir le texte que vous souhaitez convertir en audio :"
read -p ">>> " input_text

# final input on rajoute piper voice devant sinon l'audio coupe 
FINAL_INPUT="${input_text}" 

#separateur
echo "- - - - - - - - - - - - - - - - - - - - - - - - - -"


# demande à l'utilisateur quelle langue utiliser
langue_user=0
langue_erreur=false
while ! [[ "$langue_user" =~ ^[0-9]+$ ]] || [ "$langue_user" -le 0 ] || [ "$langue_user" -gt $nb_languages ]; do
  # si la langue n'est pas valide
  if $langue_erreur; then
    echo "---- Erreur : veuillez entrer un chiffre entre 1 et $nb_languages ----"
  fi

  langue_erreur=true
  echo "Veuillez choisir la langue :"
  echo "1 - Français"
  echo "2 - Anglais"
  read -p ">>> " langue_user
done



# Déterminer le modèle en fonction de la langue choisie
if [ "$langue_user" -eq 1 ]; then
  VOICE=$FR
elif [ "$langue_user" -eq 2 ]; then
  VOICE=$EN
else
  echo "Langue non valide."
  exit 1
fi


#separateur
echo "- - - - - - - - - - - - - - - - - - - - - - - - - -"

# Construire le chemin complet du modèle
MODEL_PATH="${VOICES_PATH}${VOICE}"


# Définir le fichier de sortie
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="${OUTPUT_PATH}_${TIMESTAMP}.wav"


# commande du TTS
echo "$FINAL_INPUT" | ./piper/piper --model "$MODEL_PATH" --output_file "$OUTPUT_FILE"

# Vérifie si la première commande a réussi
if [ $? -eq 0 ]; then
  # Commande pour lire le fichier audio
  mplayer "$OUTPUT_FILE"
else
  echo "La génération du fichier audio a échoué."
fi
