# Smart football table

![logo](https://github.com/smart-football-table/smart-football-table/blob/master/docs/logo/SFT_Logo_Color_small.png)

## Shortcut: --> [Thoughts on camera](https://github.com/smart-football-table/smart-football-table/blob/master/docs/calculations/situation_fov_fps_camera.md)

## Shortcut: --> Architecture

![arc](https://github.com/smart-football-table/smart-football-table/blob/master/docs/architecture/SmartFootballTable_Architecture.png)

## Shortcut: --> Football Table values

![werte](https://github.com/smart-football-table/smart-football-table/blob/master/docs/calculations/kicker_werte.jpg)

### Build and run
Clone this repository using --recurse-submodules switch (```git clone --recurse-submodules https://github.com/smart-football-table/smart-football-table.git```. After cloning run ```git submodule foreach git checkout master``` once. For the periodic updates run ```git pull && git submodule foreach git pull origin master```. 

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
| topic                      | Description                                             | Example payload             | Comment
| -------------------------- | ------------------------------------------------------- |---------------------------- | -------
| leds/backgroundlight/color | Sets the background light, default is #000000           | #CC11DD                     |
| ball/position              | The ball absolute position on the table, between 0 and 1| { "x": 0.5, "y": 0.3333}    |
| ball/velocity              | The balls average speed in the last half second, km/h   | { "velocity": 30 }          | deprecated
| ball/velocity/kmh          | The balls average speed in the last half second, km/h   | 30                          |
| team/scored                | The id of the team that scored                          | 1                           |
| game/score                 | The teams' scores                                       | { "score": [ 0, 3 ] }       | deprecated
| game/score/\<teamid\>      | Score of team with teamid \<teamid\> (zero-based)       | 3                           | 
| game/foul                  | Some foul has happened                                  | -                           |
| game/start                 | A match starts                                          | -                           |
| game/gameover              | A match ended                                           | { "winners": [ 0 ] }        |
| game/idle                  | Is there action on the table                            | true                        |
| game/reset                 | Command to interrupt the running game and startover     |                             |
| leds/foregroundlight/color | Foreground light overrules everything else if not #000000 | #111111                   |

