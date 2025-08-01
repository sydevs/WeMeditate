# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Setup & Dependencies
```bash
# Install Ruby dependencies
bundle install

# Install Node dependencies
yarn install

# Setup database (create, migrate, seed)
rails db:setup

# Run database migrations
rails db:migrate
```

### Development Server
```bash
# Start Rails server (http://localhost:3000)
rails server

# Run webpack dev server in separate terminal for auto-reloading
bin/webpack-dev-server

# Or compile assets once
bin/webpack
```

### Rails Commands
```bash
# Rails console
rails console

# Generate models/controllers/migrations
rails generate model ModelName
rails generate controller ControllerName
rails generate migration MigrationName

# Routes information
rails routes | grep pattern

# Database operations
rails db:create
rails db:drop
rails db:reset  # drop, create, migrate, seed
```

### Custom Rake Tasks
```bash
# Decay meditation popularity scores (scheduled task)
rails wm:decay_popularity

# Reload Vimeo metadata for meditations
rails wm:vimeo:reset:meditations
```

## High-Level Architecture

### Multi-Tenant CMS Structure
This is a multilingual meditation website with a sophisticated CMS. The application serves content in 19 languages and has two main interfaces:

1. **Public Website** - Accessed via locale-specific paths (e.g., `wemeditate.com/en`, `wemeditate.com/ru`)
2. **Admin CMS** - Accessed via `admin.wemeditate.com/LANGUAGE` for content management

### Key Architectural Patterns

#### 1. Multilingual Content Management
- Uses Globalize gem for model translations
- URL-based locale switching with language-specific routes
- All content models support translations via `translates :field_name`
- Locale determined by URL path (e.g., /en, /ru) in ApplicationController

#### 2. Content Hierarchy
```
Pages (polymorphic)
├── StaticPage (home, about, etc.)
├── Article (blog posts)
├── PromoPage (landing pages)
└── SubtleSystemNode (chakras/channels)

Resources
├── Meditation (guided videos via Vimeo)
├── Track (music/audio)
├── Treatment (techniques)
└── Stream (livestreams)
```

#### 3. Frontend Architecture
- Webpacker bundles with separate entry points:
  - `application.js` - Public site
  - `admin.js` - CMS interface
- Turbolinks for SPA-like navigation
- EditorJS for block-based content editing
- Fomantic UI for admin styling

#### 4. Key Models & Concerns

**Publishable Concern** (`app/models/concerns/publishable.rb`):
- Implements draft/publish workflow
- Manages publication states and timestamps

**Contentable Concern** (`app/models/concerns/contentable.rb`):
- Handles EditorJS block content
- Manages content parsing and rendering

**Translatable Models**:
- Most models use `translates` for multilingual fields
- Translation management through admin interface

#### 5. Admin Interface Structure
```
/admin
├── dashboard
├── pages/ (content management)
├── meditations/ (video content)
├── filters/ (categories, moods, etc.)
├── users/ (user management)
└── settings/ (site configuration)
```

### Important Implementation Details

1. **Locale Routing**: ApplicationController determines locale from URL path (e.g., /en, /ru)
2. **Media Storage**: CarrierWave with Google Cloud Storage for file uploads
3. **Video Integration**: Vimeo API for meditation videos
4. **User Permissions**: Regulator gem manages role-based access
5. **Content Blocks**: EditorJS blocks stored as JSON, rendered via partials
6. **Performance**: Fragment caching, CDN integration, image optimization

### Database Considerations
- PostgreSQL with extensive use of indexes
- Audited gem tracks all model changes
- Friendly ID for SEO-friendly URLs
- Counter caches for performance

### Testing & Development
- Uses Rails default test framework
- Development uses path-based locale routing (e.g., localhost:3000/en)
- Admin interface accessible at admin.localhost:3000/LANGUAGE
- Staging auto-deploys from master branch
- Production requires manual promotion from staging