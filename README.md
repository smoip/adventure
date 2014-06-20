# adventure
=========

## About:
Adventure is a simple, text-based rpg which has served as my framework and testing ground while learning Ruby.

Players progress through a randomly generated dungeon in which they can encounter monsters, learn spells, collect useful items, etc.

Though it is hoped that the game itself is fun, the primary purpose has been to expand on my knowledge of Ruby and explore facets of OO programming general.


## Install:
Unzip all program files into the same directory.


## Usage:
$ ruby adventure.rb

## Dependencies:
Running the audio component (still under development) uses Open Sound Control and requires the osc-ruby and eventmachine gems. Audio also uses Max/MSP/Jitter for sound synthesis and requries [Max 5 Runtime or later](http://cycling74.com/downloads/older/).  Adventure may be run without sound.


## Issues:
I am still very much in the process of learning testing (both syntax and usage), so adventure_spec is not as functional or as useful as it could be.  Resolving testing issues is a high priority while I continue to work on this project.


## Future Features:
Planned later features include: two dimensional map support, a shop (or town) in which players can spend their accumulated gold, an algorithmically generated 8-bit soundtrack which can be flexibly realized using Super Collider or Max/MSP/Jitter, new room types including ‘secure chamber’ where players can safely rest and a ‘hoard’ which is defended by several monsters and contains a special treasure, and of course more monsters, booty, and character types.
