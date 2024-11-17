# Read data file - update path as needed
data = []
File.open(ENV['HOME']+"/Desktop/HAMR_hackathon/near_far_scene_data.txt").each_line do |line|
  near_vehicle, far_vehicle, near_human, far_human, near_object, far_object = line.split(',').map(&:to_i)
  data.push({
              near_vehicle: near_vehicle,
              far_vehicle: far_vehicle,
              near_human: near_human,
              far_human: far_human,
              near_object: near_object,
              far_object: far_object
  })
end

use_bpm 120
current_frame = 0

# Bass line based on near vehicles
live_loop :bass do
  frame = data[current_frame]
  use_synth :chip_bass
  
  notes = [:c2, :e2, :g2, :c3].ring
  4.times do |i|
    amp = frame[:near_vehicle] * 0.3
    play notes[i], amp: amp, release: 0.2
    sleep 0.25
  end
end

# Arpeggio based on far vehicles
live_loop :far_vehicles do
  frame = data[current_frame]
  use_synth :chiplead
  
  if frame[:far_vehicle] > 0
    notes = (scale :c3, :major_pentatonic).shuffle
    frame[:far_vehicle].times do |i|
      play notes[i % notes.length], amp: 0.4, release: 0.1
      sleep 0.125
    end
  else
    sleep 0.5
  end
end

# High-pitched bleeps for near humans
live_loop :near_humans do
  frame = data[current_frame]
  use_synth :beep
  
  if frame[:near_human] > 0
    frame[:near_human].times do
      play :c5, amp: 0.5, release: 0.1
      sleep 0.25
    end
  else
    sleep 0.5
  end
end

# Background pad for far humans
live_loop :far_humans do
  frame = data[current_frame]
  use_synth :blade
  
  if frame[:far_human] > 0
    play :e4, amp: frame[:far_human] * 0.2, release: 1
  end
  sleep 0.5
end

# Environmental sounds based on objects
live_loop :objects do
  frame = data[current_frame]
  use_synth :hollow
  
  # Near objects affect note choice
  note = [:c4, :e4, :g4].choose
  amp = frame[:near_object] * 0.15
  
  # Far objects affect release time
  release = 0.5 + (frame[:far_object] * 0.1)
  
  play note, amp: amp, release: release if frame[:near_object] > 0
  sleep 0.5
end

# Percussion track that gets more complex with more total objects
live_loop :drums do
  frame = data[current_frame]
  total_objects = frame.values.sum
  
  # Basic beat
  sample :drum_heavy_kick, amp: 0.8
  sleep 0.25
  
  # Add hi-hat if there are enough objects
  sample :drum_cymbal_closed, amp: 0.3 if total_objects > 5
  sleep 0.25
end

# Advance to next frame of data
live_loop :frame_advance do
  current_frame = (current_frame + 1) % data.length
  sleep 0.5
end