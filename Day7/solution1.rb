class Digraph
  attr_reader :root, :vertices

  def initialize(root)
    @root = root
    @vertices = []
  end

  def add_edge(to, from)
    to_vertex = get_vertex(to) || Vertex.new(to)
      
    from_vertex = get_vertex(from) || Vertex.new(from)
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

  def step_order
    
    def order(vertex, discovered = [], to_visit = [])
      puts "Visting: #{vertex}"
      return if vertex.nil?
      discovered << vertex unless discovered.include? vertex

      # Remove any nodes that have been discovered already
      to_visit = to_visit - [vertex]
      
      # Group by number of ancestors left to visit
      grouped = to_visit.uniq.group_by { |a| (a.ancestors.reject { |ancestor| discovered.include? ancestor }).length }
      puts grouped.keys.join(',')
      if grouped[grouped.keys.min]
        puts "#{grouped.keys.min} has #{grouped[grouped.keys.min].join(',')}"
        visit = grouped[grouped.keys.min].sort[0]
        order(visit, discovered, to_visit)
      end
      discovered
    end

    order(@root, [], @vertices)
  end

  def to_s

  end

  class Vertex
    attr_reader :value, :successors, :ancestors

    def initialize(value, successors = [])
      @value = value
      @successors ||= successors
      @ancestors = []
    end

    def add_successor(vertex)
      @successors << vertex
      @successors.sort!
      self
    end

    def add_ancestor(vertex)
      @ancestors << vertex
      @ancestors.sort!
      self
    end

    def to_s
      "#{@value}"
    end

    def <=>(other)
      @value <=> other.value
    end

    def ==(other)
      @value == other.value
    end
  end
end

def parse_line_to_vertex(line)
  steps = /Step ([A-Z]{1}) must be finished before step ([A-Z]{1}) can begin./.match(line)
  [steps[1], steps[2]]
end

def main
  tried = [ "IBECGFDAHJKLQVYPNSMORZX", "IBJEGFKDANVPCHSYMLZQROX" ]
  digraph = Digraph.new(nil)
  open("input.txt").readlines.each do |line|
    arr = parse_line_to_vertex(line)
    digraph.add_edge(arr[0], arr[1])
  end
  puts digraph.root
  ordered = digraph.step_order.join('')
  puts ordered
  puts "Already tried? #{tried.include? ordered}"
end

main