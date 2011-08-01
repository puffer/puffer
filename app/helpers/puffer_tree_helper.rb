module PufferTreeHelper

  def puffer_tree hash, options = {}, &block
    content_tag :ul, options do
      puffer_tree_node hash, &block
    end if hash.present?
  end

  def puffer_tree_node hash, &block
    hash.keys.each do |node|
      block.call node, render_tree(hash[node], &block)
    end if hash.present?
  end

end
