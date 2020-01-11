class DobValidator < ActiveModel::Validator
  
  def validate record
    match_set = record.dob.match(/\A(\d{2})[\-\/](\d{2})[\-\/](\d{4})\z/)
    begin
      dob = Time.local(match_set[3], match_set[1], match_set[2])
    rescue
      dob = nil
    end
    if dob.nil?
      record.errors.add :base, "Invalid date entry for Date of Birth"
    elsif dob > Time.now
      record.errors.add :base, "Date of Birth out of range"
    elsif (Time.now - dob) > 5000000000
      record.errors.add :base, "Date of Birth out of range"
    end
  end
end