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
  sync :tick
  frame = data[current_frame]
  use_synth :chip_bass
  
  # Two notes per frame
  2.times do |i|
    amp = frame[:near_vehicle] * 0.3
    play [:c2, :e2][i], amp: amp, release: 0.2
    sleep 0.25
  end
end

# Arpeggio based on far vehicles
live_loop :far_vehicles do
  sync :tick
  frame = data[current_frame]
  use_synth :chiplead
  
  if frame[:far_vehicle] > 0
    # Limit to 4 notes per frame to maintain timing
    notes = (scale :c3, :major_pentatonic).take(4)
    2.times do
      play notes.choose, amp: 0.4, release: 0.1
      sleep 0.25
    end
  else
    sleep 0.5
  end
end

# High-pitched bleeps for near humans
live_loop :near_humans do
  sync :tick
  frame = data[current_frame]
  use_synth :beep
  
  if frame[:near_human] > 0
    2.times do
      play :c5, amp: 0.5, release: 0.1
      sleep 0.25
    end
  else
    sleep 0.5
  end
end

# Background pad for far humans
live_loop :far_humans do
  sync :tick
  frame = data[current_frame]
  use_synth :blade
  
  play :e4, amp: frame[:far_human] * 0.2, release: 0.5 if frame[:far_human] > 0
  sleep 0.5
end

# Environmental sounds based on objects
live_loop :objects do
  sync :tick
  frame = data[current_frame]
  use_synth :hollow
  
  note = [:c4, :e4, :g4].choose
  amp = frame[:near_object] * 0.15
  release = [0.5, frame[:far_object] * 0.1].min # Limit release time
  
  play note, amp: amp, release: release if frame[:near_object] > 0
  sleep 0.5
end

# Percussion track
live_loop :drums do
  sync :tick
  frame = data[current_frame]
  total_objects = frame.values.sum
  
  2.times do |i|
    sample :drum_heavy_kick, amp: 0.8 if i == 0
    sample :drum_cymbal_closed, amp: 0.3 if total_objects > 5 && i == 1
    sleep 0.25
  end
end

# Master timing control - exactly 0.5 seconds per frame
live_loop :tick do
  cue :tick
  sleep 0.5
  current_frame = (current_frame + 1) % data.length
end