module WeatherHelper

  def compass(degree=0)
    if degree > 22.5 && degree < 67.5
      :NE
    elsif degree > 67.5 && degree < 112.5
      :E
    elsif degree > 112.5 && degree < 157.5
      :SE
    elsif degree > 157.5 && degree < 202.5
      :S
    elsif degree > 202.5 && degree < 247.5
      :SW
    elsif degree > 247.5 && degree < 292.5
      :W
    elsif degree > 292.5 && degree < 337.5
      :NW
    elsif degree > 337.5 && degree < 360 || degree > 0 && degree < 22.5
      :N
    end
  end
end