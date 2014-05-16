#!/usr/bin/env ruby

# Create a basic 20 questions tree implementation with learning


# Create Queue from 2 Stacks, gives Amortized constant time operations
class CustomQueue
  attr_reader :inbox, :outbox

  def initialize
    @inbox = []
    @outbox = []
  end

  # Adds element to inbox
  def enqueue(element)
    @inbox.push(element)
  end

  # Removes element from queue and returns that element
  def dequeue
    # Refill outbox by popping each element from inbox and pushing onto outbox
    if @outbox.empty?

      while @inbox.length > 0 do
        @outbox.push(@inbox.pop)
      end
    end

    return @outbox.pop
  end
end

qu = CustomQueue.new

qu.enqueue(1)
qu.enqueue(2)
qu.enqueue(4)

# Debugging output
# puts qu.inbox

puts qu.dequeue
puts qu.dequeue
puts qu.dequeue