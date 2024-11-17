# Read data file
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

use_bpm 72
current_frame = 0

# Bolero rhythm pattern
bolero_rhythm = (ring 1, 0, 0.5, 0.5, 0, 0.5, 0.5, 0)

# Calculate intensity ratio (avoiding division by zero)
define :intensity_ratio do |near, far|
  total = near + far
  total > 0 ? (near.to_f / total) : 0
end

# Main performance loop with intensity control
live_loop :bolero do
  # Get current frame data
  frame = data[current_frame]
  
  # Calculate intensities (0 to 1)
  vehicle_intensity = intensity_ratio(frame[:near_vehicle], frame[:far_vehicle])
  human_intensity = intensity_ratio(frame[:near_human], frame[:far_human])
  object_intensity = intensity_ratio(frame[:near_object], frame[:far_object])
  
  # Piano melody (vehicles)
  use_synth :piano
  play (scale :d4, :minor).choose, amp: vehicle_intensity * 0.8
  
  # Drums (humans)
  sample :drum_snare_soft, amp: human_intensity * 0.6 if bolero_rhythm.tick == 1
  sample :drum_snare_soft, amp: human_intensity * 0.3 if bolero_rhythm.look == 0.5
  
  # Bass (objects)
  use_synth :fm
  play :d2, amp: object_intensity * 0.5, release: 0.3
  
  sleep 0.5
  current_frame = (current_frame + 1) % data.length
end