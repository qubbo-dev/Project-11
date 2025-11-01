# NotesApp

Jednoduchá aplikácia pre iPhone vytvorená v SwiftUI na zapisovanie poznámok. Obsahuje zoznam poznámok, vyhľadávanie, triedenie a editor s možnosťou pridávať, upravovať a mazať poznámky. Dáta sa ukladajú lokálne v JSON súbore v priečinku dokumentov.

## Spustenie v Xcode
1. Otvor priečinok `NotesApp` v Xcode (File \> Open).
2. Vyber schému **NotesApp** a cieľ **iOS Simulator**.
3. Spusť projekt (`Cmd + R`).

## Funkcie
- vytváranie, úprava a mazanie poznámok
- vyhľadávanie podľa názvu aj obsahu
- triedenie poznámok podľa dátumu úpravy, vytvorenia alebo abecedy
- ukladanie poznámok do súboru `notes.json`

## Štruktúra
- `Models` – dátový model poznámky
- `ViewModels` – logika práce s poznámkami
- `Views` – používateľské rozhranie v SwiftUI
- `Persistence` – ukladanie poznámok
