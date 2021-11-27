require_relative "types"

module Mal
  module Core
    extend self

    def ns
      {
        Types::Symbol.for("+") => Types::Builtin.new { |a, b| a + b },
        Types::Symbol.for("-") => Types::Builtin.new { |a, b| a - b },
        Types::Symbol.for("*") => Types::Builtin.new { |a, b| a * b },
        Types::Symbol.for("/") => Types::Builtin.new { |a, b| a / b },

        Types::Symbol.for("prn") => Types::Builtin.new do |mal|
          val =
            if mal.any?
              mal.first
            else
              Types::Nil.instance
            end

          puts Mal.pr_str(val, true)

          Types::Nil.instance
        end,

        Types::Symbol.for("list") => Types::Builtin.new do |mal|
          list = Types::List.new
          mal.each { |m| list << m }
          list
        end,

        Types::Symbol.for("list?") => Types::Builtin.new do |mal|
          is_list =
            if mal.any?
              Types::List === mal.first
            else
              false
            end

          is_list ? Types::True.instance : Types::False.instance
        end,

        Types::Symbol.for("empty?") => Types::Builtin.new do |mal|
          is_empty =
            if mal.any?
              case mal.first
              when Types::List, Types::Vector
                mal.first.empty?
              else
                Types::True.instance
              end
            else
              Types::True.instance
            end

          is_empty ? Types::True.instance : Types::False.instance
        end,

        Types::Symbol.for("count") => Types::Builtin.new do |mal|
          count =
            if mal.any?
              case mal.first
              when Types::List, Types::Vector
                mal.first.size
              else
                0
              end
            else
              0
            end

          Types::Number.new(count)
        end,

        Types::Symbol.for("=") => Types::Builtin.new do |mal|
          a, b = mal

          if a.nil? || b.nil?
            Types::False.instance
          else
            if a == b
              Types::True.instance
            else
              Types::False.instance
            end
          end
        end,

        Types::Symbol.for("<") => Types::Builtin.new do |mal|
          a, b = mal

          if a.nil? || b.nil?
            Types::False.instance
          else
            if a.is_a?(Types::Number) && b.is_a?(Types::Number)
              if a.value < b.value
                Types::True.instance
              else
                Types::False.instance
              end
            else
              Types::False.instance
            end
          end
        end,

        Types::Symbol.for("<=") => Types::Builtin.new do |mal|
          a, b = mal

          if a.nil? || b.nil?
            Types::False.instance
          else
            if a.is_a?(Types::Number) && b.is_a?(Types::Number)
              if a.value <= b.value
                Types::True.instance
              else
                Types::False.instance
              end
            else
              Types::False.instance
            end
          end
        end,

        Types::Symbol.for(">") => Types::Builtin.new do |mal|
          a, b = mal

          if a.nil? || b.nil?
            Types::False.instance
          else
            if a.is_a?(Types::Number) && b.is_a?(Types::Number)
              if a.value > b.value
                Types::True.instance
              else
                Types::False.instance
              end
            else
              Types::False.instance
            end
          end
        end,

        Types::Symbol.for(">=") => Types::Builtin.new do |mal|
          a, b = mal

          if a.nil? || b.nil?
            Types::False.instance
          else
            if a.is_a?(Types::Number) && b.is_a?(Types::Number)
              if a.value >= b.value
                Types::True.instance
              else
                Types::False.instance
              end
            else
              Types::False.instance
            end
          end
        end,

        Types::Symbol.for("pr-str") => Types::Builtin.new do |mal|
          Types::String.new(mal.map { |m| Mal.pr_str(m, true) }.join(" "))
        end,

        Types::Symbol.for("str") => Types::Builtin.new do |mal|
          Types::String.new(mal.map { |m| Mal.pr_str(m, false) }.join(""))
        end,

        Types::Symbol.for("prn") => Types::Builtin.new do |mal|
          puts mal.map { |m| Mal.pr_str(m, true) }.join(" ")
          Types::Nil.instance
        end,

        Types::Symbol.for("println") => Types::Builtin.new do |mal|
          puts mal.map { |m| Mal.pr_str(m, false) }.join(" ")
          Types::Nil.instance
        end
      }
    end
  end
end