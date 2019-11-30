class ZipValidator < ActiveModel::Validator

  def validate record
    if !ZipCodes.identify(record.zipcode)
      record.errors.add :base, "Zip code does not exist"
    elsif State.none? { |state| state.abbr == ZipCodes.identify(record.zipcode)[:state_code] }
      record.errors.add :base, "Zip code does not match state"
    end
  end
end
      