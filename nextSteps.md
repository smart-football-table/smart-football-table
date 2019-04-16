* COM-Salat aufraümen
  * Refactoring und technische Schulden
  * Reimplementierung des Java-Codes
  * hinzufügen von möglicherweise fehlenden Integrationstests
* Hardwareanforderungen reduzieren
  * Ballerkennung verbessern um auf Auflösung verzichten zu können
    * YOLO-Ansatz: neues Modell trainieren
      * Videomaterial aufnehmen
      * Trainings-Bilder erzeugen
      * verschiedene NN und Parameter durchprobieren
    * OpenCV-Ansatz: Ball besser finden
      * Farbe bei jeder Erkennung neu kalibrieren
      * Vorverarbeitung des Kamerabildes mit Profi erstellen
* offene Issues
  * false-positive Fehler
  * Vermeide Spursprung nach Tor
  * falsche Torerkennung wenn Ball lange liegt
* neue Funktionen (keine Prio)
  * Tuniermodus
  * Videopersestierungsstrategie
  * mehr Soundfiles
  * Video im Browser
  * Höchstgeschwindigkeit merken
  * Parade erkennen
  * UI reagiert auf idle-Mode

--> OpenSource-Ready werden
