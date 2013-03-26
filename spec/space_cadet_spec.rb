require_relative 'support/ar_rspec'
require_relative 'support/space_cadet'
require 'securerandom'

describe SpaceCadet::Uuid do

  it "should be created" do
    id, _ = add_chess_game 'e2e4', ''
    u = SpaceCadet::Uuid.find_by_source_name_and_source_id(
      'chess_games', id)
    expect(id).to eq(u.source_id)
  end

  it "should have unique space_id" do
    duplicate_id, chess_game = add_chess_game 'e2e4', ''
    u = SpaceCadet::Uuid.find_by_source_name_and_source_id(
      'chess_games', duplicate_id)
    duplicate_uuid = u.uuid
    scw = SpaceCadetWrapper.new
    duplicate_space_id = scw.space_id_from_uuid duplicate_uuid, 31
    # to make sure that the expected exception
    #   is not due to broken code
    scw.add_uuid(SpaceCadet::Uuid, duplicate_id + 2,
      'chess_games', duplicate_space_id + 2, duplicate_uuid)
    exception_thrown = nil
    begin
      scw.add_uuid(SpaceCadet::Uuid, duplicate_id + 1,
        'chess_games', duplicate_space_id, duplicate_uuid)
    rescue
      exception_thrown = true
    end
    expect(exception_thrown).to eq(true)
  end

  it "should be deleted when parent is destroyed" do
    id, chess_game = add_chess_game 'e2e4', ''
    u = SpaceCadet::Uuid.find_by_source_name_and_source_id(
      'chess_games', id)
    expect(id).to eq(u.source_id)
    chess_game.class.destroy(id)
    exception_thrown = nil
    begin
      u = SpaceCadet::Uuid.find_by_source_name_and_source_id!(
        'chess_games', id)
    rescue
      exception_thrown = true
    end
    expect(exception_thrown).to eq(true)
  end

end

