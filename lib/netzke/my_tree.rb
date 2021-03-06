class Netzke::MyTree < Netzke::Base  
  api :get_children
  
  def self.js_base_class
    "Ext.tree.TreePanel"
  end
    
  # New and overriden properties of the resulting JS class
  def self.js_extend_properties
    {
      :root => {:text => 'Root', :id => 'source'},
      :init_component => <<-END_OF_JAVASCRIPT.l,
        function(){
          // dataUrl should be set to the API point which provides us with the nodes
          this.dataUrl = this.buildApiUrl("get_children");
          // Call the superclass' initComponent
          #{js_full_class_name}.superclass.initComponent.call(this);
        }
      END_OF_JAVASCRIPT
    }
  end

  def get_children(params)
    klass = config[:model].constantize
    node_id = params[:node].to_i
    puts "params[node] = #{params[:node].inspect}"
    puts "get_children: klass= #{klass}, node_id: #{node_id}"    
    node = params[:node] == 'source' ? klass.where("parent_id is NULL").first : klass.find(params[:node].to_i)
    puts "node: #{node.inspect}"
    node.children.map{|n| {:text => n.name, :id => n.id}}
  end
    
end
