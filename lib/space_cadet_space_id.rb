module SpaceCadetSpaceId

  HEX_DIGIT ||= Hash[
    '0', 0, '1', 1, '2', 2, '3', 3,
    '4', 4, '5', 5, '6', 6, '7', 7,
    '8', 8, '9', 9, 'a', 10, 'b', 11,
    'c', 12, 'd', 13, 'e', 14, 'f', 15
  ].reduce({}, &->(h,p){h[p[0].getbyte(0)] = p[1];h})
  def num_from_hex_string hex_string
    hex_string.bytes.reduce(0, &->(num,b){num <<= 4;num += HEX_DIGIT[b]})
  end

  def high_order_bits_from_hex_string hex_string, bit_count
    total_bit_count = hex_string.length << 2
    num = num_from_hex_string hex_string
    num >> (total_bit_count - bit_count)
  end

  def low_order_bits_from_hex_string hex_string, bit_count
    num = num_from_hex_string hex_string
    num & ((1 << bit_count) - 1)
  end

  def space_id_from_uuid uuid, id_bit_count
    hex_string = uuid[24..-1]
    low_order_bits_from_hex_string hex_string, id_bit_count
  end

end # SpaceCadetSpaceId

