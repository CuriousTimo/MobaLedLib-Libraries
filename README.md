# MobaLedLib Libraries

All Arduino libraries that [MobaLedLib](https://github.com/Hardi-St/MobaLedLib) needs, in the versions that
work together, in one place. They are the versions of the Excel Program Generator 3.5.0 (its `Libraries`
sheet), so a program built with [MobaLedLib Studio](https://github.com/CuriousTimo/MobaLedLib-Studio) or with
the Excel tool compiles the same way.

Download them from the [latest release](../../releases/latest).

## What is in it

| Library | Version | Needed for | Source |
|---|---|---|---|
| MobaLedLib | 3.5.0 | everything | Arduino library index |
| FastLED | 3.9.13 | everything | Arduino library index |
| NmraDcc | 2.0.10 | DCC | Arduino library index |
| AnalogScanner | master (2019-05-23) | analog inputs | github.com/merose/AnalogScanner |
| ATtinySerialOut | 2.2.0 | ATtiny boards | Arduino library index |
| DIO2 | 1.6.0 | fast inputs/outputs | Arduino library index |
| EWMA | 1.0.2 | Charlieplexing | Arduino library index |
| MobaTools | 2.6.1 | servos | Arduino library index |
| LocoNet | 1.1.13 | LocoNet (Nano) | Arduino library index |
| TimerOne | 1.1.0 | timer | Arduino library index |
| WiFiManager | 2.0.17 | ESP32 Wi-Fi | Arduino library index |
| U8g2 | 2.34.22 | ESP32 display | Arduino library index |
| EspSoftwareSerial | 6.15.2 | ESP32 serial | github.com/Jueff/espsoftwareserial |
| LocoNet2 | 2.2.3 | LocoNet (ESP32) | github.com/Jueff/LocoNet2 |

Two differences from the Excel sheet:

- **FastLED**: the Excel tool installs a snapshot of a private fork (Jueff/FastLED, called "3.9.12"). Its
  ESP32 fix is part of the official FastLED since 3.9.13, so this bundle has the official 3.9.13. The Excel
  tool checks for exactly 3.9.12 and may offer to replace it.
- **TimerOne**: the sheet says 1.1; the library index has 1.1.0.

EspSoftwareSerial is the official 6.15.2 plus one fix by Jürgen Winkler (no crash on an ESP32 when the serial
port only sends). LocoNet2 is the tag `master` of Jueff/LocoNet2, which is release 2.2.3.

## Install

First remove older copies of these libraries from the `libraries` folder of your sketchbook, otherwise the
Arduino IDE may pick the wrong one ("Multiple libraries were found").

Where the sketchbook is:

- Windows: `Documents\Arduino`
- macOS: `Documents/Arduino` in your home folder
- Linux: `Arduino` in your home folder

### All at once (recommended)

1. Download `MobaLedLib-Libraries-<version>.zip` from the release.
2. Unpack it.
3. Copy the folders inside its `libraries` folder into the `libraries` folder of your sketchbook.
4. Restart the Arduino IDE.

### One library at a time

1. Download the library's zip from the release, for example `FastLED-3.9.13.zip`.
2. In the Arduino IDE choose **Sketch › Include Library › Add .ZIP Library…** and pick the zip.

### With arduino-cli

```sh
arduino-cli config set library.enable_unsafe_install true
arduino-cli lib install --zip-path FastLED-3.9.13.zip
```

Repeat the second line for each zip, or unpack the bundle into the sketchbook as above.

## Boards

The boards are not in this bundle; install them with the Boards Manager of the Arduino IDE
(**Tools › Board › Boards Manager…**) in these versions. For the ones with a URL, first add the URL under
**File › Preferences › Additional boards manager URLs**.

| Board package | Version | For | Boards manager URL |
|---|---|---|---|
| Arduino AVR Boards (`arduino:avr`) | 1.8.6 | Nano, Uno, … | — |
| ATTinyCore (`ATTinyCore:avr`) | 1.5.2 | ATtiny (servo, Charlieplexing) | `https://raw.githubusercontent.com/Hardi-St/MobaLedLib_Docu/refs/heads/master/Tools/ATTinyCore/ATTinyCore_index.json` |
| ESP32 (`esp32:esp32`) | 1.0.4 | ESP32 | `https://dl.espressif.com/dl/package_esp32_index.json` |
| Raspberry Pi Pico (`rp2040:rp2040`) | 4.4.0 | Pico (experimental) | `https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json` |

With arduino-cli, for example: `arduino-cli core install arduino:avr@1.8.6`.

## Licences

Every library keeps its own licence; it is inside its folder. TimerOne has none as a file: its licence
(Creative Commons Attribution 3.0 United States) is in the header of `TimerOne.h`.

## Testing

The workflow `.github/workflows/compile.yml` builds the bundle and compiles MobaLedLib sketches with it on the
board packages above: `LEDs_AutoProg` for Nano, ESP32 and Pico, the DCC, Selectrix and LocoNet interface
sketches for the Nano, and the ATtiny85 servo and Charlieplexing modules. `LEDs_AutoProg` needs a
`LEDs_AutoProg.h`; the ones in `test/` are made by MobaLedLib Studio from its example layout.

## Making a release

`libraries.txt` lists every library with its version, source and SHA-256 checksum (or git commit).
`./build.sh <tag>` downloads them, checks the checksums and writes the zips and `SHA256SUMS` into `dist/`.
