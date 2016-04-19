# gmrender-resurrect-events

Simple shell script which listens for [gmrender-resurrect](https://github.com/hzeller/gmrender-resurrect) media playback events and notifies other apps (in user defined ways).


## Usage

Define your notification mechanism by implementing the `notify_play`, `notify_pause` & `notify_stop` functions in `gmr_ev.sh`.


## Installation

To install, run the install.sh script.
```sudo sh install.sh [--logfile=/tmp/gmediarenderer.log]```

***Note***: If `logfile` isn't set, it defaults to `/tmp/gmrender.log`.


## How it works

The script is meant to be run as a cronjob, started on boot. 

It works by reading gmrender-resurrect's logfile, looking for patterns related to playback events. It is therefore imperative to enable logging for gmrender-resurrect. 
It can be easily extended to support a variety of other events.

I wrote this script because I wanted a mechanism to be able to switch ON an external amplifier (connected to a gmrender-resurrect running on a raspberry pi) when the renderer starts to stream and switch it OFF when the streaming is complete. (See gmrender-resurrect[issue #89](https://github.com/hzeller/gmrender-resurrect/issues/89))
Obviously, the right way to do this would involve either extending the gmrender-resurrect source to include such a mechanism (using some sort of IPC) or writing a full fledged UPnP dameon listening to events on the network (as Henner Zeller suggests).

But I wanted to keep it simple. Moreover, extending the gmrender-resurrect source or writing a complete UPnP C daemon for my particular use case would be sort of an overkill.


