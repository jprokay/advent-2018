class Digraph
  attr_reader :root, :vertices, :being_worked

  @@max_working_on = 5

  def initialize(root)
    @root = root
    @vertices = []
    @being_worked = []
  end

  def add_edge(to, from)
    to_vertex = get_vertex(to) || WeightedVertex.new(to)
      
    from_vertex = get_vertex(from) || WeightedVertex.new(from)
    to_vertex.add_successor(from_vertex)
    from_vertex.add_ancestor(to_vertex)
    @vertices << to_vertex unless @vertices.include? to_vertex
    @vertices << from_vertex unless @vertices.include? from_vertex

    update_root!(to_vertex)
  end

  def update_root!(vertex)
    if @root.nil?
      @root = vertex
    else
      @root = vertex if vertex.successors.include? @root
    end
  end

  def get_vertex(value)
    idx = @vertices.index { |x| x.value == value }
    if idx != nil
      @vertices[idx]
    else
      nil
    end
  end

  def weighted_order
    time_taken = 0
    def order(vertex, discovered = [], to_visit = [])
      return 0 if vertex.nil?
      puts "Worked: #{vertex}"
      discovered << vertex unless discovered.include? vertex
      @being_worked -= [vertex]
      time_taken = vertex.work_remaining

      # Perform work on each node
      @being_worked.each { |v| v.work_on!(time_taken) }

      vertex.successors.each { |s| s.ancestor_finished!(vertex) }
      # Remove any nodes that have been discovered already
      to_visit -= [vertex]
      
      # Group by number of ancestors left to visit
      grouped = to_visit.uniq.group_by { |a| a.unfinished_ancestors.length }
      
      grouped.keys.sort.each { |k| puts "#{k} Ancestor(s): #{grouped[k].join(',')}"}
      if grouped.keys.length > 0
        puts "#{grouped.keys.min} ancestors left: #{grouped[grouped.keys.min].join(',')}"
        next_to_work_on = grouped[grouped.keys.min].sort_by { |a| a.value }
        #@being_worked = (@being_worked + new_to_work_on).sort

        next_to_work_on.each do |n|
          @being_worked << n unless (@being_worked.length == @@max_working_on) or @being_worked.include? n
        end

        # @being_worked.sort!
        puts "To work: #{@being_worked.join(',')}"
        visit = @being_worked.sort[0]
        
        time_taken += order(visit, discovered, to_visit)
      end
      time_taken
    end

    order(@root, [], @vertices)
  end

  def to_s
  end

  class WeightedVertex
    attr_reader :value, :successors, :ancestors, :weight, :unfinished_ancestors, :work_remaining

    @@alphabet = ('A'..'Z').to_a
    @@base_weight = 60

    def initialize(value, successors = [])
      @value = value
      @successors ||= successors
      @ancestors = @unfinished_ancestors = []
      @weight = value_to_weight
      @work_remaining = @weight
    end

    def add_successor(vertex)
      @successors << vertex
      @successors.sort!
      self
    end

    def add_ancestor(vertex)
      @ancestors << vertex
      @unfinished_ancestors << vertex
      @ancestors.sort!
      self
    end

    def ancestor_finished!(vertex)
      @unfinished_ancestors = @unfinished_ancestors - [vertex]
      @unfinished_ancestors.sort!
      self
    end

    def work_on!(time)
      @work_remaining = @work_remaining - time
      self
    end

    def to_s
      "#{@value}(#{@work_remaining}/#{@weight})"
    end

    def <=>(other)
      @work_remaining <=> other.work_remaining
    end

    def ==(other)
      @value == other.value
    end

    def value_to_weight
      @@base_weight + @@alphabet.index(@value) + 1
    end
  end
end

def parse_line_to_vertex(line)
  steps = /Step ([A-Z]{1}) must be finished before step ([A-Z]{1}) can begin./.match(line)
  [steps[1], steps[2]]
end

def main
  tried = [ 1187 ]
  digraph = Digraph.new(nil)
  open("input.txt").readlines.each do |line|
    arr = parse_line_to_vertex(line)
    digraph.add_edge(arr[0], arr[1])
  end
  ordered = digraph.weighted_order
  puts ordered
  #puts ordered.inject(0) { |sum, n| sum += n.weight }

  puts "Already tried? #{tried.include? ordered}"
end

main