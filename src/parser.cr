require "yaml"
require "ecr"
require "textwrap"

module ECS::Parser
  enum Level
    Core
    Extended
  end

  enum Type
    Date
    Keyword
    Long
    GeoPoint
    IP
    Object
    Boolean
    Text
    Float
    Integer

    def crystal_type
      case self
      when Date     then Time
      when Keyword  then String
      when Long     then UInt64
      when GeoPoint then String # TODO
      when IP       then String
      when Object
        # Note that the V type of this hash *could* be any of the other types
        # as well, but is not. The only use of the `object` type has an
        # `object_type` of `keyword`.
        Hash(String, String)
      when Boolean then Bool
      when Text    then String
      when Float   then Float64
      when Integer then Int64
      end
    end
  end

  struct Section
    include YAML::Serializable
    property dashed_name : String
    property description : String
    property example : String | Float64 | Array(String)?
    property flat_name : String
    property level : Level
    setter name : String
    property normalize : Array(String)
    property short : String
    property type : Type
    property object_type : Type?

    def name
      if @name[0] == '@'
        @name[1..]
      else
        @name
      end.split('.')[-1]
    end

    def decorator
      if @name[0] == '@'
        %<  @[JSON::Field(key: "#{@name}")]\n>
      else
        ""
      end
    end

    def docs
      description.wrap.split('\n').map do |line|
        if line.empty?
          "  #"
        else
          "  # " + line
        end
      end.join '\n'
    end
  end

  def type_strings(keys : Iterator(Array(String)))
    keys.compact_map do |key|
      t = key[...-1]
      t.map(&.capitalize).join "::" unless keys.includes? t
    end.uniq
  end

  def type_string(key : Array(String)) : String
    key.map(&.camelcase).join "::"
  end

  def nodes(keys : Iterator(String))
    keys.map(&.split('.')).uniq.to_a.sort_by &.size
  end

  def properties(ecs)
    n = nodes ecs.each_key
    sections = Hash(String, Array(Section)).new do |hash, key|
      hash[key] = [] of Section
    end
    n.each do |node|
      sections[type_string node[...-1]] << ecs[node.join '.']
    end
    sections
  end
end
