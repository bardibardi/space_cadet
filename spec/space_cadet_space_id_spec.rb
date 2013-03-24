require 'support/no_should_rspec'
require 'space_cadet_space_id'

$idcalc = Object.new.extend SpaceCadetSpaceId

describe SpaceCadetSpaceId do

  it "should convert hex chars to digits" do
    digits = "abcef" * 10
    eval_value = eval("0x" + digits)
    value = $idcalc.num_from_hex_string digits
    expect(value).to eq(eval_value)
  end

  it "should get high order bits" do
    digits = "abcef" * 10
    value = $idcalc.high_order_bits_from_hex_string digits, 3
    expect(value).to eq(5)
  end

  it "should get low order bits" do
    digits = "abcef" * 10
    value = $idcalc.low_order_bits_from_hex_string digits, 3
    expect(value).to eq(7)
  end

  it "should get uuid low order bits" do
    uuid = "ef53c3f1-9c4f-46db-9f6c-02c7402ef24a"
    value = $idcalc.space_id_from_uuid uuid, 3
    expect(value).to eq(2)
  end

end
