$(document).on('turbolinks:load', function() {
  console.log('loading common.js')

  //  Chapter Nav Hide
  $(window).on('scroll', function () {
    var chapterNavWr = $('.page-article-no-img .chapter-nav-wrapper');
    if ($(this).scrollTop() > 300) {
      chapterNavWr.fadeIn()
    } else {
      chapterNavWr.fadeOut()
    }
  });

  //  Come meditate mobile dropdown
  $('.div-toggle').each(function () {
    var $this = $(this), numberOfOptions = $(this).children('option').length;

    $this.addClass('select-hidden');
    $this.wrap('<div class="select hide-desktop"></div>');
    $this.after('<div class="select-styled hide-desktop"></div>');

    var $styledSelect = $this.next('div.select-styled');
    $styledSelect.text($this.children('option').eq(0).text());

    var $list = $('<ul />', {
      'class': 'select-options'
    }).insertAfter($styledSelect);

    for (var i = 0; i < numberOfOptions; i++) {
      $('<li />', {
        text: $this.children('option').eq(i).text(),
        rel: $this.children('option').eq(i).val()
      }).appendTo($list);
    }

    var $listItems = $list.children('li');

    $styledSelect.click(function (e) {
      e.stopPropagation();
      $('div.select-styled.active').not(this).each(function () {
        $(this).removeClass('active').next('ul.select-options').hide();
      });
      $(this).toggleClass('active').next('ul.select-options').toggle();
    });

    $listItems.click(function (e) {
      e.stopPropagation();
      $('.city-info > div').addClass('hide');
      $styledSelect.text($(this).text()).removeClass('active');
      $this.val($(this).attr('rel'));
      $('.' + $(this).attr('rel')).removeClass('hide');
      $list.hide();
    });

    $(document).click(function () {
      $styledSelect.removeClass('active');
      $list.hide();
    });

  });


  if ($('main.page-shri-mataji').length) {
    if (window.matchMedia("(max-width: 1440px)").matches) {
      $('.s__articles').add('.s_together').attr("data-wow-offset", "-600");
      $('.s__articles .article__item').attr("data-wow-offset", "-800")
    } else {
      $('.s__articles').add('.s_together').removeAttr("data-wow-offset")
    }
  }


  var set = 1;

  //  Chapter Nav
  if ($('main.page-article').length) {

    if (window.matchMedia("(max-width: 1440px)").matches) {
      $('.page-article .s_together').attr("data-wow-offset", "-600")
    } else {
      $('.page-article .s_together').removeAttr("data-wow-offset")
    }

    function setGradientWidth(set) {
      $('.chapter-nav').append('<div class="chapter-nav-gradient"></div>');
      $('.chapter-nav-gradient').width(($('.chapter-nav li').outerWidth() * set))
    }

    setGradientWidth(set);


    var lastScrollTop = 0;
    $(document).on("scroll", onScroll);
    $('.chapter-nav a').on('click', function (e) {
      e.preventDefault();
      $(document).off("scroll");
      $('.chapter-nav a').each(function () {
        $(this).removeClass('active');
      });
      $(this).addClass('active');
      var target = this.hash,
        $target = $(target),
        targetOffset = $target.offset().top;
      targetOffset -= 200;
      $('html, body').animate({scrollTop: targetOffset}, 1000, function () {
        $(document).on("scroll", onScroll);
      });
    });

    function onScroll() {
      var st = $(this).scrollTop();
      var scrollPos = $(document).scrollTop();
      $('.chapter-nav a').each(function () {
        var currLink = $(this),
          refElement = $(currLink.attr("href")),
          currItem = currLink.parent(),
          prevItem = currItem.prev();
        if ((refElement.position().top - 200) <= scrollPos && refElement.position().top + refElement.height() > scrollPos) {
          $('.chapter-nav a').removeClass("active");
          currLink.addClass("active");
          if (window.matchMedia("(max-width: 459px)").matches) {
            //  Check scroll direction
            if (st > lastScrollTop) {
              prevItem.hide();
              currItem.show();
            } else {
              currItem.next().add(currItem.prev()).hide();
              currItem.show();
            }
            lastScrollTop = st;
          }
        }
        else {
          currLink.removeClass("active");
        }
      });
    }

    var $w = $(window);
    $('.chapter-nav li').each(function () {
      var link = $(this).find('a'),
        itemProgressIndicator = link.next(),
        itemID = link.attr('href'),
        sectionHeight = $(itemID).outerHeight(true),
        sectionPosition = $(itemID).position().top;
      $w.on('scroll', function () {
        if ($w.scrollTop() <= sectionPosition + sectionHeight) {
          itemProgressIndicator.css({
            width: (Math.max(0, Math.min(1, (($w.scrollTop() + 200) - sectionPosition) / sectionHeight))) * 100 + '%'
          });
        } else {
          itemProgressIndicator.css('width', "100%");
        }
      });
    });

    //  Sticky Chapter Nav
    $('.chapter-nav-wrapper').stick_in_parent({
      offset_top: 85
    });
  }

  //  Change Header Color
  if (!($('header').hasClass('gray'))) {
    var $header = $('.header');
    var $win = $(window);
    var winH = $win.height();
    $win.on("scroll", function () {
      ($(this).scrollTop() > winH) ? $header.addClass('gray') : $header.removeClass('gray');
    }).on("resize", function () {
      winH = $(this).height();
    });
  }

  //  Burger Menu
  $('.burger__button').on('click', function (e) {
    e.preventDefault();
    $(this).toggleClass('open');
    $('.header__nav').slideToggle();
    $('header').toggleClass('wide-header');
    $('.chapter-nav-wrapper').toggleClass('wide-chapter');
    return false;
  });

  //  Sticky Header
  $(window).scroll(function () {
    var winTop = $(window).scrollTop();
    if (winTop >= 30) {
      $("body").addClass("sticky-header");
      if (!$('.burger__button').hasClass('open')) {
        $('.header__nav').fadeOut();
        $('.header__breadcrumbs').addClass('hidden');
      }

      if (window.matchMedia("(max-width: 459px)").matches) {
        $('header').addClass('gray')
      }
    } else {
      $("body").removeClass("sticky-header");
      $('.header__nav').fadeIn();
      $('.header__breadcrumbs').removeClass('hidden')
    }//if-else
  });//win func.

  //  Plyr Controls
  var controls = [
    "<button type='button' data-plyr='play' class='plyr__play-large' aria-label='Play'><svg viewBox=\"0 0 105 105\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"m0 0h105v105h-105z\" fill=\"#c5e0dc\"/><path d=\"m48.67 64.49v-23.76l11.14 11.88z\" fill=\"#fff\"/></svg><span class='plyr__sr-only'>Play</span></button>",
    "<div class='plyr__controls'>",
    "<button type='button' data-plyr='play'>",
    "<svg viewBox=\"0 0 11 22\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"m0 0v22l11-11z\" fill=\"#fff\"/></svg>",
    "<span class='plyr__sr-only'>Play</span>",
    "</button>",
    "<button type='button' data-plyr='pause'>",
    "<svg height=\"18\" viewBox=\"0 0 10 18\" width=\"10\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#fff\"><path d=\"m0 0h1v18h-1z\"/><path d=\"m9 0h1v18h-1z\"/></g></svg>",
    "<span class='plyr__sr-only'>Pause</span>",
    "</button>",
    "<span class='plyr__progress'>",
    "<label for='seek{id}' class='plyr__sr-only'>Seek</label>",
    "<input id='seek{id}' class='plyr__progress--seek' type='range' min='0' max='100' step='0.1' value='0' data-plyr='seek'>",
    "<progress class='plyr__progress--played' max='100' value='0' role='presentation'></progress>",
    "<progress class='plyr__progress--buffer' max='100' value='0'>",
    "<span>0</span>% buffered",
    "</progress>",
    "<span class='plyr__tooltip'>00:00</span>",
    "</span>",
    "<span class='plyr__time'>",
    "<span class='plyr__sr-only'>Current time</span>",
    "<span class='plyr__time--current'>00:00</span>",
    "</span>",
    "<button type='button' data-plyr='mute'>",
    "<svg class='icon--muted' enable-background=\"new 0 0 17 19.8\" viewBox=\"0 0 17 19.8\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"m0 5.9v8.1h3.3l7.4 5.9v-19.9l-7 5.9zm1 7.1v-6.1h2.1v6.1zm8.7 4.8-5.6-4.5v-6.4l5.6-4.7z\" fill=\"#fff\"/></svg>",
    "<svg viewBox=\"0 0 17 19.83\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#fff\"><path d=\"m12.92 7.28h1v5.32h-1z\"/><path d=\"m16 5.06h1v9.75h-1z\"/><path d=\"m10.5 15v8.09h3.32l7.4 5.85v-19.85l-7 5.89zm1 7.09v-6.09h2.1v6.09zm8.72 4.78-5.62-4.46v-6.41l5.61-4.72z\" transform=\"translate(-10.5 -9.09)\"/></g></svg>",
    "<span class='plyr__sr-only'>Toggle Mute</span>",
    "</button>",
    "<span class='plyr__volume'>",
    "<label for='volume{id}' class='plyr__sr-only'>Volume</label>",
    "<input id='volume{id}' class='plyr__volume--input' type='range' min='0' max='10' value='5' data-plyr='volume'>",
    "<progress class='plyr__volume--display' max='10' value='0' role='presentation'></progress>",
    "</span>",
    "<button type='button' data-plyr='fullscreen'>",
    "<svg class='icon--exit-fullscreen' viewBox=\"0 0 18 18\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"#fff\"><path d=\"m4.5 4.5h-4.5v-1h3.5v-3.5h1z\"/><path d=\"m4.5 18h-1v-3.5h-3.5v-1h4.5z\"/><path d=\"m14.5 18h-1v-4.5h4.5v1h-3.5z\"/><path d=\"m18 4.5h-4.5v-4.5h1v3.5h3.5z\"/></g></svg>",
    "<svg height=\"18\" viewBox=\"0 0 18 18\" width=\"18\" xmlns=\"http://www.w3.org/2000/svg\"><g fill=\"none\" stroke=\"#fff\"><path d=\"m5 1h-4v4\"/><path d=\"m1 13v4h4\"/><path d=\"m13 17h4v-4\"/><path d=\"m17 5v-4h-4\"/></g></svg>",
    "<span class='plyr__sr-only'>Toggle Fullscreen</span>",
    "</button>",
    "</div>"].join("");

  // Setup the player
  plyr.setup('video', {
    html: controls
  });

  if (window.matchMedia("(max-width: 459px)").matches) {
    $('.s-life .text-box').add('.s-ancient .text-box').removeClass('inverse');
    $('.map-popup').hide();
    $('a.marker').click(function (e) {
      e.preventDefault();
      e.stopPropagation();
      $(this).next('.map-popup').show().removeClass('open');
      $(this).parent().siblings().children('.map-popup').hide().removeClass('open');
    });
    $(document).click(function () {
      $('.map-popup').hide().removeClass('open');
    });

    $(".chapter-nav li").slice(0, 1).show().css('display', 'flex');
  }

  //  MAP MARKER
  var $pop = $('.map-popup');
  $pop.click(function (e) {
    e.stopPropagation();
  });

  $('a.marker').click(function (e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).next('.map-popup').toggleClass('open');
    $(this).parent().siblings().children('.map-popup').removeClass('open');
  });

  $(document).click(function () {
    $pop.removeClass('open');
  });

  // Read More
  $(".methods__container .item").slice(0, 2).show().css('display', 'flex');
  $(".btn__more-methods").on('click', function (e) {
    e.preventDefault();
    $(".methods__container .item:hidden").slice(0, 2).slideDown('slow').css('display', 'flex');
    if ($(".methods__container .item:hidden").length == 0) {
      $(".btn__more-methods").fadeOut('slow');
      $('.methods__container .item').removeClass('mb-150');
    }
    $('html,body').animate({
      scrollTop: $(this).offset().top
    }, 1500);
  });

  //  Full List
  $(".page-shri-mataji .article__item").slice(0, 3).show();
  $(".page-shri-mataji .loadmore").on('click', function (e) {
    e.preventDefault();
    $(".page-shri-mataji .article__item:hidden").slice(0, 6).fadeIn('slow');
    if ($(".methods__container .item:hidden").length == 0) {
      $(".page-shri-mataji .loadmore").fadeOut('slow');
    }
  });


  //  Init Video Popup
  var videoPoster, videoSource, $videoContainer, vid;
  $videoContainer = $('#video-popup video');
  vid = document.getElementById("#custom-video");

  $('.video-link').on('click', function () {
    $videoContainer.attr('poster', $(this).data('poster'));
    $videoContainer.find('source').attr('src', $(this).data('source'));
    $('.plyr-video-title').text($(this).data('title'));
    vid.load();
  });

  $('.popup-with-zoom-anim').magnificPopup({
    type: 'inline',
    fixedContentPos: true,
    fixedBgPos: true,
    overflowY: 'auto',
    closeBtnInside: true,
    preloader: false,
    midClick: true,
    removalDelay: 300,
    mainClass: 'my-mfp-zoom-in',
    callbacks: {
      close: function () {
        vid.currentTime = 0;
      }
    }
  });

  $('.plyr--video .plyr__controls button[data-plyr="pause"]').after('<span class="plyr-video-title"><span');


  //  Chakras & Channels Trigger
  var currentItems = '', triggerItems = $('.trigger-item');

  triggerItems.on('mouseover', function () {
    $(currentItems).stop().fadeOut('slow').removeClass('active');
    var currentClass = $(this).data('class');
    currentItems = '.' + currentClass;
    setTimeout(function () {
      $(currentItems).stop().fadeIn('slow').addClass('active');
    }, 300)
  });

  if ($('main.page-chakras-channels').length) {
    if (window.matchMedia("(max-width: 460px)").matches) {
      triggerItems.on('touchstart', function () {
        setTimeout(function () {
          $('body,html').stop().animate({scrollTop: 400}, 1000);
        }, 300)
      })
    }
  }

  //  Tabs
  function tabsContainer() {
    $('.tab-content').hide();
    $('.tab-content:first').show();
    $('.tabs li:first').addClass('active');

    $('.tabs li').on('click', function (e) {
      e.preventDefault();
      $('.tabs li').removeClass('active');
      $(this).addClass('active');
      $('.tab-content').hide();

      var selectTab = $(this).find('a').attr('href');
      $(selectTab).fadeIn();

      if (window.matchMedia("(max-width: 460px)").matches) {
        $('body,html').animate({scrollTop: 0}, 1000);
      }
    });
  }

  tabsContainer();

  //  SVG img-parser
  $('img.svg').each(function () {
    var $img = jQuery(this);
    var imgID = $img.attr('id');
    var imgClass = $img.attr('class');
    var imgURL = $img.attr('src');
    jQuery.get(imgURL, function (data) {
      // Get the SVG tag, ignore the rest
      var $svg = jQuery(data).find('svg');
      // Add replaced image's ID to the new SVG
      if (typeof imgID !== 'undefined') {
        $svg = $svg.attr('id', imgID);
      }
      // Add replaced image's classes to the new SVG
      if (typeof imgClass !== 'undefined') {
        $svg = $svg.attr('class', imgClass + ' replaced-svg');
      }
      // Remove any invalid XML tags as per http://validator.w3.org
      $svg = $svg.removeAttr('xmlns:a');
      // Replace image with new SVG
      $img.replaceWith($svg);
    }, 'xml');
  });

  // Player Choose Mood
  $('.s__music .btn').each(function () {
    $(this).on('click', function (e) {
      e.preventDefault();
      $('.s__music .btn').removeClass('active');
      var item = $(this);
      item.addClass('active');
      $('.mood-text').text(item.text());
    })
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
    e.preventDefault();
    var self = $(this);
    $(this).toggleClass('active');
    $(this).hasClass('active') ? addIcon(true, self) : addIcon(false, self);
  });


  var beforeClick = false,
    beforeClass = false;
  // Mobile Menu
  $('.mobile-menu__btn').on('click', function () {
    $('.mobile-menu').toggleClass('mobile-menu_open');
    $('html, body').toggleClass('overflowHidden');
    $(this).add('.container.mobile .logo').toggleClass('z-index');
    beforeClick = !beforeClick;
    // (beforeClick) ? $('header').toggleClass('gray') console.log('open'): $('header').removeClass('gray')
    if (beforeClick) {
      console.log(beforeClick, 'if');
      beforeClass = ($('header').hasClass('gray'));
      console.log(beforeClass, 'beforeClass');
      if (!beforeClass) {
        $('header').addClass('gray')
      }
    } else {
      if (!beforeClass) {
        $('header').removeClass('gray')
      }
    }
  });

  // Filter Menu
  var filterMnu = new filterMenu('.filter__btn_open', '.filter__menu', '.icon-close-icon');

  function filterMenu(sBtn, sMenuContainer, sClose) {
    var button = $(sBtn),
      menu = $(sMenuContainer),
      close = menu.find(sClose),
      item = menu.find('.filter__btn'),
      container = $('.mobile__filter_container .filter__btn');
    var show = function () {
        $(this).removeClass('active');
        menu.addClass('filter__menu_open');
        $('html, body').addClass('overflowHidden');
        item.each(function () {
          ($(this).text() === container.text()) ? $(this).addClass('active') : $(this).removeClass('active');
          $(this).on('click', function (e) {
            e.preventDefault();
            container.html($(this).text());
            menu.removeClass('filter__menu_open');
            $('html, body').removeClass('overflowHidden');
          })
        });
      },
      hide = function () {
        menu.removeClass('filter__menu_open');
        $('html, body').removeClass('overflowHidden');
      };
    button.bind('click', show);
    close.bind('click', hide);
  }

  // Toggle Filter Class
  $('.filter__btn').each(function () {
    $(this).on('click', function (e) {
      $('.filter__btn').removeClass('active');
      e.preventDefault();
      $(this).addClass('active');
    })
  });

  //Smooth Scroll to anchor
  $(".smooth").on("click", function (event) {
    event.preventDefault();
    var id = $(this).attr('href'),
      top = $(id).offset().top;
    top -= 100;
    $('body,html').animate({scrollTop: top}, 1000);
  });


  $('.shri-mataji .section_btn').on('click', function () {
    $(this).toggleClass('active')
  });

  // OwlCarousel
  $(".carousel-video").owlCarousel({
    center: true,
    loop: true,
    nav: true,
    dots: false,
    video: true,
    margin: 60,
    autoWidth: true,
    smartSpeed: 700,
    navText: ['<i class="icon-arrow-left"></i>', '<i class="icon-arrow-right"></i>'],
    responsiveClass: true,
    responsive: {
      0: {
        items: 1
      },
      768: {
        items: 1
      },
      992: {
        items: 1
      },
      1400: {
        items: 3
      }
    }

  });

  $('.owl-pagination .owl-page, .owl-buttons div').on('click', function () {
    $('.owl-item div').css('height', $('.owl-item div').css('height'));
  });


  // SVG Vivus Animation
  $('.footer__illustration').each(function (i) {
    var el = $(this).attr('id', 'footer_custom_' + i),
      path = 'img/svg/' + $(this).attr('class') + '.svg';
    //new Vivus(el.attr('id'), {duration: 200, file: path});
  });

  $('.img__circle').each(function (i) {
    var el = $(this).attr('id', 'img__circle_' + i),
      path = 'img/svg/' + $(this).attr('class') + '.svg';
    //new Vivus(el.attr('id'), {duration: 200, file: path});
  });

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
});

//  ON ORIENTATION CHANGE
$(window).on('orientationchange', function () {
  $(".container").each(function (index, domEle) {
    var textWidth = $('.text-width', this).outerWidth();
    var containerHeight = $(this).height();
    $(".s_title", this).css("min-width", containerHeight);
    $(this).css("min-height", textWidth);
  });

  $('.article_technique .article__image').each(function () {
    $(this).height($(this).width());
  })
});

//  ON RESIZE ON RELOAD
$(window).on('resize load', function () {

  if ($('main.page-main').length || $('main.page-meditate').length) {
    if (window.matchMedia("(min-width : 992px) and (max-width : 1400px)").matches) {
      $('.header, .s__hero .container').addClass('zoom')
    } else {
      $('.header, .s__hero .container').removeClass('zoom')
    }
  }


  $('.article_technique .article__image').each(function () {
    $(this).height($(this).width());
    $(this).width($(this).height());
  });

  $(".container").each(function (index, domEle) {
    var textWidth = $('.text-width', this).outerWidth();
    var containerHeight = $(this).height();
    $(".s_title", this).css("min-width", containerHeight);
    $(this).css("min-height", textWidth);
  });

  // Equal height
  function equalItems() {
    $(".meditate-why .item-equal").equalHeights();
  }

  equalItems();

  if (matchMedia('only screen and (min-device-width : 320px) and (max-width : 1023px)').matches) {
    var items = $('.intro-grid .item'); // delete animation delay
    items.each(function () {
      $(this).removeAttr("data-wow-delay");
      $(this).data();
    });

    initChakrasSlider();
  }


  if (matchMedia('only screen and (min-width : 768px) and (max-width : 1024px)').matches) {
    // Change Device Orientation
    $(window).on('orientationchange', function (event) {
      (orientation === -90 || orientation === 90) ? destroyChakrasSlider() : initChakrasSlider()
    });
  }

  // Scale Pages
  function scale() {
    (matchMedia('only screen and (min-width : 992px) and (max-width : 1400px)').matches && $('.header.gray').length) ? $('body').addClass('zoom') : $('body').removeClass('zoom')
  }

  scale();

  // AutoMargin
  function AutoMargin(sSelector) {
    var element = $(sSelector),
      elementHeight = element.height(),
      textHeight = element.find('.article__text').height(),
      margin = elementHeight + textHeight;
    element.css('margin-bottom', margin)
  }

  if (matchMedia('only screen and (max-width: 480px) and (orientation:portrait)').matches) {
    $('.s__howto .article').removeClass('article_inversion').removeClass('draw-line');
    AutoMargin('.s__howto');
    AutoMargin('.s__mataji');
    AutoMargin('.s__sahaja');
  }
  else {
    $('.s__howto .article').addClass('article_inversion').addClass('draw-line');
    $('.s__mataji').css('margin-bottom', '');
    $('.s__howto').css('margin-bottom', '');
    $('.s__sahaja').css('margin-bottom', '');
  }

  // Change Header Bg On Mobile
  if ($(window).width() <= 480) {
    $('.s_video').addClass('has__gradient_blue');
    $('.s-sahaja .container-text').removeClass('container-text-inverse');
    var items = $('.intro-grid .item'); // delete animation delay
    items.each(function () {
      $(this).removeAttr("data-wow-delay");
      $(this).data();
    });
  } else {
    $('.s__meditate .container').removeClass('has__triangle has__triangle_right');
    $('.s__mataji').css('margin-bottom', '');
  }
});


var chakrasContainer = $('.chakra-desc__container');

function destroyChakrasSlider() {
  chakrasContainer.trigger('destroy.owl.carousel');
}

function initChakrasSlider() {
  chakrasContainer.owlCarousel({
    loop: true,
    margin: 10,
    responsiveClass: true,
    navText: ['<i class="icon-arrow-left"></i>', '<i class="icon-arrow-right"></i>'],
    responsive: {
      0: {
        items: 1,
        nav: true
      },
      1024: {
        items: 1,
        nav: true
      }
    }
  });
}


$(document).on('turbolinks:load', function() {

  //  Preloader
  $('body').addClass('fixed');
  $('.preloader').delay(1000).fadeOut('slow', function () {
    $('body').removeClass('fixed');
  });

  var $volwr = $('.volume-wrap input[type="range"]');
  var val = $volwr.val();
  var buf = ((100 - val) / 4) + parseInt(val);
  $volwr.css(
    'background',
    'linear-gradient(to right, #C5E0DC 0%, #C5E0DC ' + val + '%, #eee ' + val + '%, #eee ' + buf + '%, #eee ' + buf + '%, #eee 100%)'
  );

  function fullScreenArticle(sSelector) {
    var element = $(sSelector),
      text = element.find('.container-text').html();
    element.after('<div class="helper">' + text + '</div>');
  }

  if (matchMedia('only screen and (max-width: 767px)').matches) {
    fullScreenArticle('.s-sahaja');
  }

  var circle = $('.img__circle').attr('id', 'circle_new'),
    circleId = circle.attr('id');

  // Chakras Animation
  function svgAnimation() {
    var lineHeight = $('.yoga-line').outerHeight();
    TweenMax.to($('.yoga-line'), 2, {height: '100%'});
    var timer;
    timer = setInterval(function () {
      var lineHeightInterval = $('.yoga-line').height();
      $('.yoga-circle').each(function () {
        if ($('.yoga-line').outerHeight() !== lineHeight) {
          if (Math.round(lineHeightInterval) > Math.round($('.yoga-mask').outerHeight() - $(this).position().top)) {
            TweenMax.to($(this), .5, {opacity: 1});
          }
        }
      });
      if (lineHeightInterval > $('.yoga-mask').outerHeight()) clearInterval(timer);
    }, 1);
  }

  //  WOW JS
  setTimeout(function () {
    var e = new WOW({
      boxClass: "wow",
      animateClass: "animated",
      offset: 0,
      mobile: !0,
      live: !0,
      callback: function (e) {
        if ($(e).hasClass('draw-line')) {
          setTimeout(function () {
            $(e).addClass('active');
          }, 1500);

        } else if ($(e).hasClass('btn__container')) {
          setTimeout(function () {
            $(e).removeClass('wow fadeIn');
            $(e).addClass('animated infinite pulse').css('animation-name', 'pulse');
          }, 5000);
        } else if ($(e).hasClass('chakras_wrapper')) {
          setTimeout(function () {
            svgAnimation();
          }, 1500);
        }
      },
      scrollContainer: null
    });
    e.init();
  }, 500);
});

