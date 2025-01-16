# Orbits

An audiovisual installation that combines Processing visuals with SuperCollider sound synthesis, creating a harmonious experience through orbital motion and dynamic sound generation.

## Description

This project creates an engaging visual display of multiple dots moving in orbital patterns, each with their own revolution speed and radius. When dots cross the central axes, they trigger musical notes through OSC messages to SuperCollider, creating a synchronized audiovisual experience.

## Features

- Fullscreen orbital visualization in Processing
- Dynamic color-coded dots with unique revolution patterns
- Trail effects with fade-out animation
- Real-time OSC communication between Processing and SuperCollider
- Adaptive sine wave synthesis with reverb in SuperCollider
- Dynamic amplitude scaling based on active notes
- Visual feedback with glow effects when notes are triggered
- Harmonic frequency mapping for musical coherence

## Prerequisites

### Processing
- Processing 3 or higher
- oscP5 library
- netP5 library

### SuperCollider
- SuperCollider 3.x
- Basic SuperCollider IDE

## Installation

1. Install Processing from [processing.org](https://processing.org/download)
2. Install SuperCollider from [supercollider.github.io](https://supercollider.github.io/downloads)
3. In Processing, install the required libraries:
   - Sketch -> Import Library -> Add Library
   - Search for and install "oscP5"

4. Clone this repository:
```bash
git clone harmonic-orbits
```

## Setup and Usage

### SuperCollider Setup
1. Open SuperCollider
2. If your system runs at 48kHz sample rate, execute:
```supercollider
s.options.sampleRate = 48000;
```
3. Boot the server:
```supercollider
s.boot;
```
4. Copy and run the provided SuperCollider code for the synth definition and OSC receiver

### Processing Setup
1. Open the `.pde` file in Processing
2. Run the sketch
3. The visualization will start in fullscreen mode

## How It Works

### Visual Component (Processing)
- Multiple dots orbit around the center point
- Each dot has a unique radius and revolution speed
- When a dot crosses the x or y axis, it sends an OSC message
- Visual feedback includes trails and glow effects

### Audio Component (SuperCollider)
- Receives OSC messages from Processing
- Maps dot indices to frequencies in a harmonic series
- Generates sine waves with percussion envelopes
- Includes reverb for spatial effect
- Dynamically adjusts amplitude based on active notes

## OSC Communication

- **Processing Port**: 12000 (incoming), 57120 (outgoing)
- **Message Format**: `/triggerNote [noteIndex]`
- **Note Index Range**: 0-24
- **Frequency Range**: 65.41 Hz - 1760.00 Hz (harmonically mapped)

## Customization

### Visual Parameters (Processing)
- `numDots`: Number of orbital dots
- `dotDiameter`: Size of each dot
- `trail.size()`: Length of trailing effect

### Audio Parameters (SuperCollider)
- Attack and release times in the envelope
- Reverb mix, room size, and damping
- Base amplitude and scaling factors
- Frequency mapping array

## Troubleshooting

1. If no sound:
   - Ensure SuperCollider server is booted
   - Check that OSC ports match between Processing and SuperCollider
   - Verify your system's audio output settings

2. If visual issues:
   - Adjust `maxRadius` in Processing for different screen sizes
   - Modify `numDots` for performance optimization

## Contributing

Feel free to submit issues and enhancement requests!

## Acknowledgments

- Processing Foundation
- SuperCollider community
- oscP5 library developer
