# An Efficient Speech-to-Sign Language Interpretation System 

> Bridging the communication gap between the hearing and speech-impaired using Deep Learning and Indian Sign Language (ISL)

## Overview

This project presents an **AI-powered real-time speech-to-sign language interpretation system** aimed at enhancing inclusive communication for the aurally challenged. The system captures spoken English, transcribes it using **Wav2Vec2.0**, and displays corresponding **Indian Sign Language (ISL)** animations through an intuitive GUI interface.

Developed using a **hybrid MATLAB–Python framework**, the system serves as a low-cost, scalable assistive tool suitable for deployment in public spaces, classrooms, or personal use.

---

## Objective

To design and implement an efficient system that:
- Captures real-time speech using MATLAB
- Transcribes speech to text using **Wav2Vec2.0 (wav2vec2-large-xlsr-53-english)**
- Maps transcribed words to ISL video animations
- Provides a seamless, GUI-based user experience

---

## Tech Stack

| Tool/Library     | Purpose                         |
|------------------|---------------------------------|
| **MATLAB**       | Audio capture & GUI integration |
| **Python**       | ASR, file handling, playback    |
| **Hugging Face** | Wav2Vec2.0 Speech-to-Text       |
| **OpenCV (cv2)** | Video playback in Python        |

---

## System Workflow

1.  Real-time speech input (MATLAB)
2.  Save as .wav (16 kHz, mono)
3.  Python script (Wav2Vec2.0 → Text)
4.  Text preprocessing & word splitting
5.  Match each word to ISL animation (.mp4)
6.  Display animations via OpenCV GUI

---

## Indian Sign Language Animated Videos

🎬 [ISL animated videos by K.Chouhan, Kaggle 2021](https://www.kaggle.com/datasets/koushikchouhan/indian-sign-language-animated-videos)

> *This link provides the ISL animated video dataset for 151 words*

---

## Output Video

🎬 [Click here to watch the demo video on Google Drive](https://drive.google.com/file/d/1eMC5qec7oBaFo1L9DzdKfhBgPEUuZ_le/view?usp=sharing)

> *This video demonstrates the real-time speech-to-sign language interpretation system.*


