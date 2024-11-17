# Self-driving to Music

Converts what a self-driving car sees into music.

## Getting the driving dataset

Step 1: Get [nuScenes](https://www.nuscenes.org/nuscenes) dataset. If you want you can try any other driving dataset, but you'd have to somehow parse that dataset yourself.

Step 2: `pip install nuscenes-devkit`. As of today (2024-11-16), I found that requires you to use Python `3.10.12` and Numpy `1.26.4`. It flat out fails if it uses a later Numpy version. So maybe do this:

```bash
conda create -n name nuscene python=3.10.12
conda activate nuscene
pip install numpy==1.26.4
pip install nuscenes-devkit
pip install ipython
```

Step 3: Run the notebook `nuscene_to_data.ipynb` to generate some `scene_data.txt`. This is a comma-separated list, with each line being a sample point (sampled once every 0.5 seconds). The line consists of the number of `near_vehicle, far_vehicle, near_human, far_human, near_object, far_object`, where "near" means "within 20 meters of the car".

Also, generate a video of the cameras overlaid with the bounding boxes of vehicles, humans, and other objects.

## Getting Sonic Pi

First, download the `Sonic Pi` program and install it.

Next, run Sonic Pi. Try loading `bolero.rb`. Press `run`. It should sound like [Boléro (Maurice Ravel, 1928)](https://en.wikipedia.org/wiki/Bol%C3%A9ro). I made a simple recording of it in `bolero.mp3`.

If it works then try `hamr_3.rb`. Change the line `File.open(ENV['HOME']+"/Desktop/HAMR_hackathon/near_far_scene_data.txt")` to use the file name you want to use.

Unfortunately Sonic Pi doesn't have convenient export button, so you can just press `record` and press it again after waiting about 30 seconds. It will save a `wav` file.

Then you can combine the `wav` file with the video generated in the previous section.

As an example, see the `scene_0061_full_music.mp4` in the repo.
