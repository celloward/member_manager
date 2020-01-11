class SpouseValidator < ActiveModel::Validator
  
  def validate record
    living_spouses = record.spouses.collect { |spouse| spouse.living }
    if living_spouses.count > 1
      record.errors.add :base, "Cannot have more than one living spouse"
    end
  end
end