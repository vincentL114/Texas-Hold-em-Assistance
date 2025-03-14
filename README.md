# Texas-Hold-em-Assistance

Texas Hold'em Assistance is an iOS application designed to help poker players improve their strategic decision-making during gameplay. The app offers a suite of tools for calculating hand probabilities, learning hand rankings, and tracking game performance.

## Overview

The app is organized into three main sections, accessible via a tab bar:

- **Calculator:**  
  Select your starting hand and community cards, then calculate the probability of winning a hand. *(Note: The "Show Probabilities" feature currently uses a dummy simulation function that returns sample hand probabilities. In production, this function will call an API for real-time calculations.)*

- **Hand Guide:**  
  Provides a quick reference for poker hand rankings, helping you understand the strength of different hands.

- **Game Journal:**  
  Logs your games, tracking chip wins, losses, and net outcomes. Dive into detailed records to analyze your performance over time.

## Features

- **Interactive Calculator:**  
  Drag and drop cards to create your starting hand and community cards, then instantly compute hit probabilities.

- **Comprehensive Hand Guide:**  
  Browse detailed descriptions and visual representations of poker hand rankings.

- **Detailed Game Journal:**  
  Log every game you play, view overall statistics (participation rate, win rate, total wins/losses, net outcomes), and review individual game details.

- **Editing & Reordering:**  
  Easily add, edit, and reorder game records for efficient tracking of your performance.

## Dummy Simulation for Probabilities

The current implementation of the "Show Probabilities" feature is a dummy simulation. In the production version, the app would call an API to calculate the probabilities.
