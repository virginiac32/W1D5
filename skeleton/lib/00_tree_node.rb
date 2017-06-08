class PolyTreeNode
  attr_reader :value, :parent, :children
  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(node)
    return nil if @parent == node
    @parent.children.delete(self) unless @parent.nil?
    @parent = node
    node.children << self unless node.nil?
  end

  def add_child(child_node)
    @children << child_node unless @children.include?(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise "Node is not a child" unless @children.include?(child_node)
    @children.delete(child_node)
    child_node.parent = nil
  end

  def dfs(target_value)
    return self if self.value == target_value
    self.children.each do |child|
      result = child.dfs(target_value)
      return result if result
    end
    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      node = queue.shift
      return node if node.value == target_value
      queue.concat(node.children)
    end
    nil
  end

end

class KnightPathFinder
  attr_reader :start_pos, :visited_positions, :move_tree

  def initialize(start_pos)
    @start_pos = start_pos
    @visited_positions = [start_pos]
    @move_tree = build_move_tree
  end


  def build_move_tree
    root = PolyTreeNode.new(start_pos)
    queue = [root]
    until queue.empty?
      current_node = queue.shift
      new_positions = new_move_positions(current_node.value)
      new_positions.each do |pos|
        child_node = PolyTreeNode.new(pos)
        current_node.add_child(child_node)
        queue << child_node
      end
    end
    root
  end

  def find_path(end_pos)
    end_node = move_tree.bfs(end_pos)
    trace_path_back(end_node)
  end

  def trace_path_back(end_node)
    path = []
    node = end_node
    until node.parent.nil?
      path.unshift(node.value)
      node = node.parent
    end
    path
  end

  def new_move_positions(pos)
    new_positions = self.class.valid_moves(pos)-visited_positions
    visited_positions.concat(new_positions)
    new_positions
  end

  def self.valid_moves(pos)
    valid_locs = (0..7).to_a
    moves = all_moves(pos)
    moves.select do |move|
      valid_locs.include?(move[0]) && valid_locs.include?(move[1])
    end
  end

  def self.all_moves(pos)
    deltas = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]
    new_pos = []
    deltas.each do |delta|
      new_pos << [pos[0] + delta[0], pos[1] + delta[1]]
    end
    new_pos
  end
end
