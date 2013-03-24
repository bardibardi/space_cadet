# needs
# space_id = space_id_from_uuid uuid, id_bit_count

require 'securerandom'
require 'active_record'

module SpaceCadetActiveRecordUuid

  def add_uuid uuid_class, source_id, source_name, space_id, uuid
    uuid_class.create! do |u|
      u.source_id = source_id
      u.source_name = source_name
      u.space_id = space_id
      u.uuid = uuid
    end
  end

  def space_id_add_uuid uuid_class, source_id, source_name, id_bit_count
    uuid = SecureRandom.uuid
    space_id = space_id_from_uuid uuid, id_bit_count
    record = nil
    begin
      record = add_uuid uuid_class, source_id, source_name, space_id, uuid
    rescue
      record = nil
    end
    record
  end

  ID_RETRY_COUNT = 10

  def uuid_create uuid_class, source_id, source_name, id_bit_count
    record = nil
    retry_count = 0
    while !record && retry_count < ID_RETRY_COUNT do
      record = space_id_add_uuid uuid_class, source_id, source_name, id_bit_count
    end
  end

end # SpaceCadetActiveRecordUuid

