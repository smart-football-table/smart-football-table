# Smart football table

![logo](https://github.com/smart-football-table/smart-football-table.github.io/blob/master/modules/smart-football-table/logo/SFT_Logo2_Blue_small.jpg)

# >Attention, draft below!<

--> [Website](https://smart-football-table.github.io/)

## Overview

TODO make it clickable and with more detail

1) Getting started
2) The actual solution
3) Why this project
4) Next steps

## Getting started

#### Requirements

###### Software
* Docker
* OpenCV
* for YOLO: CUDA & darknet (read more [here](https://github.com/KingMus/smart-football-table-detection/tree/master/yolov3))

###### Hardware
* Soccer Table (our table: Vector3)
* Camera (TODO describe which one and what to avoid...)
* Something to hold the camera over the table (TODO explain possible solutions and our thing)
* LED strip
* 3D-printed camera holding (TODO upload 3dmodels in this repo)
* GPU
* dont forget enough cable

TODO deliver a shopping list for different cases and/or our solution/recommendation for this

#### Build and run
Clone this repository using --recurse-submodules switch (```git clone --recurse-submodules https://github.com/smart-football-table/smart-football-table.git```. After cloning run ```git submodule foreach git checkout master``` once. For the periodic updates run ```git pull && git submodule foreach git pull origin master```. 

TODO use docker in detection or explain how to start this here

## The actual solution

#### Architecture
![arc](https://github.com/smart-football-table/smart-football-table.github.io/blob/master/modules/smart-football-table/architecture/SmartFootballTable_Architecture.png)

#### MQTT messages
| topic                      | Description                                               | Example payload             | Comment
| -------------------------- | --------------------------------------------------------- |---------------------------- | -------
| leds/backgroundlight/color | Sets the background light, default is #000000             | #CC11DD                     |
| ~~ball/position~~          | ~~The ball absolute position on the table, between 0 and 1  | { "x": 0.5, "y": 0.3333}~~ | **no more sent**
| ball/position/rel          | The ball's relative position on the table, between 0 and 1| 0.5,0.3333                  |
| ball/position/abs          | The ball's absolute position on the table, between 0 and \<table width/height\> | 42,106 |
| ~~ball/velocity~~          | ~~The balls average speed in the last half second, km/h~~ | ~~{ "velocity": 30 }~~      | **no more sent**
| ball/velocity/\<kmh\|mph\> | The balls average speed ~~in the last half second~~       | 30.1                        | Unit depends on table's unit (kilometers or miles per hour)
| ball/velocity/\<ms\|ip\>   | The balls average speed ~~in the last half second~~       | 5.2                         | Unit depends on table's unit (meters or inches per second)
| ball/distance/\<cm\|inch\>    | The ball's distance between last and current position  | 1.23                        | Unit depends on table's unit (centimeters or inches)
| distance/overall/\<cm\|inch\> | The ball's overall distance during the current match   | 123.45                      | Unit depends on table's unit (centimeters or inches)
| team/scored                | The id of the team that scored                            | 1                           |
| game/score                 | The teams' scores                                         | { "score": [ 0, 3 ] }       | deprecated
| team/score/\<teamid\>      | Score of team with teamid \<teamid\> (zero-based)         | 3                           | 
| game/foul                  | Some foul has happened                                    | -                           |
| game/start                 | A match starts                                            | -                           |
| game/gameover              | A match ended                                             | 0,1                         | On draw all teams are sent separated by comma therwise the winning team only
| game/idle                  | Is there action on the table                              | true                        |
| game/reset                 | Command to interrupt the running game and startover       |                             |
| leds/foregroundlight/color | Foreground light overrules everything else if not #000000 | #111111                     |

## Why this project?

TODO

## Ideas to implement

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
