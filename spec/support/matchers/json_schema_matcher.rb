RSpec::Matchers.define :match_json_schema do |schema, strict = false|
  match do |response_body|
    schema_dir = Rails.root.join('spec/support/schemas')
    schema_path = "#{schema_dir}/#{schema}.json"

    JSON::Validator.validate!(schema_path, response_body, strict: strict)
  end
end
