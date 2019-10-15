The WeMeditate project is comprehensive website promotig the practice of meditation through the techniques of Sahaja Yoga meditation. This website is designed to be translated to almost any language world wide and provide the following features:
 - **Guided meditations**, which can be generated based on your goal and available time.
 - **Meditation music**, by various musicians with different styles and instruments.
 - **Inspirational articles** related to meditation, spirituality, and creativity.
 - **Informative articles** about the benefits of meditation, and answering common questions about meditation. These will appear in the Inspiration section alongside the inspirational articles.
 - **Techniques** for helping enter the state of meditation, and clearing imbalances.
 - **In-depth pages** on chakras, the kundalini, the subtle subtle system, Sahaja Yoga, Shri Mataji, etc. These are available under the "Learn More" tab
 - **Map of free meditation classes worldwide**, this feature is still under construction.

Knowing the above features will also help one understand broadly what is going on in the code.

# Getting Started
There are several concepts which are common throughout the codebase that it will help to be aware of.

## Setup
- Install Postgres on your computer (for Mac, I recommend [Postgress.app](https://postgresapp.com)), for windows you can try the [official installer](https://www.postgresql.org/download/windows/).
- Clone this repository
- Run `rails db:setup` to create and populate the database.
- Run `rails server` to run the server.

Once the server is running you should be able to can access these urls
 - [localhost:3000](http://localhost:3000) for the english website
 - [ru.localhost:3000](http://ru.localhost:3000) for the russian website
 - [it.localhost:3000](http://it.localhost:3000) for the italian website
 - [admin.localhost:3000](http://admin.localhost:3000) for the admin site

When accessing the admin site you will be asked to login, in the development environment you can use a simple dropdown (shown under the login window) to select which account you want to be logged in as, without having to enter a password.

## Framework & Languages
 - **Ruby on Rails** is our core server framework. If you are not familiar with Ruby, I recommend looking through [this summary](https://learnxinyminutes.com/docs/ruby/) of how to do standard programming things in Ruby.
 - **Postgres** is our database architecture. However, Rails takes care of almost all the details of this, so 
 - **Vanilla JavaScript** is used for client side programming. jQuery is currently included as well, but we prefer not to use it when it can be avoided.
 - **Sass** is used for stylesheets. Sass is basically the same as CSS, but has a more clean syntax and allows you to use variables and basic functions. Otherwise it uses all the same selectors and attributes as CSS. We also use a library called [Autoprefixer](https://github.com/ai/autoprefixer-rails), which automatically add any necessary prefixes (like `-webkit-`) to your CSS rules. So it is not necessary for you to add these yourself. [Sass Documentation](https://sass-lang.com/guide).
 - **Slim** is used for HTML markup. As Sass does for CSS, Slim does for HTML. It creates a cleaner markup to allow us to write HTML more easily. [Slim Documentation](http://slim-lang.com).

## Concepts
There are a few pointers that it will be helpful to know when navigating the codebase.

 - Every page and piece of content is translatable.
 - Each page on the public site is built usinng a set of 11 interchanngeable blocks, each of which can be further customized.
 - Videos are always hosted on Vimeo.
 - Most models can have their attributes drafted and reviewed before being published.
 - We support only the most recent versions of Chrome, Safari, Firefox, Edge, and Opera - including the mobile versions of these browsers. No other browser is officially supported. Internet Explorer is not supported.

## Models
Each model corresponds to a table in the database, and collectively these form the core of the website's content. Here is a brief overview of the models used in this site, and how they correspond to site features.

#### Pages
 - **Article**, these create the main blog feature which is present on the "Inspiration" page.
 - **SubtleSystemNode**, these defined the contnent of the pages for each chakra and channel.
 - **StaticPage**, any page on the site which doesn't directly represent a model is controlled by a Static Page model. For example: home page, inspiration page, subtle system page, classes near me, contact us, sahaja yoga page, shri mataji page, etc.

#### Resources
 - **Meditation**, a guided meditation with an associated video and a brief description
 - **Track**, a musical track for the music player.
 - **Treatment**, a meditation technique which are shown in the "Improving Meditation" section.

#### Filters
These are used to categorize other types of models
 - **Category**, groups articles by topic.
 - **DurationFilter**, groups meditations into approximate durations (eg. 5 minutes, 10 minutes, 15 minutes).
 - **GoalFilter**, groups guided meditations by what they focus on.
 - **Artist**, groups music tracks by who performed them.
 - **InstrumentFilter**, groups music tracks by which instruments are used.
 - **MoodFilter**, a currently disabled feature which used to group music tracks by their general mood.

#### People
 - **User**, anybody who can login and modify the site's content is a user.
 - **Author**, this model defined a picture and short bio for the author of any given article. It can also be associated with a "User" (aka admin), so that we can track which users wrote which articles.

## Code Structure
This is mainly useful for those who are not already familiar with Ruby on Rails. This is just a quick overview of the most important folders and files to help you find what you're looking for.

- `/app` - the core files that make this website happenn
  - `/assets` - images, fonts, javascript, and css
    - `/fonts` - custom fonts for the site
    - `/images` - all images used by the site
    - `/javascripts/admin` - javascript for the site's admin interface
    - `/javascripts/front` - javascript for the public-facing website
    - `/stylesheets/admin` - sass for the site's admin interface
    - `/stylesheets/front` - sass for the public-facing website
    - `/stylesheets/mixins` - common sass variables and functions which are shared between the public-site and admin interface.
  - `/controllers` - contains the classes which handle the URL endpoints that are set up in `/config/routes.rb`
  - `/helpers` - extra methods that can be used in the "view" files.
  - `/models` - the classes that handle access to the database.
    - `/concerns` - small independent bits of functionality that are shared across multiple models
  - `/policies` - defines the rules for what actions a logged-in user can take in the site.
  - `/uploaders` - configuration for different kinds of image uploads
  - `/views` - where we render html
- `/db/migrate` - where we define changes to the database
- `/config` - overall configurationn of the project
  - `/locales` - translation files for every language.
  - `/routes.rb` - defines the URLs that our server accepts
- `/public` - contains files that can be accessed simply by adding their path to the end of the website's url.
- `/Gemfile` - this file defines the Ruby packages which get bundle and installed with the server.

# External Libraries and Services
If you are implementing a new feature that touches on one of these areas, please use the existing integration or library.

## Libraries
This is a list of some of the key libraries that are used to manage major features.

*Ruby Gems:*
 - *Devise*, user login
 - *Regulator*, user permissions
 - *Globalize*, model translations
 - *CarrierWave*, file uploads

*JavaScript Libraries:*
 - *EditorJS*, block-based content editing
 - *Afterglow*, html5 video player
 - *Amplitude*, audio player
 - *Macy*, creates masonry-like grid layouts
 - *Lity*, lightbox (deprecated)
 - *Zenscroll*, smooth scrolling

## Services
This is a list of all external services used by the WeMeditate project.

This list is provided for reference, to help track down various parts of the site.

 - *Heroku*, server hosting
 - *Google Cloud Storage*, file storage
 - *Vimeo*, video storage
 - *G Suite For Business*, for an email inbox to send emails from
 - *Klaviyo*, for mailing list campaigns
 - *Google Analytics*, to track website traffic
 - *Google Tag Manager*, to embed analytics and klaviyo, and implement custom analytics events
 - *SY Directory*, for a map of meditation programs worldwide (not yet implemented)
 - *Namecheap*, for domain name registration
 - *Rollbar*, for error tracking

G Suite and Namecheap may only be accessed with the sydevelopers.com account, but all other accounts can be set up for people to use their personal accounts.

All accounts are managed and billed by the sydevelopers.com account.
