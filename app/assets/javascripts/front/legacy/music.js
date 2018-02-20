
function formatDuration(seconds) {
  var sec_num = parseInt(seconds, 10) // don't forget the second param
  var hours   = Math.floor(sec_num / 3600)
  var minutes = Math.floor((sec_num - (hours * 3600)) / 60)
  var seconds = sec_num - (hours * 3600) - (minutes * 60)

  if (hours   < 10) {hours   = "0"+hours}
  if (minutes < 10) {minutes = "0"+minutes}
  if (seconds < 10) {seconds = "0"+seconds}
  
  if (hours > 0)
    return hours+':'+minutes+':'+seconds
  else
  return minutes+':'+seconds
}

$(document).on('turbolinks:load', function() {
  // Player Choose Mood
  $('.s__music .btn').on('click', function (e) {
    e.preventDefault()
    var item = $(this)

    $('.s__music .btn').removeClass('active')
    $('.mood-text').text(item.text())
    item.addClass('active')
  });

  // Select Mood PopUp
  var playlistBtn = $('.controls-container .playlist-button');
  playlistBtn.add('.icon-arrow-close-pop-up').on('click', function () {
    playlistBtn.toggleClass('active');
    $('.popup').fadeToggle('slow');
    return false;
  });

  $('.mood__container a').each(function () {
    $(this).on('click', function (e) {
      e.preventDefault();
      $('.mood__container a').removeClass('active');
      $(this).addClass('active');
    })
  });

  // Player Choose Instrument
  function addIcon(state, that) {
    var icon = that.find('i').clone(),
      iconClass = icon.attr('class');
    (state === true) ? $('.playlist-mood').append(icon) : $('.playlist-mood').find("." + iconClass).remove()
  }

  $('.instrument__container a').on('click', function (e) {
    e.preventDefault()
    var self = $(this)
    $(this).toggleClass('active')
    $(this).hasClass('active') ? addIcon(true, self) : addIcon(false, self)
  });
  
  var $volwr = $('.volume-wrap input[type="range"]');
  var val = $volwr.val();
  var buf = ((100 - val) / 4) + parseInt(val);
  $volwr.css(
    'background',
    'linear-gradient(to right, #C5E0DC 0%, #C5E0DC ' + val + '%, #eee ' + val + '%, #eee ' + buf + '%, #eee ' + buf + '%, #eee 100%)'
  );

  /*===============================================================*/
  // HTML5 audio player + playlist controls
  var jsPlayer = document.querySelector('.player-wrap');
  if (jsPlayer) {
    jsPlayer = {
      wrap: jsPlayer,
      player: jsPlayer.querySelector('audio'),
      wrapList: (document.querySelector('.playlist-wrap') || {}),
      currentTime: (jsPlayer.querySelector('.current-time') || {}),
      durationTime: (jsPlayer.querySelector('.duration-time') || {}),
      seekBar: (jsPlayer.querySelector('.seek-bar') || {style: {}}),
      volumeBar: (jsPlayer.querySelector('.volume-bar') || {style: {}}),
      bigPlayButton: (jsPlayer.querySelector('.big-play-button') || {style: {}}),
      bigPauseButton: (jsPlayer.querySelector('.big-pause-button') || {style: {}}),
      playButton: (jsPlayer.querySelector('.play-button') || {style: {}}),
      pauseButton: (jsPlayer.querySelector('.pause-button') || {style: {}}),
      prevButton: (jsPlayer.querySelector('.prev-button') || {style: {}}),
      nextButton: (jsPlayer.querySelector('.next-button') || {style: {}}),
      playlistButton: (jsPlayer.querySelector('.playlist-button') || {style: {}}),
      muteButton: (jsPlayer.querySelector('.mute-button') || {style: {}}),
      titleText: (jsPlayer.querySelector('.title-text') || {style: {}}),
      artistText: (jsPlayer.querySelector('.artist-text') || {style: {}}),
      restoreValue: 0,
      seekInterval: null,
      trackCount: 0,
      playing: false,
      playlist: [],
      tracks: [],
      idx: 0,
    };


    jsPlayer.playClicked = function jsPlayerPlayClicked() {
      jsPlayer.bigPauseButton.style.display = 'block';
      jsPlayer.bigPlayButton.style.display = 'none';
      jsPlayer.pauseButton.style.display = 'block';
      jsPlayer.playButton.style.display = 'none';
      jsPlayer.playing = true;
      jsPlayer.player.play();
      jsPlayer.seekInterval = setInterval(jsPlayer.updateSeek, 500);
    };
    jsPlayer.pauseClicked = function jsPlayerPauseClicked() {
      clearInterval(jsPlayer.seekInterval);
      jsPlayer.bigPlayButton.style.display = 'flex';
      jsPlayer.bigPauseButton.style.display = 'none';
      jsPlayer.playButton.style.display = 'flex';
      jsPlayer.pauseButton.style.display = 'none';
      jsPlayer.playing = false;
      jsPlayer.player.pause();
    };

    jsPlayer.muteClicked = function jsPlayerMuteClicked() {
      jsPlayer.muteButton.classList.toggle('muted');
      jsPlayer.restoreValue = jsPlayer.player.volume;
      if (jsPlayer.muteButton.classList.contains('muted')) {
        jsPlayer.player.muted = true;
        jsPlayer.volumeBar.value = 0;
        jsPlayer.volumeBar.disabled = true;
      } else {
        jsPlayer.player.muted = false;
        jsPlayer.player.volume = jsPlayer.restoreValue;
        jsPlayer.volumeBar.value = jsPlayer.restoreValue * 100;
        jsPlayer.volumeBar.disabled = false;
      }
    };

    jsPlayer.mediaEnded = function jsPlayerMediaEnded() {
      if (jsPlayer.idx + 1 < jsPlayer.trackCount) {
        jsPlayer.idx++;
        jsPlayer.playTrack(jsPlayer.idx);
      } else {
        jsPlayer.pauseClicked();
        jsPlayer.idx = 0;
        jsPlayer.loadTrack(jsPlayer.idx);
      }
    };
    jsPlayer.loadTracklist = function jsPlayerLoadPlaylist() {
      jsPlayer.playlist = jsPlayer.wrapList.tagName ? jsPlayer.wrapList.querySelectorAll('ol > li') : [];
      var len = jsPlayer.playlist.length,
        tmp, i;
      if (len > 0) {
        jsPlayer.wrap.classList.add('list-view');
        for (i = jsPlayer.trackCount; i < len; i++) {
          if (!jsPlayer.playlist[i].dataset) {
            jsPlayer.playlist[i].dataset = {};
          }
          tmp = jsPlayer.playlist[i].querySelector('a');
          if (tmp.tagName && !jsPlayer.playlist[i].dataset.idx) {
            jsPlayer.playlist[i].dataset.idx = i;
            jsPlayer.trackCount++;
            jsPlayer.tracks.push({
              'file': tmp.href,
              'artist': tmp.dataset.artist ? decodeURIComponent(tmp.dataset.artist).replace(/^\s+|\s+$/g, '') : '&nbsp;',
              'name': decodeURIComponent(tmp.textContent || tmp.innerText).replace(/^\s+|\s+$/g, '')
            });
          }
        }
      }
    };
    jsPlayer.loadTrack = function jsPlayerLoadTrack(idx) {
      var len = jsPlayer.playlist ? jsPlayer.playlist.length : 0,
        i;
      for (i = 0; i < len; i++) {
        if (jsPlayer.playlist[i].classList) {
          if (i == idx) {
            jsPlayer.playlist[i].classList.add('sel');
          } else {
            jsPlayer.playlist[i].classList.remove('sel');
          }
        }
      }
      jsPlayer.titleText.innerHTML = jsPlayer.tracks[idx].name;
      jsPlayer.artistText.innerHTML = jsPlayer.tracks[idx].artist;
      jsPlayer.player.src = jsPlayer.tracks[idx].file;
      jsPlayer.idx = idx;
    };
    jsPlayer.playTrack = function jsPlayerPlayTrack(idx) {
      jsPlayer.loadTrack(idx);
      jsPlayer.playClicked();
    };
    jsPlayer.listClicked = function jsPlayerListClicked(event) {
      clearInterval(jsPlayer.seekInterval);
      var parent = event.target.parentNode;
      if (parent.parentNode.tagName.toLowerCase() === 'ol') {
        event.preventDefault();
        jsPlayer.playTrack(parent.dataset.idx);
      }
    };
    jsPlayer.setDuration = function jsPlayerSetDuration() {
      jsPlayer.durationTime.innerHTML = jsPlayer.formatTime(jsPlayer.player.duration);
      jsPlayer.currentTime.innerHTML = jsPlayer.formatTime(jsPlayer.player.currentTime);
      jsPlayer.seekBar.value = jsPlayer.player.currentTime / jsPlayer.player.duration;
    };
    jsPlayer.updateSeek = function jsPlayerUpdateSeek() {
      if (jsPlayer.player.duration > -1) {
        jsPlayer.seekBar.value = 100 * (jsPlayer.player.currentTime || 0) / jsPlayer.player.duration;
        jsPlayer.currentTime.innerHTML = jsPlayer.formatTime(jsPlayer.player.currentTime || 0);
      }
    };
    jsPlayer.seekHeld = function jsPlayerSeekHeld(event, ui) {
      jsPlayer.seekBar.parentNode.classList.add('sel');
      clearInterval(jsPlayer.seekInterval);
      jsPlayer.player.pause();
    };
    jsPlayer.seekReleased = function jsPlayerSeekReleased() {
      if (jsPlayer.player.duration > -1) {
        jsPlayer.player.currentTime = jsPlayer.seekBar.value * jsPlayer.player.duration / 100;
        jsPlayer.seekBar.parentNode.classList.remove('sel');
        if (jsPlayer.playing) {
          jsPlayer.player.play();
          jsPlayer.seekInterval = setInterval(jsPlayer.updateSeek, 500);
        } else {
          jsPlayer.updateSeek();
        }
      }
    };
    jsPlayer.volumeSet = function jsVolumeSet() {
      jsPlayer.player.volume = jsPlayer.volumeBar.value / 100;

      if (jsPlayer.player.volume === 0) {
        jsPlayer.muteButton.classList.add('muted');

      } else {
        jsPlayer.muteButton.classList.remove('muted');
      }
    };

    jsPlayer.prevClicked = function jsPlayerPrevClicked(event) {
      event.preventDefault();
      console.log(jsPlayer);
      if (jsPlayer.idx - 1 > -1) {
        jsPlayer.idx--;
        if (jsPlayer.playing) {
          jsPlayer.playTrack(jsPlayer.idx);
        } else {
          jsPlayer.loadTrack(jsPlayer.idx);
        }
      } else {
        jsPlayer.pauseClicked();
        jsPlayer.idx = 0;
        jsPlayer.loadTrack(jsPlayer.idx);
      }
    };
    jsPlayer.nextClicked = function jsPlayerNextClicked(event) {
      event.preventDefault();
      if (jsPlayer.idx + 1 > -1 && jsPlayer.idx < jsPlayer.trackCount - 1) {
        jsPlayer.idx++;
        if (jsPlayer.playing) {
          jsPlayer.playTrack(jsPlayer.idx);
        } else {
          jsPlayer.loadTrack(jsPlayer.idx);
        }
      } else {
        jsPlayer.pauseClicked();
        jsPlayer.idx = 0;
        jsPlayer.loadTrack(jsPlayer.idx);
      }
    };
    jsPlayer.playlistButtonClicked = function jsPlayerPlaylistButtonClicked() {
      jsPlayer.wrap.classList.toggle('show-list');
      jsPlayer.playlistButton.style.backgroundImage = (jsPlayer.wrap.classList.contains('show-list') && jsPlayer.wrap.style.backgroundImage) ? jsPlayer.wrap.style.backgroundImage : '';
    };
    jsPlayer.formatTime = function jsPlayerFormatTime(val) {
      var h = 0, m = 0, s;
      val = (parseInt(val, 10) || 0);
      if (val > 60 * 60) {
        h = parseInt(val / (60 * 60), 10);
        val -= h * 60 * 60;
      }
      if (val > 60) {
        m = parseInt(val / 60, 10);
        val -= m * 60;
      }
      s = val;
      val = (h > 0) ? h + ':' : '';
      val += (m > 0) ? ((m < 10 && h > 0) ? '0' : '') + m + ':' : '0:';
      val += ((s < 10) ? '0' : '') + s;
      return val;
    };
    jsPlayer.init = function jsPlayerInit() {
      if (!!document.createElement('audio').canPlayType('audio/mpeg')) {
        if (jsPlayer.wrapList.tagName && jsPlayer.wrapList.querySelectorAll('ol > li').length > 0) {
          jsPlayer.loadTracklist();
        } else if (jsPlayer.wrap.tagName && jsPlayer.wrap.dataset.url) {
          jsPlayer.tracks = [{
            'file': jsPlayer.wrap.dataset.url,
            'artist': 'by-' + decodeURIComponent(jsPlayer.wrap.dataset.artist || 'unknown').replace(/^\s+|\s+$/g, ''),
            'name': decodeURIComponent(jsPlayer.wrap.dataset.title || '').replace(/^\s+|\s+$/g, '')
          }];
        }
        if (jsPlayer.tracks.length > 0 && jsPlayer.player) {
          jsPlayer.player.addEventListener('ended', jsPlayer.mediaEnded, true);
          jsPlayer.player.addEventListener('loadeddata', jsPlayer.setDuration, true);
          if (jsPlayer.wrapList.tagName) {
            jsPlayer.wrapList.addEventListener('click', jsPlayer.listClicked, true);
          }
          if (jsPlayer.bigPlayButton.tagName) {
            jsPlayer.bigPlayButton.addEventListener('click', jsPlayer.playClicked, true);
            if (jsPlayer.bigPauseButton.tagName) {
              jsPlayer.bigPauseButton.addEventListener('click', jsPlayer.pauseClicked, true);
            }
          }
          if (jsPlayer.playButton.tagName) {
            jsPlayer.playButton.addEventListener('click', jsPlayer.playClicked, true);
            if (jsPlayer.pauseButton.tagName) {
              jsPlayer.pauseButton.addEventListener('click', jsPlayer.pauseClicked, true);
            }
          }
          if (jsPlayer.prevButton.tagName) {
            jsPlayer.prevButton.addEventListener('click', jsPlayer.prevClicked, true);
          }
          if (jsPlayer.nextButton.tagName) {
            jsPlayer.nextButton.addEventListener('click', jsPlayer.nextClicked, true);
          }
          if (jsPlayer.volumeBar.tagName) {
            jsPlayer.volumeBar.addEventListener('mousemove', jsPlayer.volumeSet, true);
          }
          if (jsPlayer.muteButton.tagName) {
            jsPlayer.muteButton.addEventListener('click', jsPlayer.muteClicked, true);
          }
          if (jsPlayer.playlistButton.tagName) {
            jsPlayer.playlistButton.addEventListener('click', jsPlayer.playlistButtonClicked, true);
          }
          if (jsPlayer.seekBar.tagName) {
            if (matchMedia('only screen and (min-device-width : 320px) and (max-device-width : 1024px)').matches) {
              jsPlayer.seekBar.addEventListener('touchstart', jsPlayer.seekHeld, true);
              jsPlayer.seekBar.addEventListener('touchend', jsPlayer.seekReleased, true);
            } else {
              jsPlayer.seekBar.addEventListener('mousedown', jsPlayer.seekHeld, true);
              jsPlayer.seekBar.addEventListener('mouseup', jsPlayer.seekReleased, true);
            }
          }
          jsPlayer.wrap.className += ' enabled';
          jsPlayer.loadTrack(jsPlayer.idx);
        }
      }
    };
    jsPlayer.init();
  }

})
