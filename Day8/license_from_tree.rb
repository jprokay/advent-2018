
class Tree
  attr_reader :root, :nodes

  def initialize
    @root = Node.new
    @nodes = []
  end

  def self.build input
    tree = Tree.new

    def self.build_children input
      puts "Processing: #{input}"
      num_children = input[0].to_i
      num_entries = input[1].to_i

      node = Node.new
      if num_children == 0
        entries = input[2..(2 + num_entries - 1)]
        puts entries
        node.add_entries! entries
        puts "#{node}"
      else
        to_process = input[2..-1]
        (0..num_children).each do
          node.add_children!(build_children(to_process))
          processed = node.child_entries
          to_process = to_process[(2+processed.length)..-1]    
        end
        node.add_entries! metadata_entries
      end

      puts "#{node}"
      return [node]
    end

    tree.root.add_children! self.build_children(input)
  end

  class Node
    attr_reader :child_nodes, :metadata_entries, :id

    @@sequence_generator = ('A'..'Z').lazy

    def initialize
      @id = @@sequence_generator.next
      @child_nodes = []
      @metadata_entries = []
    end

    def add_child! node
      @child_nodes << node
      self
    end

    def add_children! nodes
      @child_nodes = @child_nodes + nodes
      self
    end

    def add_entry! entry
      @metadata_entries << entry
      self
    end

    def add_entries! entries
      @metadata_entries = @metadata_entries + entries
      self
    end

    def total_entry
      @metadata_entries.inject(0) { |sum, n| sum += n }
    end

    def child_entries
      @child_nodes.inject([]) { |entries, child| entries + child.child_entries }
    end

    def to_s
      "Node #{@id} | Entries: #{@metadata_entries.join("|")}"
    end
  end
end

def main
  input = open("test_input.txt").readline.split("\s")
  Tree.build(input)
end

main