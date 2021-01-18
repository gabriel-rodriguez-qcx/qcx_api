# rubocop:disable Rails/SkipsModelValidations
# frozen_string_literal: true

require 'net/http'

Rails.logger.info 'Inserting questions'
URI('https://raw.githubusercontent.com/qcx/desafio-backend/master/questions.json')
  .then { |uri| Net::HTTP.get(uri) }
  .then { |response| JSON.parse(response, symbolize_names: true) }
  .tap { |qas| qas.each { |qa| qa.merge!(updated_at: Time.zone.now) } }
  .in_groups_of(1000, false) { |question_accesses_attr| Question.insert_all(question_accesses_attr) }
Rails.logger.info 'Done.'

Rails.logger.info 'Inserting QuestionAccesses'
URI('https://raw.githubusercontent.com/qcx/desafio-backend/master/question_access.json')
  .then { |uri| Net::HTTP.get(uri) }
  .then { |response| JSON.parse(response, symbolize_names: true) }
  .tap { |qas| qas.each { |qa| qa.merge!(created_at: Time.zone.now, updated_at: Time.zone.now) } }
  .in_groups_of(1000, false) { |question_accesses_attr| QuestionAccess.insert_all(question_accesses_attr) }
Rails.logger.info 'Done.'

Rails.logger.info 'Indexing QuestionAccesses'
QuestionAccess.reindex
Rails.logger.info 'Done.'
# rubocop:enable Rails/SkipsModelValidations
