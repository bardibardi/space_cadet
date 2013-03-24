space\_cadet
================

## Summary

for space cadet augmented ActiveRecord::Base's, ruby ObjectSpace like object\_id's (called space\_id's) based on UUID's

## Description

space\_cadet is a simple hack, for any ActiveRecord supported database, which provides a uuids table of distributable identities of space cadets -- ActiveRecord::Base instances which use the SpaceCadetWrapper. Each space cadet has by reference a space\_id unique in the set of all local space cadets; a space cadet's id is derived from its uuid - UUID's are by design universally distributable.

## Usage

    require 'space_cadet'

    class ChessGame < ActiveRecord::Base
    
      after_create SpaceCadetWrapper.new
      before_destroy SpaceCadetWrapper.new # optional
      ...

    end # ChessGame

    class MySpaceCadet < ActiveRecord::Base
    
      after_create SpaceCadetWrapper.new
      before_destroy SpaceCadetWrapper.new # optional
      ...
    
    end # MySpaceCadet

ChessGame instances are space cadets.

After ActiveRecord creates a ChessGame space cadet, it uses SecureRandom.uuid to generate a UUID. The lowest 31 bits of the UUID are used to make a space\_id.

The uuids table gains a chess\_games row as in:

    id  source_id  source_name      space_id    ...uuid
     3         14  my_space_cadets   746042992  ...43e1ac77b670
     4         23  chess_games       569967860  ...35d4a1f904f4

    ...uuid          uuid
    ...43e1ac77b670  7770a54c-7f08-4817-877e-43e1ac77b670
    ...35d4a1f904f4  274ead56-7c8f-4c8d-ad21-35d4a1f904f4

The chess\_games table gains a row like:

    id  moves  ambiguities  move_number  ...
    23  e2e4                          1  ...

    569967860 == 0x21f904f4 # the 31 low order bits of the UUID

The result is that space\_id 569967860 is guaranteed to be unique for all space cadets i.e. ChessGame instances, MySpaceCadet instances and other space cadets. Note in the rare event that there is a duplicate id conflict in uuids, a new UUID is tried.

    # space cadet's space id
    my_space_cadet = ... # created MySpaceCadet instance
    t = 'my_space_cadets'
    id = my_space_cadet.id
    u = SpaceCadet::Uuid.find_by_source_name_and_source_id(t, id)
    space_id = u.space_id # my_space_cadet's space_id
    uuid = u.uuid # my_space_cadet's uuid

    # chess game from uuid and space_id
    uuid = '274ead56-7c8f-4c8d-ad21-35d4a1f904f4'
    space_id_calculator = Object.new.extend SpaceCadetSpaceId 
    # 569967860 == 0x21f904f4 # the 31 low order bits of the UUID
    space_id = space_id_calculator.space_id_from_uuid uuid, 31
    space_cadet_ref = SpaceCadet::Uuid.find_by_space_id space_id 
    source_id = space_cadet_ref.source_id # 23
    space_cadet_source_name = space_cadet_ref.source_name # 'chess_games'
    chess_game_class = <some function> space_cadet_source_name
    chess_game = chess_game_class.find(source_id) 
    'e2e4' == chess_game.moves # true

## Requirements

Most likely any recent version of 1.9 ruby works.

Most likely any database gem supported by activerecord works.

Most likely any version of the activerecord gem which can use the given database gem and can be used with require "active\_record" works.

## Test with rspec ~> 2.11, rspec -fd

The specs assume that the connection url in spec/support/space\_cadet.rb works.

The specs assume that the uuids table exists in the database.

The specs assume that the chess\_games table exists in the database.

The specs do not update the database (transactions with rollback).

Note, to prepare the database for testing:

    irb prompt> load 'spec/support/space_cadet.rb'
    irb prompt> up
    irb prompt> exit

The author uses DbVisualizer 9.0.5 and irb to try out the space cadets.

Note, to find the gem installation directory:

    irb prompt> require 'space_cadet'
    irb prompt> $".grep(/space_cadet/)[0]
    irb prompt> exit

## License

Copyright (c) 2013 Bardi Einarsson. Released under the MIT License.  See the [LICENSE][license] file for further details.

[license]: https://github.com/bardibardi/space_cadet/blob/master/LICENSE.md

