require 'matrix'
require 'pp'
require 'csv'

class SampleLine
  attr_reader :a, :b

  def initialize
    x1,y1 = rand_point
    x2,y2 = rand_point
    @b = (y1 - y2) / (x1 - x2)
    @a = y1 - @b * x1
    # puts "Initialize line through: (#{x1}, #{y1}), (#{x2}, #{y2})"
  end

  def get_ab
    return [@a, @b]
  end

  def calc_y(x)
    a * x + b
  end

  def random_points(limit = 10)
    results = []
    (1..limit).each do |i|
      x1, x2 = rand_point
      y = calc_y(x1)
      y1 = (y < x2 ? 1 : -1)
      results << [x1, x2, y1]
    end

    results
  end

  private
  def rand_point
    [rand(-1.0..1.0), rand(-1.0..1.0)]
  end
end

class Pla
  attr_reader :w

  def initialize(training_set)
    @t_set = []
    training_set.each do |item|
      @t_set << item.unshift(1)
    end
    @t_size = @t_set.size
    @length = 3
    @w = Vector.elements(Array.new(@length, 0))
  end

  def training
    points = miss_points
    iteration = 0
    while points.length > 0
      sample = points.sample
      y = sample.last
      x = Vector.elements(sample[0..-2])
      @w = @w + y * x
      points = miss_points
      iteration += 1
    end
    return iteration
  end

  def check(validation)
    count = 0
    validation.each do |point|
      x_val = Vector.elements(point[0..-2].unshift(1))
      y_val = point.last
      y_train = (x_val.covector * @w).first
      y_train = (y_train >= 0 ? 1 : -1)
      count += 1 if y_train != y_val
    end
    return count.to_f / validation.size
  end

  private
  def miss_points
    results = []
    @t_set.each do |e|
      x = Vector.elements(e[0..-2])
      y = e.last
      y1 = (((x.covector * @w).first >= 0) ? 1 : -1)
      results << e if (y != y1)
    end
    return results
  end
end

avg = 0
test = 0
total = 1
(1..total).each do |i|
  sample = SampleLine.new
  points = sample.random_points(10)
  CSV.open("points.dat", "wb", col_sep: " ") do |csv|
    points.each{|point| csv << point}
  end
  pla = Pla.new(points)
  avg += pla.training
  validations = sample.random_points(1000)
  test += pla.check(validations)
  line = sample.get_ab
  w = pla.w
  File.write("line.dat", line.first.to_s + " " + line.last.to_s)
  File.write("w.dat", w.to_a.join(" "))
  # p points
  # p pla.w
end
puts avg / total
puts test / total
