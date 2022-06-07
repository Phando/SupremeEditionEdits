function toCamelot(key) {
  if (key == "") return "";

  switch (key) {
    //OpenKey
    case "1d" : return "8B"
    case "2d" : return "9B"
    case "3d" : return "10B"
    case "4d" : return "11B"
    case "5d" : return "12B"
    case "6d" : return "1B"
    case "7d" : return "2B"
    case "8d" : return "3B"
    case "9d" : return "4B"
    case "10d" : return "5B"
    case "11d" : return "6B"
    case "12d" : return "7B";

    case "~ 1d" : return "~8B"
    case "~ 2d" : return "~9B"
    case "~ 3d" : return "~10B"
    case "~ 4d" : return "~11B"
    case "~ 5d" : return "~12B"
    case "~ 6d" : return "~1B"
    case "~ 7d" : return "~2B"
    case "~ 8d" : return "~3B"
    case "~ 9d" : return "~4B"
    case "~ 10d" : return "~5B"
    case "~ 11d" : return "~6B"
    case "~ 12d" : return "~7B"

    case "1m" : return "8A"
    case "2m" : return "9A"
    case "3m" : return "10A"
    case "4m" : return "11A"
    case "5m" : return "12A"
    case "6m" : return "1A"
    case "7m" : return "2A"
    case "8m" : return "3A"
    case "9m" : return "4A"
    case "10m" : return "5A"
    case "11m" : return "6A"
    case "12m" : return "7A"

    case "~ 1m" : return "~8A"
    case "~ 2m" : return "~9A"
    case "~ 3m" : return "~10A"
    case "~ 4m" : return "~11A"
    case "~ 5m" : return "~12A"
    case "~ 6m" : return "~1A"
    case "~ 7m" : return "~2A"
    case "~ 8m" : return "~3A"
    case "~ 9m" : return "~4A"
    case "~ 10m" : return "~5A"
    case "~ 11m" : return "~6A"
    case "~ 12m" : return "~7A"

    //Musical Key
    case "C" : return "8B"
    case "G" : return "9B"
    case "D" : return "10B"
    case "A" : return "11B"
    case "E" : return "12B"
    case "B" : return "1B"
    case "Gb" : return "2B"
    case "Db" : return "3B"
    case "Ab" : return "4B"
    case "Eb" : return "5B"
    case "Bb" : return "6B"
    case "F" : return "7B";

    case "~ C" : return "~8B"
    case "~ G" : return "~9B"
    case "~ D" : return "~10B"
    case "~ A" : return "~11B"
    case "~ E" : return "~12B"
    case "~ B" : return "~1B"
    case "~ Gb" : return "~2B"
    case "~ Db" : return "~3B"
    case "~ Ab" : return "~4B"
    case "~ Eb" : return "~5B"
    case "~ Bb" : return "~6B"
    case "~ F" : return "~7B";

    case "Am" : return "8A"
    case "Em" : return "9A"
    case "Bm" : return "10A"
    case "Gbm" : return "11A"
    case "Dbm" : return "12A"
    case "Abm" : return "1A"
    case "Ebm" : return "2A"
    case "Bbm" : return "3A"
    case "Fm" : return "4A"
    case "Cm" : return "5A"
    case "Gm" : return "6A"
    case "Dm" : return "7A"

    case "~ Am" : return "~8A"
    case "~ Em" : return "~9A"
    case "~ Bm" : return "~10A"
    case "~ Gbm" : return "~11A"
    case "~ Dbm" : return "~12A"
    case "~ Abm" : return "~1A"
    case "~ Ebm" : return "~2A"
    case "~ Bbm" : return "~3A"
    case "~ Fm" : return "~4A"
    case "~ Cm" : return "~5A"
    case "~ Gm" : return "~6A"
    case "~ Dm" : return "~7A"

    //Musical Key Sharp
    case "C" : return "8B"
    case "G" : return "9B"
    case "D" : return "10B"
    case "A" : return "11B"
    case "E" : return "12B"
    case "B" : return "1B"
    case "F#" : return "2B"
    case "C#" : return "3B"
    case "G#" : return "4B"
    case "D#" : return "5B"
    case "A#" : return "6B"
    case "F" : return "7B";

    case "~ C" : return "~8B"
    case "~ G" : return "~9B"
    case "~ D" : return "~10B"
    case "~ A" : return "~11B"
    case "~ E" : return "~12B"
    case "~ B" : return "~1B"
    case "~ F#" : return "~2B"
    case "~ C#" : return "~3B"
    case "~ G#" : return "~4B"
    case "~ D#" : return "~5B"
    case "~ A#" : return "~6B"
    case "~ F" : return "~7B";

    case "Am" : return "8A"
    case "Em" : return "9A"
    case "Bm" : return "10A"
    case "F#m" : return "11A"
    case "C#m" : return "12A"
    case "G#m" : return "1A"
    case "D#m" : return "2A"
    case "A#m" : return "3A"
    case "Fm" : return "4A"
    case "Cm" : return "5A"
    case "Gm" : return "6A"
    case "Dm" : return "7A";

    case "~ Am" : return "~8A"
    case "~ Em" : return "~9A"
    case "~ Bm" : return "~10A"
    case "~ F#m" : return "~11A"
    case "~ C#m" : return "~12A"
    case "~ G#m" : return "~1A"
    case "~ D#m" : return "~2A"
    case "~ A#m" : return "~3A"
    case "~ Fm" : return "~4A"
    case "~ Cm" : return "~5A"
    case "~ Gm" : return "~6A"
    case "~ Dm" : return "~7A"

    //Camelot Key
    case "8B" : return "8B"
    case "9B" : return "9B"
    case "10B" : return "10B"
    case "11B" : return "11B"
    case "12B" : return "12B"
    case "1B" : return "1B"
    case "2B" : return "2B"
    case "3B" : return "3B"
    case "4B" : return "4B"
    case "5B" : return "5B"
    case "6B" : return "6B"
    case "7B" : return "7B"

    case "~ 8B" : return "8B"
    case "~ 9B" : return "9B"
    case "~ 10B" : return "10B"
    case "~ 11B" : return "11B"
    case "~ 12B" : return "12B"
    case "~ 1B" : return "1B"
    case "~ 2B" : return "2B"
    case "~ 3B" : return "3B"
    case "~ 4B" : return "4B"
    case "~ 5B" : return "5B"
    case "~ 6B" : return "6B"
    case "~ 7B" : return "7B"

    case "8A" : return "8A"
    case "9A" : return "9A"
    case "10A" : return "10A"
    case "11A" : return "11A"
    case "12A" : return "12A"
    case "1A" : return "1A"
    case "2A" : return "2A"
    case "3A" : return "3A"
    case "4A" : return "4A"
    case "5A" : return "5A"
    case "6A" : return "6A"
    case "7A" : return "7A"

    case "~ 8A" : return "8A"
    case "~ 9A" : return "9A"
    case "~ 10A" : return "10A"
    case "~ 11A" : return "11A"
    case "~ 12A" : return "12A"
    case "~ 1A" : return "1A"
    case "~ 2A" : return "2A"
    case "~ 3A" : return "3A"
    case "~ 4A" : return "4A"
    case "~ 5A" : return "5A"
    case "~ 6A" : return "6A"
    case "~ 7A" : return "7A"

    //Camelot Key wih 0
    case "08B" : return "8B"
    case "09B" : return "9B"
    case "10B" : return "10B"
    case "11B" : return "11B"
    case "12B" : return "12B"
    case "01B" : return "1B"
    case "02B" : return "2B"
    case "03B" : return "3B"
    case "04B" : return "4B"
    case "05B" : return "5B"
    case "06B" : return "6B"
    case "07B" : return "7B";

    case "08A" : return "8A"
    case "09A" : return "9A"
    case "10A" : return "10A"
    case "11A" : return "11A"
    case "12A" : return "12A"
    case "01A" : return "1A"
    case "02A" : return "2A"
    case "03A" : return "3A"
    case "04A" : return "4A"
    case "05A" : return "5A"
    case "06A" : return "6A"
    case "07A" : return "7A";
  }
  return null;
}

function getIndex(key) {
  if (key == "") return "";

  switch (key) {
    //OpenKey
    case "1d" : return 8
    case "2d" : return 9
    case "3d" : return 10
    case "4d" : return 11
    case "5d" : return 12
    case "6d" : return 1
    case "7d" : return 2
    case "8d" : return 3
    case "9d" : return 4
    case "10d" : return 5
    case "11d" : return 6
    case "12d" : return 7;

    case "~ 1d" : return 8
    case "~ 2d" : return 9
    case "~ 3d" : return 10
    case "~ 4d" : return 11
    case "~ 5d" : return 12
    case "~ 6d" : return 1
    case "~ 7d" : return 2
    case "~ 8d" : return 3
    case "~ 9d" : return 4
    case "~ 10d" : return 5
    case "~ 11d" : return 6
    case "~ 12d" : return 7

    case "1m" : return 20
    case "2m" : return 21
    case "3m" : return 22
    case "4m" : return 23
    case "5m" : return 24
    case "6m" : return 13
    case "7m" : return 14
    case "8m" : return 15
    case "9m" : return 16
    case "10m" : return 17
    case "11m" : return 18
    case "12m" : return 19

    case "~ 1m" : return 20
    case "~ 2m" : return 21
    case "~ 3m" : return 22
    case "~ 4m" : return 23
    case "~ 5m" : return 24
    case "~ 6m" : return 13
    case "~ 7m" : return 14
    case "~ 8m" : return 15
    case "~ 9m" : return 16
    case "~ 10m" : return 17
    case "~ 11m" : return 18
    case "~ 12m" : return 19

    //Musical Key
    case "C" : return 8
    case "G" : return 9
    case "D" : return 10
    case "A" : return 11
    case "E" : return 12
    case "B" : return 1
    case "Gb" : return 2
    case "Db" : return 3
    case "Ab" : return 4
    case "Eb" : return 5
    case "Bb" : return 6
    case "F" : return 7

    case "~ C" : return 8
    case "~ G" : return 9
    case "~ D" : return 10
    case "~ A" : return 11
    case "~ E" : return 12
    case "~ B" : return 1
    case "~ Gb" : return 2
    case "~ Db" : return 3
    case "~ Ab" : return 4
    case "~ Eb" : return 5
    case "~ Bb" : return 6
    case "~ F" : return 7;

    case "Am" : return 20
    case "Em" : return 21
    case "Bm" : return 22
    case "Gbm" : return 23
    case "Dbm" : return 24
    case "Abm" : return 13
    case "Ebm" : return 14
    case "Bbm" : return 15
    case "Fm" : return 16
    case "Cm" : return 17
    case "Gm" : return 18
    case "Dm" : return 19

    case "~ Am" : return 20
    case "~ Em" : return 21
    case "~ Bm" : return 22
    case "~ Gbm" : return 23
    case "~ Dbm" : return 24
    case "~ Abm" : return 13
    case "~ Ebm" : return 14
    case "~ Bbm" : return 15
    case "~ Fm" : return 16
    case "~ Cm" : return 17
    case "~ Gm" : return 18
    case "~ Dm" : return 19

    //Musical Key Sharp
    case "C" : return 8
    case "G" : return 9
    case "D" : return 10
    case "A" : return 11
    case "E" : return 12
    case "B" : return 1
    case "F#" : return 2
    case "C#" : return 3
    case "G#" : return 4
    case "D#" : return 5
    case "A#" : return 6
    case "F" : return 7

    case "~ C" : return 8
    case "~ G" : return 9
    case "~ D" : return 10
    case "~ A" : return 11
    case "~ E" : return 12
    case "~ B" : return 1
    case "~ F#" : return 2
    case "~ C#" : return 3
    case "~ G#" : return 4
    case "~ D#" : return 5
    case "~ A#" : return 6
    case "~ F" : return 7

    case "Am" : return 20
    case "Em" : return 21
    case "Bm" : return 22
    case "F#m" : return 23
    case "C#m" : return 24
    case "G#m" : return 13
    case "D#m" : return 14
    case "A#m" : return 15
    case "Fm" : return 16
    case "Cm" : return 17
    case "Gm" : return 18
    case "Dm" : return 19

    case "~ Am" : return 20
    case "~ Em" : return 21
    case "~ Bm" : return 22
    case "~ F#m" : return 23
    case "~ C#m" : return 24
    case "~ G#m" : return 13
    case "~ D#m" : return 14
    case "~ A#m" : return 15
    case "~ Fm" : return 16
    case "~ Cm" : return 17
    case "~ Gm" : return 18
    case "~ Dm" : return 19

    //Camelot Key
    case "8B" : return 8
    case "9B" : return 9
    case "10B" : return 10
    case "11B" : return 11
    case "12B" : return 12
    case "1B" : return 1
    case "2B" : return 2
    case "3B" : return 3
    case "4B" : return 4
    case "5B" : return 5
    case "6B" : return 6
    case "7B" : return 7

    case "~ 8B" : return 8
    case "~ 9B" : return 9
    case "~ 10B" : return 10
    case "~ 11B" : return 11
    case "~ 12B" : return 12
    case "~ 1B" : return 1
    case "~ 2B" : return 2
    case "~ 3B" : return 3
    case "~ 4B" : return 4
    case "~ 5B" : return 5
    case "~ 6B" : return 6
    case "~ 7B" : return 7

    case "8A" : return 20
    case "9A" : return 21
    case "10A" : return 22
    case "11A" : return 23
    case "12A" : return 24
    case "1A" : return 13
    case "2A" : return 14
    case "3A" : return 15
    case "4A" : return 16
    case "5A" : return 17
    case "6A" : return 18
    case "7A" : return 19

    case "~ 8A" : return 20
    case "~ 9A" : return 21
    case "~ 10A" : return 22
    case "~ 11A" : return 23
    case "~ 12A" : return 24
    case "~ 1A" : return 13
    case "~ 2A" : return 14
    case "~ 3A" : return 15
    case "~ 4A" : return 16
    case "~ 5A" : return 17
    case "~ 6A" : return 18
    case "~ 7A" : return 19

    //Camelot Key wih 0
    case "08B" : return 8
    case "09B" : return 9
    case "10B" : return 10
    case "11B" : return 11
    case "12B" : return 12
    case "01B" : return 1
    case "02B" : return 2
    case "03B" : return 3
    case "04B" : return 4
    case "05B" : return 5
    case "06B" : return 6
    case "07B" : return 7;

    case "08A" : return 20
    case "09A" : return 21
    case "10A" : return 22
    case "11A" : return 23
    case "12A" : return 24
    case "01A" : return 13
    case "02A" : return 14
    case "03A" : return 15
    case "04A" : return 16
    case "05A" : return 17
    case "06A" : return 18
    case "07A" : return 19
  }
  return -1;
}

function getKeyId(key) {
  if (key == "") return "";

  switch (key) {
    //OpenKey
    case "1d" : return 0
    case "2d" : return 7
    case "3d" : return 2
    case "4d" : return 9
    case "5d" : return 4
    case "6d" : return 11
    case "7d" : return 6
    case "8d" : return 1
    case "9d" : return 8
    case "10d" : return 3
    case "11d" : return 10
    case "12d" : return 0

    case "~ 1d" : return 0
    case "~ 2d" : return 7
    case "~ 3d" : return 2
    case "~ 4d" : return 9
    case "~ 5d" : return 4
    case "~ 6d" : return 11
    case "~ 7d" : return 6
    case "~ 8d" : return 1
    case "~ 9d" : return 8
    case "~ 10d" : return 3
    case "~ 11d" : return 10
    case "~ 12d" : return 0

    case "1m" : return 21
    case "2m" : return 16
    case "3m" : return 23
    case "4m" : return 18
    case "5m" : return 13
    case "6m" : return 20
    case "7m" : return 15
    case "8m" : return 22
    case "9m" : return 17
    case "10m" : return 12
    case "11m" : return 19
    case "12m" : return 14

    case "~ 1m" : return 21
    case "~ 2m" : return 16
    case "~ 3m" : return 23
    case "~ 4m" : return 18
    case "~ 5m" : return 13
    case "~ 6m" : return 20
    case "~ 7m" : return 15
    case "~ 8m" : return 22
    case "~ 9m" : return 17
    case "~ 10m" : return 12
    case "~ 11m" : return 19
    case "~ 12m" : return 14

    //Musical Key
    case "C" : return 0
    case "G" : return 7
    case "D" : return 2
    case "A" : return 9
    case "E" : return 4
    case "B" : return 11
    case "Gb" : return 6
    case "Db" : return 1
    case "Ab" : return 8
    case "Eb" : return 3
    case "Bb" : return 10
    case "F" : return 0

    case "~ C" : return 0
    case "~ G" : return 7
    case "~ D" : return 2
    case "~ A" : return 9
    case "~ E" : return 4
    case "~ B" : return 11
    case "~ Gb" : return 6
    case "~ Db" : return 1
    case "~ Ab" : return 8
    case "~ Eb" : return 3
    case "~ Bb" : return 10
    case "~ F" : return 0

    case "Am" : return 21
    case "Em" : return 16
    case "Bm" : return 23
    case "Gbm" : return 18
    case "Dbm" : return 13
    case "Abm" : return 20
    case "Ebm" : return 15
    case "Bbm" : return 22
    case "Fm" : return 17
    case "Cm" : return 12
    case "Gm" : return 19
    case "Dm" : return 14

    case "~ Am" : return 21
    case "~ Em" : return 16
    case "~ Bm" : return 23
    case "~ Gbm" : return 18
    case "~ Dbm" : return 13
    case "~ Abm" : return 20
    case "~ Ebm" : return 15
    case "~ Bbm" : return 22
    case "~ Fm" : return 17
    case "~ Cm" : return 12
    case "~ Gm" : return 19
    case "~ Dm" : return 14

    //Musical Key Sharp
    case "C" : return 0
    case "G" : return 7
    case "D" : return 2
    case "A" : return 9
    case "E" : return 4
    case "B" : return 11
    case "F#" : return 6
    case "C#" : return 1
    case "G#" : return 8
    case "D#" : return 3
    case "A#" : return 10
    case "F" : return 0

    case "~ C" : return 0
    case "~ G" : return 7
    case "~ D" : return 2
    case "~ A" : return 9
    case "~ E" : return 4
    case "~ B" : return 11
    case "~ F#" : return 6
    case "~ C#" : return 1
    case "~ G#" : return 8
    case "~ D#" : return 3
    case "~ A#" : return 10
    case "~ F" : return 0

    case "Am" : return 20
    case "Em" : return 21
    case "Bm" : return 22
    case "F#m" : return 23
    case "C#m" : return 24
    case "G#m" : return 13
    case "D#m" : return 14
    case "A#m" : return 15
    case "Fm" : return 16
    case "Cm" : return 17
    case "Gm" : return 18
    case "Dm" : return 19

    case "~ Am" : return 20
    case "~ Em" : return 21
    case "~ Bm" : return 22
    case "~ F#m" : return 23
    case "~ C#m" : return 24
    case "~ G#m" : return 13
    case "~ D#m" : return 14
    case "~ A#m" : return 15
    case "~ Fm" : return 16
    case "~ Cm" : return 17
    case "~ Gm" : return 18
    case "~ Dm" : return 19

    //Camelot Key
    case "8B" : return 0
    case "9B" : return 7
    case "10B" : return 2
    case "11B" : return 9
    case "12B" : return 4
    case "1B" : return 11
    case "2B" : return 6
    case "3B" : return 1
    case "4B" : return 8
    case "5B" : return 3
    case "6B" : return 10
    case "7B" : return 0

    case "~ 8B" : return 0
    case "~ 9B" : return 7
    case "~ 10B" : return 2
    case "~ 11B" : return 9
    case "~ 12B" : return 4
    case "~ 1B" : return 11
    case "~ 2B" : return 6
    case "~ 3B" : return 1
    case "~ 4B" : return 8
    case "~ 5B" : return 3
    case "~ 6B" : return 10
    case "~ 7B" : return 0

    case "8A" : return 21
    case "9A" : return 16
    case "10A" : return 23
    case "11A" : return 18
    case "12A" : return 13
    case "1A" : return 20
    case "2A" : return 15
    case "3A" : return 22
    case "4A" : return 17
    case "5A" : return 12
    case "6A" : return 19
    case "7A" : return 14

    case "~ 8A" : return 21
    case "~ 9A" : return 16
    case "~ 10A" : return 23
    case "~ 11A" : return 18
    case "~ 12A" : return 13
    case "~ 1A" : return 20
    case "~ 2A" : return 15
    case "~ 3A" : return 22
    case "~ 4A" : return 17
    case "~ 5A" : return 12
    case "~ 6A" : return 19
    case "~ 7A" : return 14

    //Camelot Key wih 0
    case "08B" : return 0
    case "09B" : return 7
    case "10B" : return 2
    case "11B" : return 9
    case "12B" : return 4
    case "01B" : return 11
    case "02B" : return 6
    case "03B" : return 1
    case "04B" : return 8
    case "05B" : return 3
    case "06B" : return 10
    case "07B" : return 0

    case "~ 08B" : return 0
    case "~ 09B" : return 7
    case "~ 10B" : return 2
    case "~ 11B" : return 9
    case "~ 12B" : return 4
    case "~ 01B" : return 11
    case "~ 02B" : return 6
    case "~ 03B" : return 1
    case "~ 04B" : return 8
    case "~ 05B" : return 3
    case "~ 06B" : return 10
    case "~ 07B" : return 0

    case "08A" : return 21
    case "09A" : return 16
    case "10A" : return 23
    case "11A" : return 18
    case "12A" : return 13
    case "01A" : return 20
    case "02A" : return 15
    case "03A" : return 22
    case "04A" : return 17
    case "05A" : return 12
    case "06A" : return 19
    case "07A" : return 14

    case "~ 08A" : return 21
    case "~ 09A" : return 16
    case "~ 10A" : return 23
    case "~ 11A" : return 18
    case "~ 12A" : return 13
    case "~ 01A" : return 20
    case "~ 02A" : return 15
    case "~ 03A" : return 22
    case "~ 04A" : return 17
    case "~ 05A" : return 12
    case "~ 06A" : return 19
    case "~ 07A" : return 14
  }
  return -1;
}

function keyIdToIndex(id) {
  switch (id) {
    case 0 : return 8;
    case 7 : return 9;
    case 2 : return 10;
    case 9 : return 11;
    case 4 : return 12;
    case 11 : return 1;
    case 6 : return 2;
    case 1 : return 3;
    case 8 : return 4;
    case 3 : return 5;
    case 10 : return 6;
    case 5 : return 7;

    case 21 : return 20;
    case 16 : return 21;
    case 23 : return 22;
    case 18 : return 23;
    case 13 : return 24;
    case 20 : return 13;
    case 15 : return 14;
    case 22 : return 15;
    case 17 : return 16;
    case 12 : return 17;
    case 19 : return 18;
    case 14 : return 19;
  }
  return -1
}

function indexToKeyId(index) {
  switch(index){
    case 8 : return 0
    case 9 : return 7
    case 10 : return 2
    case 11 : return 9
    case 12 : return 4
    case 1 : return 11
    case 2 : return 6
    case 3 : return 1
    case 4 : return 8
    case 5 : return 3
    case 6 : return 10
    case 7 : return 5

    case 20 : return 21
    case 21 : return 16
    case 22 : return 23
    case 23 : return 18
    case 24 : return 13
    case 13 : return 20
    case 14 : return 15
    case 15 : return 22
    case 16 : return 17
    case 17 : return 12
    case 18 : return 19
    case 19 : return 14
  }
  return -1
}

function indexToCamelot(index) {
  switch(index){
    case 8 : return "8B"
    case 9 : return "9B"
    case 10 : return "10B"
    case 11 : return "11B"
    case 12 : return "12B"
    case 1 : return "1B"
    case 2 : return "2B"
    case 3 : return "3B"
    case 4 : return "4B"
    case 5 : return "5B"
    case 6 : return "6B"
    case 7 : return "7B"

    case 20 : return "8A"
    case 21 : return "9A"
    case 22 : return "10A"
    case 23 : return "11A"
    case 24 : return "12A"
    case 13 : return "1A"
    case 14 : return "2A"
    case 15 : return "3A"
    case 16 : return "4A"
    case 17 : return "5A"
    case 18 : return "6A"
    case 19 : return "7A"
  }
  return "ERR"
}

function keyIdToCamelot(id) {
  return indexToCamelot(keyIdToIndex(id));
}

function getKeyTextIndex(key, keyAdjust) {
  let index = getIndex(key)
  let keyAdjustRounded = Math.round(keyAdjust*12)
  let indexAdjusted = keyAdjust > 0 ? (index + (keyAdjustRounded*7))%12 : (index - keyAdjustRounded*5)%12
  if (index <= 12) {
      if (indexAdjusted == 0) indexAdjusted = 12
  }
  else {
      if (indexAdjusted == 0) indexAdjusted = 24
      else indexAdjusted = indexAdjusted + 12
  }
  return indexAdjusted
}

function getKeyTextId(key, keyAdjust) {
  return indexToKeyId(getKeyTextIndex(key, keyAdjust))
}


function getScale(key) {
    let index
    if (typeof(key) === "string") index = getIndex(key)
    else index = key
    switch(index) {
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
            return "Major"

        case 20:
        case 21:
        case 22:
        case 23:
        case 24:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
        case 18:
        case 19:
            return "Minor"
    }
}

function match(trackKey, masterKey) {
  var trackIndex = getIndex(trackKey)
  var trackScale = getScale(trackKey)

  var masterIndex = getIndex(masterKey)
  var masterScale = getScale(masterKey)

  if (!trackIndex || !masterIndex) return "ERR"

  else if (trackIndex == masterIndex) return 0 //Perfect Match (Same index, different scale)

  else if (trackScale == masterScale) {
    if (trackIndex > masterIndex) {
        if (((trackIndex - masterIndex) == 1) || ((trackIndex - masterIndex) == 11)) return 1 //Perfect Match (Index +-1, same scale)
        else if ((trackIndex - masterIndex) == 2) return 2 //Energy Jump (Index +2, same scale)
        else if ((trackIndex - masterIndex) == 10) return -2 //Energy Jump (Index -2, same scale)
        else if ((trackIndex - masterIndex) == 5) return 5 //Armin Style jump (Index +5, same scale)
        else if ((trackIndex - masterIndex) == 7) return -5 //Armin Style jump (Index -5, same scale)
        else if ((trackIndex - masterIndex) == 6) return 6 //Opposite side of the wheel jump (Index +-6, same scale)
        else return "No Match"
    }
    else {
        if (((trackIndex - masterIndex) == -1) || ((trackIndex - masterIndex) == -11)) return 1 //Perfect Match (Index +-1, same scale)
        else if ((trackIndex - masterIndex) == -10) return 2 //Energy Jump (Index +2, same scale)
        else if ((trackIndex - masterIndex) == -2) return -2 //Energy Jump (Index -2, same scale)
        else if ((trackIndex - masterIndex) == -7) return 5 //Armin Style jump (Index +5, same scale)
        else if ((trackIndex - masterIndex) == -5) return -5 //Armin Style jump (Index -5, same scale)
        else if ((trackIndex - masterIndex) == -6) return 6 //Opposite side of the wheel jump (Index +-6, same scale)
        else return "No Match"
    }
  }
  else {
    if (trackIndex > masterIndex) {
        if (((trackIndex - masterIndex) == 1) || ((trackIndex - masterIndex) == 11)) return -1 //Perfect Match (Index +-1, opposite scale)
        return "No Match"
    }
    else {
        if (((trackIndex - masterIndex) == -1) || ((trackIndex - masterIndex) == -11)) return -1 //Perfect Match (Index +-1, opposite scale)
        return "No Match"
    }
  }
}
