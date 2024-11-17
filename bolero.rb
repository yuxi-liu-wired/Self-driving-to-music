use_random_seed 1024

# Basic tempo and settings
use_bpm 72
bolero_rhythm = (ring 1, 0, 0.5, 0.5, 0, 0.5, 0.5, 0)

# Define the base scales and chord progressions
scale_notes = (scale :d, :minor)
chord_progression = (ring [:d, :minor], [:a, :major], [:g, :minor], [:d, :minor])

# Main drum pattern
define :drum_pattern do
  in_thread do
    loop do
      8.times do |i|
        sample :drum_snare_soft if bolero_rhythm[i] == 1
        sample :drum_snare_soft, amp: 0.5 if bolero_rhythm[i] == 0.5
        sleep 0.5
      end
    end
  end
end

# Bass line generator
define :generate_bass do |root, quality|
  notes = (chord root, quality)
  return notes.choose
end

# Melody generator based on seed
define :generate_melody do |scale_notes|
  melody = []
  8.times do
    note = scale_notes.choose
    melody.push(note)
  end
  return melody
end

# Main performance loop
live_loop :bolero do
  # Start with drums
  drum_pattern
  
  # Add bass after 4 measures
  in_thread do
    sleep 16
    loop do
      chord_progression.each do |chord|
        bass_note = generate_bass(chord[0], chord[1])
        use_synth :fm
        play bass_note, amp: 0.6, release: 2
        sleep 4
      end
    end
  end
  
  # Add first melody line after 8 measures
  in_thread do
    sleep 32
    loop do
      use_synth :piano
      melody = generate_melody(scale_notes)
      melody.each do |note|
        play note, amp: 0.7
        sleep 0.5
      end
    end
  end
  
  # Add second melody line after 12 measures
  in_thread do
    sleep 48
    loop do
      use_synth :blade
      melody = generate_melody(scale_notes)
      melody.each do |note|
        play note, amp: 0.5, release: 0.3
        sleep 0.5
      end
    end
  end
  
  # Add crescendo effect
  in_thread do
    sleep 64
    factor = 1
    loop do
      factor = factor + 0.1 if factor < 2
      set_volume! factor
      sleep 8
    end
  end
end