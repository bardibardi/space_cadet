def l
  me = File.expand_path File.basename(__FILE__), File.dirname(__FILE__)
  result = load me
  [result, me]
end

require_relative '../../lib/space_cadet'

POSTGRESQL_URL ||= "postgres://postgres:postgres@localhost/postgres"

CONNECTION_POOL ||= ActiveRecord::Base.establish_connection POSTGRESQL_URL

END { CONNECTION_POOL.disconnect! }

class ChessGameCore < ActiveRecord::Migration

  def self.up
    create_table :chess_games do |t|
      t.string :moves
      t.string :ambiguities
      t.integer :move_number
      t.integer :is_whites_move
      t.string :position
    end
  end

  def self.down
    drop_table :chess_games
  end

end # ChessGameCore

class ChessGame < ActiveRecord::Base

  after_create SpaceCadetWrapper.new
  before_destroy SpaceCadetWrapper.new

end # ChessGame

START_POSITION ||=
  "a8brb8bnc8bbd8bqe8bkf8bbg8bnh8br" +
  "a7bpb7bpc7bpd7bpe7bpf7bpg7bph7bp" +
  "a2wpb2wpc2wpd2wpe2wpf2wpg2wph2wp" +
  "a1wrb1wnc1wbd1wqe1wkf1wbg1wnh1wr"

def add_chess_game moves, ambiguities
  record = nil
  ChessGame.create! do |g|
    g.moves = moves
    g.ambiguities = ambiguities
    g.move_number = 1
    g.is_whites_move = 1
    g.position = START_POSITION
    record = g
  end
  [record.id, record]
end

def up
  SpaceCadet::UuidCore.up
  ChessGameCore.up
end

def down
  ChessGameCore.down
  SpaceCadet::UuidCore.down
end

