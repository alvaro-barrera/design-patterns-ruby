# typed: true

require 'sorbet-runtime'

# Define the Computer class
class Computer
  extend T::Sig

  sig { void }
  def initialize
    @components = {}
  end

  sig { params(name: String, value: String).void }
  def add_component(name, value)
    @components[name] = value
  end

  sig { void }
  def show
    puts "Computer configuration:"
    @components.each do |name, value|
      puts "#{name}: #{value}"
    end
  end

  sig { void }
  def finalize!
    puts 'Finalizing the computer setup...'
    @components.freeze
  end
end

# Define the abstract builder class
class ComputerBuilder
  extend T::Sig

  sig { void }
  def reset
    raise NotImplementedError
  end

  sig { void }
  def computer
    raise NotImplementedError
  end

  sig { void }
  def build_cpu
    raise NotImplementedError
  end

  sig { void }
  def build_ram
    raise NotImplementedError
  end

  sig { void }
  def build_storage
    raise NotImplementedError
  end
end

# Define the concrete builder class
class GamingComputerBuilder < ComputerBuilder
  extend T::Sig

  sig { void }
  def initialize
    reset
  end

  sig { override.void }
  def reset
    @computer = Computer.new
  end

  sig { override.returns(Computer) }
  def computer
    computer = @computer
    reset
    computer
  end

  sig { override.void }
  def build_cpu
    @computer.add_component('CPU', 'Intel Core i9')
  end

  sig { override.void }
  def build_ram
    @computer.add_component('RAM', '32GB DDR4')
  end

  sig { override.void }
  def build_storage
    @computer.add_component('Storage', '1TB SSD')
  end
end

# Define the concrete builder class for office computers
class OfficeComputerBuilder < ComputerBuilder
  extend T::Sig

  sig { override.void }
  def initialize
    reset
  end

  sig { override.void }
  def reset
    @computer = Computer.new
  end

  sig { override.returns(Computer) }
  def computer
    computer = @computer
    reset
    computer
  end

  sig { override.void }
  def build_cpu
    @computer.add_component('CPU', 'Intel Core i5')
  end

  sig { override.void }
  def build_ram
    @computer.add_component('RAM', '16GB DDR4')
  end

  sig { override.void }
  def build_storage
    @computer.add_component('Storage', '512GB SSD')
  end
end

# Define the director class
class ComputerDirector
  extend T::Sig

  sig { params(builder: ComputerBuilder).void }
  def initialize(builder)
    @builder = builder
  end

  sig { void }
  def build_gaming_computer
    @builder.build_cpu
    @builder.build_ram
    @builder.build_storage
  end
end

def test_computer(builder)
  puts "Building a computer:"
  director = ComputerDirector.new(builder)
  director.build_gaming_computer
  gaming_computer = builder.computer
  gaming_computer.show
end

# Usage of the builder and director
test_computer(GamingComputerBuilder.new)
test_computer(OfficeComputerBuilder.new)
