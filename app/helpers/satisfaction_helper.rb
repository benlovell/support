module SatisfactionHelper
  def how_satisfied(rating)
    case rating
    when 5
      'Very satisfied'
    when 4
      'Satisfied'
    when 3
      'Neither satisfied or dissatisfied'
    when 2
      'Dissatisfied'
    when 1
      'Very dissatisfied'
    end
  end
end
