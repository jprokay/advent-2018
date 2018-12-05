class Guard
  include Comparable
  attr_reader :minutes_asleep, :id

  def initialize(id)
    @id = id
    @minutes_asleep = {}
    (0..59).each do |i|
      @minutes_asleep[i] = 0
    end
  end

  def total_minutes_slept
    @minutes_asleep.values.reduce(:+)
  end

  def slept(from, to)
    (from..to).each do |i|
      @minutes_asleep[i] += 1
    end
  end

  def to_s
    "Guard \##{id} has slept #{total_minutes_slept} min"
  end

  def most_slept_minute
    minute = 0
    prev_amount = 0
    @minutes_asleep.each do |min, amount|
      (minute = min and prev_amount = amount) if amount > prev_amount
    end
    return MinuteFreq.new(minute, prev_amount)
  end

  def <=>(other)
    self.most_slept_minute.min <=> other.most_slept_minute.min
  end
end

class MinuteFreq
  include Comparable

  attr_reader :min, :freq
  def initialize(min, freq)
    @min = min
    @freq = freq
  end

  def <=>(other)
    @freq <=> other.freq
  end

  def to_s
    "#{min} - #{freq}"
  end
end

class GuardTimeEvent
  attr_reader :time, :event

  def initialize(time, event)
    @time = time
    @event = event
  end

  def to_s
    "[#{time.to_s}] #{event}"
  end
end

def main
  guards = {}
  duties = open("input.txt").readlines
  sleepAt = nil
  wakeAt = nil
  guard = nil
  sorted_guard_duties(duties).each do |gtv|
    event = gtv.event
    
    guard_match = /Guard #(\d+) begins shift/.match(event)
    if guard_match
      id = guard_match[1].to_i
      guard = guards[id] ||= Guard.new(id)
    elsif /wakes up\b/.match event
      wakeAt = gtv.time.min
      guard.slept(sleepAt, wakeAt)
    else
      sleepAt = gtv.time.min
    end
  end

  guard = guards.values.max_by { |g| g.total_minutes_slept }
  puts guard.most_slept_minute.min * guard.id
end

def sorted_guard_duties(duties)
  times = duties.map { |d| get_guard_time(d) }
  times.sort_by { |t| t.time }
end

# Get the [year-month-day hour:min] from a line
def get_guard_time(guard_duty)
  re = /\[(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2})\](.+)/
  a = re.match(guard_duty)
  GuardTimeEvent.new(Time.new(a[1].to_i, a[2].to_i, a[3].to_i, a[4].to_i, a[5].to_i),
    a[6])
end

main