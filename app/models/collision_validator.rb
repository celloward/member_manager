class CollisionValidator < ActiveModel::Validator

  include PeopleHelper

  def validate record
    record.errors[:base] << "End date may not be before marriage date" if (to_date(record.end_date) < to_date(record.marriage_date))
    Marriage.other_marriages(record).each do |marriage|
      unless marriage.id == record.id
        record.errors[:base] << "Marriage date collision with #{marriage}" if ((to_date(marriage.marriage_date)..to_date(marriage.end_date)).to_a & (to_date(record.marriage_date)..to_date(record.end_date)).to_a).any?
      end
    end
  end
end