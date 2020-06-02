# Vortrag Notizen

### Projektübersicht

* Smart Football Table --> Ballerkennung mit Kamera mit anschließender Auswertung und Live Eventhandling
* Team: Peter Fichtner, Tobias Bechtold, Marco Mueller
* Was hat das Projekt mit Banking zu tun? --> das Projekt ist erstmal vom Bankingkontext gelöst, da als Privatprojekt begonnen.
* Es gab Vorgaben/Einschränkungen:
  * Kicker nicht modifizieren, Kickerunabhängig
  * Kosten niedrig halten
  * Soll auch durch Privatanwender nachgebaut werden können, die weniger IT-Wissen haben
  * Das Projekt ist OpenSource und transparent

### Zeitlicher Verlauf des Projekts

* Architekturbild über Zeit aufzeigen: aktuell --> älteste --> aufsteigend
* ebenfalls: Begriffswolke mit den zum Zeitpunkt vorhandenen Technologien

* gegeben: aktueller Kicker ist der Vector3 von Kickerklaus

* Zwischenstand 1:
  * Ballerkennung mit Python & OpenCV, nur Videobild mit Ball

* Zwischenstand 2:
  * selbstgeschraubtes Gestell aus Holz, Überlegungen über zwei Kameras (Software war zeitweise auf zwei Kameras ausgerichtet, auch wenn dadurch natürlich höhere Kosten für Nachbauer entstehen)
  * langsam entsteht Java-Code, der Berechnungen ausführt. Allerdings speichert Python die Ballpositionen noch asynchron in eine Textdatei, die dann auf der anderen Seite eingelesen wird

* Zwischenstand 3:
  * die Überlegungen, Gestell und LEDs zu kaufen wurden umgesetzt. Gestell ist allerdings nicht für gegebene Kamera geeinget, deshalb die Entscheidung, nach neuer Kamera zu suchen
  * Die Ballerkennung schreibt nun die Positionen auf die Konsole, die von der Berechnung in Java eingelesen wird
  * LED-Ansteuerung ist auf einem vorzeigbaren Stand

* Zwischenstand 4:
  * es muss eine Entscheidung getroffen werden, die viele unbekannte Faktoren enthält: Welche Kamera im Bezug auf die Möglichkeit, mit Machine Learning vorzugehen... oder doch lieber nochmal Zeit in klassiches OpenCV und Bildvorverarbeitung investieren?
  * die UI ist ansteuerbar, MQTT wird zur im Moment geeignetsten Technologie und ist noch Teil des Projektübersicht
  * der Ansatz mit Machine Learning ist erfolgreich und macht die Fisheye-Kamera zur besseren Wahl (keine zwei Kameras)
  * Halterungen für die Kamera werden gedruckt
  * Sound-Modul mit Reaktion auf Tore vorhanden

* Zwischenstand 5:
  * der vorhandene Java-Code wird auf der Messe noch weiter verhunzt und muss refactored werden. Dies gelingt ohne Eingriff in andere Module
  * der bisher manuelle Build-Ablauf wird nach und nach automatisierter

* aktueller Stand:
  * gekauftes Gestell, in das ein steuerbarer LED-Streifen geklebt wurde
  * selbstgedruckte (in der Fiducia&GAD) Halterung für Kamera, die an das Gestell befestigt werden erkannt
  * Fisheye-Kamera, die den ganzen Kickerspielbereich erfassen kann
  * Microcontroller zur Ansteuerung des LED-Streifen
  * ein PC mit Grafikkarte zur Ausführung der Software
  * Soundausgabe
  * ein weitestgehend automatisierter Buildprozess auf Basis von Docker und Skripten


### SFT-Softwaremodule im Detail

##### Ballerkennung
* zwei Aufgaben, Ballsuche im Videobild und das Videobild an Sich
* Ballerkennung im Videobild
  * zuerst klassischer Ansatz mit OpenCV und Python:
    * Vorverarbeitung des Kamerabildes: HSV-Farbraum, Farbfilter, Erodieren und Dilatieren
    * Konturen finden, die kreisförmig sind
    * größte Kontur verwenden, Position bestimmen und per MQTT-Message senden
    * Probleme:
      * sehr lichtabhängig, da Farben sich ändern, auch auf einem Kickertisch ist Licht nicht überall gleich
      * schnelle Bälle sind bei schlechter Kamera keine Kreise mehr
      * Stangen und Spieler verdecken den Ball
      * --> nur bei voriger aufwändiger Konfiguration auf die Situation eine wirklich gut funktionierende Lösung
  * zweiter Ansatz: künstliche Intelligenz
    * Technologie der Wahl: YOLOv3, OpenSource verfügbar in Kombination mit OpenCV
    * Modell muss erst trainiert werden: mehrere tausend Bilder der zu erkennenden Objektklasse werden benötigt
    * Testvideos aufgenommen, mithilfe von einem Skript in Bilder mit und ohne Bälle daraus gewonnen
    * von Hand jedes einzelne Bild mit Ball labeln, also einen Kasten um den Ball ziehen, der beim Training die Position des Balles angibt
    * Training eines neuronalen Netzes mit verschiedenen Hyperparametern, beispielsweise wie viele Bilder parallel eingelesen werden sollen und inwiefern sie modifiziert werden sollen (Streckung, Spiegelung...)
    * bewusstes Overfitting verursacht (vllt Exkurs nötig), da wenig Varianz in der realen Situation erwartet werden kann
    * Probleme:
      * das Modell kennt nicht die echte Realität, sondern eine verzerrte, die sich anhand der Lerndaten ergibt
      * --> auf einigen Bildern waren Finger zu sehen, und da es zu wenig Gegenbeispiele gab, nahm das Modell an, Finger gehören auch zum Ball. Einzelne Finger werden als Ball erkannt
      * --> auf vielen Bildern ist der Ball mit Stangen/weißen Spielern zu sehen, auch hier vom Modell die Annahme, weiße Spieler in bestimmter Position sind Bälle. Es mussten schwarze Kappen auf die weißen Spieler geklebt werden.
      * YOLOv3 ist keine Lösung, um Obejekte 100% der Zeit perfekt zu erkennen. Eigentlich liegt die Stärke und auch der Fokus von YOLO im Klassifizieren von vielen Objekten zu einem ausreichenden Maß über Zeit hinweg.
    * im Großen und Ganzen aber ist der KI-Ansatz unabhängiger einsetzbar
* Das Videobild
  * zeigt den erkannten Ball mit Kasten an, sowie eine Spur des Balles
##### Weitere Berechnungen mit Ballpositionen
* Aufgabe ist, die gegebenen Ballpositionen mit weiteren Berechnungen auszuwerten, unter anderem:
  * Torerkennung
  * Ballgeschwindigkeit
* programmiert in Java
* hier wäre ein guter Ort für den Einschub State Machine und Testing (PBT)
##### UI
* zeigt die Berechnungen an, Angular
* Responsive Design
* Heatmap, die den Ball und seine historischen Positionen als Verteilung anzeigt
##### LED
* ein LED-Streifen, der über eine Mikrocontroller angesteuert wird. Kommunikation von PC zu Mikrokontroller erfolgt mit Java via serieller Schnittstelle (TPM2 Protokoll, damit keine fachliche Logik auf dem Mikrokontroller). 
* Tor fällt: die LED leuchten in der Farbe des Teams auf, das getroffen hat, und erhöhen den permanent angezeigten Spielstand um 1 (symbolisiert durch 5 LEDS)
* ein Foul tritt auf (x Sekunden ohne horizontale Ballpositionsveränderung): die LED blinken schnell in weißem Licht
* die LED können auch manuell angesteuert werden, Foregrundlight, welches alles angezeigte überdeckt, oder Backgroundlight, welches eigentlich ausgeschaltete LEDs leuchten lässt
* die LEDs lassen sich einzeln ansteuern: soll LED 10 angesteuert werden, zählt jede LED den empfangenen Wert hoch und gibt diesen an den nächsten Nachbarn weiter, bis der Wert erreicht wird. Diese LED leuchtet dann.
##### Sound
* simpel gehaltenes Script, dass je nach empfangener MQTT-Message einen zum Event passenden, zufälligen Sound ausgibt
##### MQTT
* das Bindestück der einzelnen Module. Durch Topics, auf die gepublished und subscribed werden kann können Module Nachrichten austauschen.
* Beispiele:
  * Das Erkennungsmodul schreibt die Ballpositionen in einer vereinbarten Form auf das Topic ball/positions. Die Berechnung sowie die UI lauschen und reagieren, wenn eine Nachricht eintrifft.
  * Das Berechnungsmodul prüft, ob ein Tor gefallen ist, und publiziert dies im Falle eines Tors. Das LED-Modul, Sound-Modul und UI-Modul reagieren auf diese Nachricht.
* Vorteil ist das einfache anhängen neuer Module, die nur auf die vereinbarten Topics subscriben müssen, um lauffähig zu werden

### Erklärung Technologieentscheidungen

* Frage: Warum dieser Technologiezoo (nochmal auflisten)? Warum nicht einfach eine Sprache, bsp. Java?
* --> valide Option, unsere Wahl jedoch: die Sprache wählen, die am besten passt (Welches Werkzeug passt zu meinem Problem bzw. zu meinem Team und dessen Fähigkeiten?)
* Beispiel: CUDA. Trotz wenigen Kompetenzen im Team die aus unserer Sicht geeigneste Lösung für das Machine Learning Problem und das Trainiern auf Grafikkarten. Denn: Hardware war Nvidia, YOLOV3 unterstützt CUDA und der reine OpenCV-Ansatz erfüllte nicht unsere Qualitätsansprüche an die Erkennung

### Erklärung Architekturentscheidungen

* Module sollen unabhängig voneinander entwickelt werden können, ebenso unabhängig voneinander auch refactored werden
* Entkopplung: um unabhängig voneinander zu arbeiten bedarf es nicht zwangsweise Microservices. Unabhängig arbeiten war eine Grundlage für die Architekturentscheidungen
* Quereffekt in hoher Zahl wie beispielsweise das Wegbrechen von Modulen sollten selten auftreten können oder wichtiger, keinen Komplettausfall nach sich ziehen
* aber: Single Point of Failure ist der Broker. Bricht MQTT weg, ist die Kommunikation gestört und alles unbrauchbar. Dafür ist im Falle eines Komplettausfalls der erste logische Ort zum nachschauen der Broker.
* Quick Win von MQTT: Handysteuerung
* Schwierigkeit: was ist mit den vereinbarten Contracts? MQTT-Topics können nicht einfach ausgetauscht werden, ohne nicht alle zu benachrichtigen, die Zuhören. Aber: Woher weiß ich überhaupt, wer alles auf das Topic lauscht?
* --> Kommunikation wird entgegen üblicher Annahmen noch viel wichtiger, wenn so wie hier entkoppelt wird


### Agiles Arbeiten im Projektübersicht

* Spezialisierung statt Cross-Funktional, MQTT als Brücke.
* Einheitliche Basis um sinnvolle Zusammenarbeit zu ermöglichen:
  * git workflow
  * OpenSource Mindset
  * Test-driven-Development
  * Beherrschen des Github ecosystems
  * CI/CD
  * kein voreingenommenes Schubladendenken wenn es um agile Methoden geht, sondern der Situation entsprechend das Framework wählen
  * Entscheidungen gemeinsam treffen, über die möglichen Optionen nachdenken, aber Entscheidungen aufschieben, wenn nicht jetzt entscheidbar
  * regelmäßig zusammenfinden um die weiterentwickelten Module im Gesamten zu testen, dies zukünftig auch automatisieren
  * auch mit Hinblick auf Deadline-Situation COM19: Prioritäten klar setzen und Notwendiges vor Extravagantem erledigen, dann auch über Spezialisierungen/Eigentliche Aufgaben hinweg
  * Ideen von außen zulassen und das Backlog pflegen
* Dadurch gelang unter anderem folgendes:
  * trotz langer isolierter Entwicklung war Integration im ersten Versuch möglich und erfolgreich, dank gleichem OSS-Denken/Mindset/Arbeitsweise&Tests
  * eine Woche vor Deadline COM19 Entscheidung, mit Machine Learning den Ball zu suchen. Das Team einigt sich auf die Priorität dieser Aufgabe und arbeitet gemeinsam nur daran
  * bewusste Produktion von schlechtem Code, da auf der COM19 Lauffähigkeit wichtiger war als Design, geknüpft an das Wissen, danach erst einmal aufräumen zu müssen (also keine neuen Funktionen)
  * Refactoring des kompletten Berechnungs-Moduls, ohne dass andere Module etwas davon mitbekommen müssen

### Lessons Learned & Nächste Schritte

* Fazit
  * Zurück zu: Was hat das mit Banking zu tun? --> IoT kann auch für Banken ein wichtiges Thema sein, beispielsweise Gesichtserkennung von Kunden.
  * --> Themen nicht zu früh aufgrund fehlendem Geschäftsbezug ausfiltern, sondern Experimente auch zulassen
* Nächste Schritte:
  * Modell der Ballerkennung auf Spieler ausweiten, sodass noch ansprechendere Mehrwerte gewonnen werden können
  * Letzte Schritte zur Automatisierung gehen, außerdem die Kamera/Ballerkennung konfigurbarer machen
