# Smart football table

![logo](https://github.com/pfichtner/smart-football-table/blob/master/docs/logo/SFT_Logo_Color_small.png)

## Shortcut: --> [Thoughts on camera](https://github.com/pfichtner/smart-football-table/blob/master/docs/calculations/situation_fov_fps_camera.md)

## Shortcut: --> Architecture

![arc](https://github.com/pfichtner/smart-football-table/blob/master/docs/architecture/SmartFootballTable_Architecture.png)

## Shortcut: --> Football Table values

![werte](https://github.com/pfichtner/smart-football-table/blob/master/docs/calculations/kicker_werte.jpg)

### Build and run
Clone this repository using --recursive switch (```git clone --recursive https://github.com/pfichtner/smart-football-table.git```) then update all submodules to their latest commit using ```git submodule update --recursive```

### Ideas to implement

###### general

* configuration
  * Camera size/height and the resulting frame size
  * football table values
  * Buttons on table kicker for new game (reset and start) and end game (close and evaluate)
* own account
  * after a single registration, register with the NFC chip at the kicker (position-related)
  * create statistics (see above)
* LED
  * for possession of the ball in team colour
  * goal seems to happen?
* Replay of special events
* Livestream of Video
* Idle for UI (Diashow, Best Moments, etc)

###### related to player

* Wins/Loss
* Wins in combination with position
* average ball possession
* Goals in combination with position
* shot velocity
* prevented goals
* Wins in combination with other player
* Wins in combination with daytime
* [...]

###### related to game

* Result
* Ballpossession in combination with team
* Heatmap
* Metadata (which players, daytime)
* Ballpossession in combination with player
* Ballpossession in combination with soccer figure
* Goals who/where
* average ball velocity
* prevented goals/site
* [...]

###### related football table

* which team wins more often
* average ball velocity
* Goals in combination with position
* when is played
* Metadata (price, size values, ...)

## MQTT messages
| topic                      | Description                                   | Example payload        |
| -------------------------- | --------------------------------------------- |----------------------- |
| leds/backgroundlight/color | Sets the background light, default is #000000 | #CC11DD                |
| game/score                 | The teams' scores                             | { "score": [ 0, 3 ] }  |
| game/foul                  | Some foul has happened                        | -                      |
| game/gameover              | A match ended                                 | { "winners": [ 0 ] }   |
| game/idle                  | Is there action on the table                  | { "idle": true }       |
| leds/foregroundlight/color | Foreground light overrules everything else if not #000000 | #111111    |

