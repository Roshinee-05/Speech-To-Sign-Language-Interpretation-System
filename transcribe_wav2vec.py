# transcribe_wav2vec.py

import os
import torch
import librosa
import cv2
from transformers import Wav2Vec2ForCTC, Wav2Vec2Processor

# Load model and processor globally (so it doesn’t reload each time)
model_name = "jonatasgrosman/wav2vec2-large-xlsr-53-english"
model = Wav2Vec2ForCTC.from_pretrained(model_name)
processor = Wav2Vec2Processor.from_pretrained(model_name)

def transcribe_audio(audio_path):
    audio_input, _ = librosa.load(audio_path, sr=16000)
    inputs = processor(audio_input, sampling_rate=16000, return_tensors="pt", padding=True)

    with torch.no_grad():
        logits = model(inputs.input_values).logits

    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.decode(predicted_ids[0])

    return transcription

def show_sign_videos(transcription, video_folder=r"C:\Users\nivet\OneDrive\ドキュメント\MATLAB\DSP_PRO\videos\INDIAN SIGN LANGUAGE ANIMATED VIDEOS"):
    if hasattr(transcription, 'lower'):  # MATLAB passes a py.str object
        transcription = transcription.lower()
        transcription = transcription.capitalize()
    else:
        transcription = str(transcription).lower()
        transcription = transcription.capitalize()
    

    words = transcription.split()

    for word in words:
        video_path = os.path.join(video_folder, f"{word}.mp4")
        if os.path.exists(video_path):
            print(f"🎬 Showing sign for: {word}")
            play_video(video_path)
        else:
            print(f"⚠️ No video found for: {word}")

def play_video(video_path):
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        print(f"❌ Failed to open video: {video_path}")
        return

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break
        cv2.imshow("Sign Language Video", frame)
        if cv2.waitKey(30) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()

