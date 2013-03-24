require_relative 'space_cadet_uuid'
require_relative 'space_cadet_space_id'
require_relative 'space_cadet_active_record_uuid'

module SpaceCadetUuid

  include SpaceCadetSpaceId
  include SpaceCadetActiveRecordUuid

end

