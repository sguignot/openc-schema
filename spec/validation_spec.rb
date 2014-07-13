require 'json-schema'

describe "open-schemas" do
  it "should validate valid json" do
    Dir.glob(File.join('spec','sample-data', 'valid', '*')).each do |path|
      data = File.open(path) {|f| f.read}
      errors = JSON::Validator.fully_validate(find_schema(path), data, :errors_as_objects => true)
      expect(errors).to be_empty, "#{path} was invalid: #{errors.join("\n")}"
    end

  end

  it "should not validate invalid json" do
    Dir.glob(File.join('spec','sample-data', 'invalid', '*')).each do |path|
      data = File.open(path) {|f| f.read}
      validation_result = JSON::Validator.validate(find_schema(path), data)
      expect(validation_result).to be_falsy, "Invalid schema #{path} was valid"
    end
  end
end

def find_schema(path)
  filename = File.basename(path)

  raise "Invalid filename for sample data at #{path}" unless filename =~ /-\d\d\.json$/

  schema_name = filename.sub(/-\d\d\.json$/, '-schema.json')
  schema_path = File.join('schemas', schema_name)

  raise "Could not find schema for sample data at #{path}" unless File.exists?(schema_path)

  schema_path
end
