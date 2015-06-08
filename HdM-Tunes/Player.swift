//
//  Player.swift
//  HdM-Tunes
//
//  Created by Guest User on 05/06/15.
//  Copyright (c) 2015 JE. All rights reserved.
//

import UIKit
import AVFoundation

class Track: NSObject
{
    var duration = 0.0
    var title = ""
    var artist = ""
    var album = ""
    var uri = ""
    var albumArtUri = ""
    
    func setDuration (duration: Double){
        self.duration = duration
    }
    
    func getDuration () -> Double{
        return duration
    }
    
    func getAlbumUri () -> String {
        return albumArtUri
    }
    
    func setAlbumArtUri(albumArtUri: String){
        self.albumArtUri = albumArtUri
    }
    
    func getTitle() ->String{
        return title
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func getArtist() -> String {
        return artist
    }
    
    func setArtist(artist: String) {
        self.artist = artist
    }
    
    func  getAlbum() -> String{
        return album
    }
    
    func setAlbum(album: String) {
        self.album = album
    }
    
    func getUri() -> String{
        return uri
    }
    
    func setUri(uri: String) {
        self.uri = uri
    }
    
    func toString() -> String{
        return title + "\n" + artist + " - " + album
    }
    

    
}

enum PlayerState {
    case empty
    case loaded
    case paused
    case playing
    case playbackComplete
}





class Player: NSObject
{
    var mediaPlayer: AVAudioPlayer!
    var playbackPosition = 0
    var track: Track?
    var currentState = PlayerState.empty
    
    
    func load(track: Track)
    {
        
       playbackPosition = 0
        self.track = track
        
        switch currentState {
            case .empty:
                currentState = PlayerState.paused
                break
            case .paused:
                currentState = PlayerState.paused
                break
            case .playing:
                currentState = PlayerState.playing
                break
            case .playbackComplete:
                currentState = PlayerState.paused
                break
        default:
                break
        }
        
        track.setDuration(mediaPlayer.duration)

    
    }
    
    func play() {
    
        switch currentState {
            case .paused:
                currentState = PlayerState.playing
                break
            case .playbackComplete:
                currentState = PlayerState.playing
                break
            default:
                break
        }
    }
    
    func pause() {
        if (currentState != PlayerState.empty) {
            stopTimerTask()
            
        }else{
            currentState = PlayerState.paused
            mediaPlayer.pause()
        }
        
    }
    
    func muteMediaPlayer(mute:Bool) {
        if (mute) {
            mediaPlayer.volume = 0.0
        } else {
            mediaPlayer.volume = 1.0
        }
           
    }
    
    func getCurrentTrack() -> Track {
        return track!
    }
    
    func getCurrentPosition() -> Int {
        return playbackPosition
    }
    
    func getState() -> PlayerState {
        return currentState
    }
    
    func getDuration() -> Double {
        return track?.getDuration()
    }
    
    // doppelt? Check bei Android
    
    func getPlaybackPosition() -> Int {
        return playbackPosition
    }
    
    func setPlaybackPosition(playbackPosition: Int) {
        self.playbackPosition = playbackPosition
    }
    
    func startTimer() {}
    
    func initializeTimerTask() {}
    
    func stopTimerTask(){}
    
    
    
    // listener
    // PlayerStateChangedListener
    
    // für wikipedia
    // CurrentTackChangedListener
}



/*
public class PlayerImpl implements Player {

private static Player instance;

private PlayerState currentState;
private HashSet<PlaybackPositionUpdateListener> playbackPosListeners;
private HashSet<PlaybackCompletionListener> playbackCompletionListeners;
private HashSet<TrackLoadedListener> trackLoadedListeners;
private HashSet<PlayerStateChangedListener> playerStateChangedListeners;
private int playbackPosition;

private Track track;

private Timer timer;
private TimerTask timerTask;

private MediaPlayer mediaplayer;

private Context context;

/**
*
* @param context
* @return the singleton
*/
public static synchronized Player getInstance(Context context) {

if (instance == null) {
instance = new PlayerImpl(context);
}
return instance;
}

/**
* private initialization
*/
private PlayerImpl(Context context) {
this.context = context;
this.currentState = PlayerState.empty;
this.playbackPosListeners = new HashSet<PlaybackPositionUpdateListener>();
this.playbackCompletionListeners = new HashSet<PlaybackCompletionListener>();
this.trackLoadedListeners = new HashSet<TrackLoadedListener>();
this.playerStateChangedListeners = new HashSet<PlayerStateChangedListener>();

mediaplayer = new MediaPlayer();

}

/**
* load the track create the mediaplayer object and set its current state
*/
public synchronized void load(Track track) {
                            playbackPosition = 0;
                            this.track = track;

                            switch (this.currentState) {
                            case empty:
                            this.currentState = PlayerState.paused;
                            break;
                            case paused:
                            this.currentState = PlayerState.paused;
                            break;
                            case playing:
                            this.currentState = PlayerState.playing;
                            break;
                            case playbackComplete:
                            this.currentState = PlayerState.paused;
                            break;
                            }

mediaplayer.reset();
mediaplayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
try {
mediaplayer.setDataSource(context, track.getUri());
} catch (IllegalArgumentException e) {
e.printStackTrace();
} catch (SecurityException e) {
e.printStackTrace();
} catch (IllegalStateException e) {
e.printStackTrace();
} catch (IOException e) {
e.printStackTrace();
}

try {
mediaplayer.prepare();
} catch (IllegalStateException e) {
e.printStackTrace();
} catch (IOException e) {
e.printStackTrace();
}

                            track.setDuration(mediaplayer.getDuration());

notifyOnTrackLoaded();
notifyOnPlayerStateChanged();
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#play()
*/
public synchronized void play() {
startTimer();

mediaplayer.start();

                            switch (this.currentState) {
                            case paused:
                            this.currentState = PlayerState.playing;
                            break;
                            case playbackComplete:
                            this.currentState = PlayerState.playing;
                            break;
                            default:
                            break;
                            }

notifyOnPlayerStateChanged();
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#pause()
*/
public synchronized void pause() {
                        if (this.currentState != PlayerState.empty) {
                        stopTimerTask();
                        this.currentState = PlayerState.paused;
                        mediaplayer.pause();
}

notifyOnPlayerStateChanged();
}

/**
* Release the MediaPlayer instance
*/
public synchronized void releaseMediaPlayer() {
mediaplayer.release();
mediaplayer = null;
}

/**
* Mutes the MediaPlayer
*/
public void muteMediaPlayer(boolean bool) {
                        if (bool) {
                        mediaplayer.setVolume(0, 0);
                        } else
                        mediaplayer.setVolume(0, 1);

}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#getCurrentTrack()
*/
public Track getCurrentTrack() {
                        return track;
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#getCurrentPosition()
*/
public int getCurrentPosition() {
                        return this.playbackPosition;
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#getState()
*/
public synchronized PlayerState getState() {
                        return this.currentState;
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#getDuration()
*/
public int getDuration() {
                        return track.getDuration();
}

/**
* public getter for playback position
*/
public int getPlaybackPosition() {
                        return playbackPosition;
}

/**
* public setter for playback position
*/
public void setPlaybackPosition(int playbackPosition) {
                        this.playbackPosition = playbackPosition;
}

/**
* public getter for application context
*/
public Context getContext() {
return context;
}

/**
* public setter for application context
*/
public void setContext(Context context) {
this.context = context;
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#addPlaybackPositionUpdateListener(de.hdm.tunes2.mediaplayer.player.PlaybackPositionUpdateListener)
*/
public synchronized void addPlaybackPositionUpdateListener(
PlaybackPositionUpdateListener listener) {

playbackPosListeners.add(listener);

}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#removePlaybackPositionUpdateListener(de.hdm.tunes2.mediaplayer.player.PlaybackPositionUpdateListener)
*/
public synchronized void removePlaybackPositionUpdateListener(
PlaybackPositionUpdateListener listener) {

for (PlaybackPositionUpdateListener playbackPosListener : playbackPosListeners) {
if (listener == playbackPosListener) {
playbackPosListeners.remove(listener);
}
}
}

/**
* This method notifies the registered listeners about the current playback
* position
*
* @see de.hdm.tunes2.mediaplayer.player.Player#notifyOnPlaybackPosition()
*/
public synchronized void notifyOnPlaybackPosition() {
for (PlaybackPositionUpdateListener playbackPosListener : playbackPosListeners) {
playbackPosListener.onPlaybackPositionUpdate(playbackPosition,
getDuration());
}
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#addPlaybackCompleteListener(de.hdm.tunes2.mediaplayer.player.PlaybackCompletionListener)
*/
public synchronized void addPlaybackCompleteListener(
PlaybackCompletionListener listener) {
playbackCompletionListeners.add(listener);
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#removePlaybackCompleteListener(de.hdm.tunes2.mediaplayer.player.PlaybackCompletionListener)
*/
public synchronized void removePlaybackCompleteListener(
PlaybackCompletionListener listener) {
for (PlaybackCompletionListener playbackComListener : playbackCompletionListeners) {
if (listener == playbackComListener) {
playbackCompletionListeners.remove(listener);
}
}
}

/**
* This method notifies the registered listeners that the playback is
* complete
*/
public synchronized void notifyOnPlaybackComplete() {
for (PlaybackCompletionListener playbackComListener : playbackCompletionListeners) {
playbackComListener.onPlaybackComplete();
}
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#addTrackLoadedListener(de.hdm.tunes2.mediaplayer.player.TrackLoadedListener)
*/
public synchronized void addTrackLoadedListener(TrackLoadedListener listener) {
trackLoadedListeners.add(listener);
}

/**
* {@inheritDoc}
*
* @see de.hdm.tunes2.mediaplayer.player.Player#removeTrackLoadedListener(de.hdm.tunes2.mediaplayer.player.TrackLoadedListener)
*/
public synchronized void removeTrackLoadedListener(
TrackLoadedListener listener) {
for (TrackLoadedListener trackLoadedListener : trackLoadedListeners) {
if (listener == trackLoadedListener) {
trackLoadedListeners.remove(listener);
}
}
}

/**
* This method notifies the registered listeners that track has loaded
*/
public synchronized void notifyOnTrackLoaded() {
for (TrackLoadedListener trackLoadedListener : trackLoadedListeners) {
trackLoadedListener.onTrackLoaded(track);
}
}

/**
* @see de.hdm.tunes2.mediaplayer.player.Player#addPlayerStateChangedListener(de.hdm.tunes2.mediaplayer.player.PlayerStateChangedListener)
*/
public synchronized void addPlayerStateChangedListener(
PlayerStateChangedListener listener) {
playerStateChangedListeners.add(listener);
}

/**
* @see de.hdm.tunes2.mediaplayer.player.Player#removePlayerStateChangedListener(de.hdm.tunes2.mediaplayer.player.PlayerStateChangedListener)
*/
public synchronized void removePlayerStateChangedListener(
PlayerStateChangedListener listener) {
for (PlayerStateChangedListener playerStateChangedListener : playerStateChangedListeners) {
if (listener == playerStateChangedListener) {
playerStateChangedListeners.remove(listener);
}
}
}

/**
* @see de.hdm.tunes2.mediaplayer.player.Player#notifyOnPlayerStateChanged()
*/
public synchronized void notifyOnPlayerStateChanged() {
for (PlayerStateChangedListener playerStateChangedListener : playerStateChangedListeners) {
playerStateChangedListener.onPlayerStateChanged();
}
}

/**
* creates the Timer for the playback position
*/
@Override
public void startTimer() {
timer = new Timer();
initializeTimerTask();
timer.schedule(timerTask, 0, 1000);
}

/**
* inits the timerTask notifies the playback position to listeners
*
*/
@Override
public void initializeTimerTask() {

timerTask = new TimerTask() {

public synchronized void run() {

playbackPosition += 1000;
notifyOnPlaybackPosition();

if (playbackPosition >= getDuration()) {
currentState = PlayerState.playbackComplete;
mediaplayer.stop();
stopTimerTask();
notifyOnPlaybackComplete();
notifyOnPlayerStateChanged();
}
}
};
}

/**
* stops the timerTask
*/
@Override
public void stopTimerTask() {
if (timer != null) {
timer.cancel();
timer = null;
}
}
*/