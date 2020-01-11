class StateValidator < ActiveModel::Validator

  def validate(record)
    if State.none? { |state_entry| state_entry.abbr == record.state }
      record.errors.add :base, "Not a valid state abbreviation"
    end
  end
end