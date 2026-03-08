# CyberQuest: Gamified Cybersecurity Learning Adventure

![Game Banner](path/to/banner.png)  
*Insert a high-quality game screenshot or banner here.*

---

## 🎮 Project Overview

**CyberQuest** is an **interactive, educational RPG** built with **Godot Engine**, designed to make learning cybersecurity concepts immersive, fun, and engaging. Players navigate through detailed **maps**, fight enemies, solve challenges, and learn real-world cybersecurity practices—all within an interactive game world.  

Many individuals are unaware of basic cybersecurity risks they face daily. In the modern digital world, even fundamental knowledge about staying safe online is critical. **CyberQuest** addresses this gap by embedding cybersecurity learning **directly into gameplay**, rather than relying on traditional quizzes or documentation.  

Unlike conventional educational tools, our game makes learning **involuntary**: the RPG-style mechanics and interactive maps fully engross players, so learning happens **naturally** while they explore, battle enemies, and complete objectives. This approach leverages **passive memory**, helping users retain knowledge faster and more effectively.

---

## 🌐 Features & Gameplay

### Core Gameplay
- **RPG-style exploration:** Move through rich, pixel-art maps, interact with rooms, NPCs, and discover hidden challenges.  
- **Real-time combat:** Fight enemies using both skill and knowledge. Correctly answering cybersecurity questions empowers attacks.  
- **Dynamic battle system:** Wrong answers reduce your health, reinforcing the consequences of mistakes.  
- **Multiple levels/maps:** Each map represents a different topic or challenge in cybersecurity, from basic Linux commands to privilege escalation.  

### Gamified Learning
- **Embedded questions:** Learning is integrated into gameplay; players solve cybersecurity questions during combat.  
- **Score-based progression:** Players earn points for correct answers. Advancement to new maps or rooms requires reaching score thresholds.  
- **Health & challenge mechanics:** Wrong answers or enemy attacks reduce health, adding stakes and realism to learning.  

### Map & Environment Design
- Diverse **interactive maps** in the `maps/` directory, each with themed zones for different cybersecurity topics.  
- **Enter zones** trigger challenges and learning modules.  
- **Environmental storytelling**: Maps include visual cues, terminals, and interactive elements to reinforce learning.  

---

## 🏆 Learning Objectives

**CyberQuest** transforms passive study into an engaging experience:

- Understand fundamental cybersecurity concepts while actively exploring maps.  
- Apply knowledge in realistic scenarios, e.g., ethical hacking, network scanning, web exploitation.  
- Experience consequences of errors, reinforcing practical understanding.  
- Build problem-solving and analytical skills through RPG-style challenges.  
- Retain knowledge effectively via **immersive gamification** rather than rote memorization.  

---

## 📸 Screenshots

<img width="1502" height="955" alt="Screenshot 2026-03-08 074810" src="https://github.com/user-attachments/assets/16b31200-37d3-462a-8d1b-512d60af2760" />

<img width="1505" height="955" alt="Screenshot 2026-03-08 074837" src="https://github.com/user-attachments/assets/5c630774-d635-43a7-89e2-07fecd1abb41" />

<img width="1503" height="939" alt="Screenshot 2026-03-08 074917" src="https://github.com/user-attachments/assets/a0ccfe13-d59e-46d7-9f53-4f807d79d1de" />

<img width="1502" height="955" alt="Screenshot 2026-03-08 075037" src="https://github.com/user-attachments/assets/d9a332df-5f4b-4f06-ad19-b9512de2a5a9" />

<img width="1917" height="912" alt="Screenshot 2026-03-08 075109" src="https://github.com/user-attachments/assets/44200cf5-d019-42d3-9887-c623f3daaf44" />

---

## 🗂 Project Structure

```text
CyberQuest/
├── assets/             # Game sprites, sounds, textures
├── maps/               # Pixel-art maps with interactive zones
├── scenes/             # Godot scene files for levels, UI, enemies, and players
├── scripts/            # GDScript files (player.gd, enemy.gd, UI scripts, battle system)
├── questions.json      # Question database for gamified cybersecurity challenges
├── project.godot       # Godot project configuration file
├── .import/            # Godot import folder (ignored in Git)
└── README.md           # Project documentation



## 🎮 Gameplay Mechanics

- **Health & Combat:**  
  Players and enemies have health bars. Answering questions correctly deals damage; wrong answers or being hit by enemies decreases health.

- **Score System:**  
  Accumulate scores to unlock new maps and rooms. Only after achieving enough points can players progress to the next level.

- **Room Challenges:**  
  Each room contains a terminal or learning module. Completing challenges earns points and teaches practical cybersecurity skills.

- **Level Progression:**  
  Scores from previous levels carry over to the next, reinforcing cumulative learning.

---

## 🧩 Maps & Zones

Each map in `maps/` has multiple interactive zones, such as:

- **Terminals for practice**  
- **Puzzle rooms with questions**  
- **Enemy spawn zones with real-time combat**

Maps are designed for exploration, making learning **contextual and memorable**.

---

## 📚 Cybersecurity Topics Covered

- **Ethical Hacking & Reconnaissance**  
- **Linux Command Line Fundamentals**  
- **Network Scanning & Exploitation**  
- **Web Application Security Basics**
