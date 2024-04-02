# Connectivity Cases

Definitions:

- **Per channel**: resistor from channel output to ground (kOhm)
- **Join res**: resistors joining from ch. output to a net common to all channels (kOhm)
- **Lump res**: resistor from the common net to ground (kOhm)
- **ac**: ac coupling capacitor, in uF

Game                    | Chip Model      | Per ch. | Join R. | Lump  | ac  | Remarks
------------------------|-----------------|---------|---------|-------|-----|----------
Ghosts'n Goblins        | YM2203          |  1      |   4.7   | 2     | 10  |
Robocop                 | YM2203          |  10     |  56     | 1     | 10  |
Combat School           | YM2203          |         | 3.2     | 1     |  4.7| one ac cap for all channels
Bubble Bobble           | YM2203          |         | shorted | 1     | 10  | single cap for all chips
The New Zealand Story   | YM2203          |         | shorted | 1     | 0.1 | Applies to other boards of the same series (JTKIWI core)
1942                    | AY-3-8910       | 10      | 220     | 2     | 10  |
Karate Champ            | AY-3-8910       |  1      |         | 1     |  1  | ch. C of chip 1A
Karate Champ            | AY-3-8910       |         | shorted | 1     |  1  | ch. B/C of chip 1A, all of chip 3A (5 ch.)
Roc'n Rope              | AY-3-8910       | 6.1     |         |       |  1  | all ch. connected to a virtual ground

Bubble Bobble is misconnected. Due to YM2203's buffered output, shorting all channels will make the higher output voltage dominate at any time.