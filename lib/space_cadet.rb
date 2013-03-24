require_relative 'space_cadet_any_db_uuid'

class SpaceCadetWrapper

  include SpaceCadetUuid

  ID_BIT_COUNT = 31

  def after_create record
    source_id = record.id
    source_name = record.class.table_name
    uuid_create SpaceCadet::Uuid, source_id, source_name, ID_BIT_COUNT
  end

  def before_destroy record
    u = SpaceCadet::Uuid.find_by_source_name_and_source_id(
        record.class.table_name, record.id)
    SpaceCadet::Uuid.delete u.id
  end

end # SpaceCadetWrapper

