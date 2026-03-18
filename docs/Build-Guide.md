# Build Guide: Technical Specifications

This document outlines the hardware integration for the Buzzing Hair installation.

## Hardware Components
* **Controller:** Bela Mini / Bela Board
* **Sensor:** Trill Craft (30-channel capacitive touch)
* **Interface:** Conductive Yarn (woven into the vine structure)

## Wiring Diagram (I2C)
The Trill Craft is connected to the Bela board using the following pinout:

| Bela Pin | Trill Craft Pin | Function |
| :--- | :--- | :--- |
| P9_01 | GND | Ground |
| P9_03 | VCC | 3.3V Power |
| P9_19 | SCL | I2C Clock |
| P9_20 | SDA | I2C Data |

## Sensor Configuration
* **Inputs:** The 30 pins on the Trill Craft are soldered to individual conductive yarn segments.
* **Sensing Mode:** The system uses capacitive sensing to detect the proximity and touch of visitors.
* **Sensitivity:** Calibration is handled within the SuperCollider code to account for the resistance of the conductive yarns.

## Software Dependencies
* **Bela Core:** Ensure the firmware is up to date to support the Trill library.
* **SuperCollider:** The project uses the `Trill` UGen to parse I2C data into control signals.
