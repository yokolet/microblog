class Api::V1::Post < ApplicationRecord
  # validation
  validates_presence_of :subject, :content
end
