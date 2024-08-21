# typed: true
require 'sorbet-runtime'

# EN: This is a real life example of a bridge pattern usage.
# The main concept is that from the Abstraction (Device) and Implementation
# (BasicRemote) different teams can create new subclasses without interfering
# with each other.
#
# RU: Это настоящий пример использования моста.Основная концепция заключается в
# том, что из абстракции (Device) и реализации (BasicRemote) различные команды
# могут создавать новые подклассы, не мешая друг другу.
#
class Device
  extend T::Sig

  sig { returns(Integer) }
  attr_accessor :channel

  sig { returns(Integer) }
  attr_accessor :volume

  def initialize
    @enabled = false
    @volume = 30
    @channel = 1
  end

  sig { returns(T::Boolean) }
  def enabled?
    @enabled
  end

  sig { void }
  def enable
    @enabled = true
  end

  sig { void }
  def disable
    @enabled = false
  end

  sig { void }
  def print_status
    raise NotImplementedError,
          "#{self.class} has not implemented method '#{__method__}'"
  end
end

class Radio < Device
  extend T::Sig

  sig { void }
  def print_status
    puts <<~TEXT
      ------------------------------------
      | I'm radio.
      | I'm #{enabled? ? 'enabled' : 'disabled'}
      | Current volume is #{volume}%
      | Current channel is #{channel}
      ------------------------------------\n
    TEXT
  end
end

class Tv < Device
  extend T::Sig

  sig { void }
  def print_status
    puts <<~TEXT
      ------------------------------------
      | I'm a TV.
      | I'm #{enabled? ? 'enabled' : 'disabled'}
      | Current volume is #{volume}%
      | Current channel is #{channel}
      ------------------------------------
    TEXT
  end
end

class BasicRemote
  extend T::Sig

  sig { params(device: Device).void }

  def initialize(device)
    @device = device
  end

  sig { void }
  def power
    puts 'Remote: power toggle'
    @device.enabled? ? @device.disable : @device.enable
  end

  sig { void }
  def volume_down
    @device.volume -= 10
  end

  sig { void }
  def volume_up
    @device.volume += 10
  end

  sig { void }
  def channel_down
    @device.channel -= 1
  end

  sig { void }
  def channel_up
    @device.channel += 1
  end
end

class AdvancedRemote < BasicRemote
  extend T::Sig

  sig { void }
  def mute
    @device.volume = 0
  end
end

# EN: Demo test code
#
# RU: Демо -тестовый код
#
def test_device(device)
  puts 'Tests with basic remote.'
  basic_remote = BasicRemote.new(device)
  basic_remote.power
  device.print_status

  puts 'Tests with advanced remote.'
  advanced_remote = AdvancedRemote.new(device)
  advanced_remote.power
  advanced_remote.mute
  device.print_status
end

test_device(Radio.new)
test_device(Tv.new)
