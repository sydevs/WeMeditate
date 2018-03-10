# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

include Sprig::Helpers
Globalize.locale = :en

sprig User
sprig_shared [
  StaticPage, Category, Article, City, Section, Treatment,
  Artist, MoodFilter, InstrumentFilter, Track,
  DurationFilter, GoalFilter, Meditation
]
