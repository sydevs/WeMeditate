
Translation Instructions
------------------------

You have been asked to translate the interface of the WeMeditate website. This includes translation for both admin interface and the public facing interface.

Below are instructions to help you understand the translation files.

### Overview of Files

These translations are broken into a few files.
 - _en.admin.yml_ - defines translations for the administrator sections of the website, where website content can be edited.
 - _en.front.yml_ - defines translations for the public facing parts of the website
 - _en.resources.yml_ - defines translations for the various resources which are used on the website, such as Articles, Guided Meditations, Music Tracks, etc. These translations are used both for the admin interface, and the public facing parts of the website.
 - _en.extensions.yml_ - defines translations for some addons which are used by the website.
 - _routes.yml_ - defines translations for the website's URLs
 - _social.yml_ - allows us to configure different social media URLs for different languages.

'en' in the above file names indicates the language for the translation (in this case english). If you were translating for Italian, it would be 'it' instead ('ru' for Russian, 'de' for German, etc)

### Structure of Each File

Each file will have a structure which will looks something like this

```
en:
  admin:
    actions:
      show: View
      cancel: Cancel
      save_for_later: Save for later
```

In the above case, we want to translate the phrases "View", "Cancel", "Save for later", the other parts of the file are used to group the translations together.
 - `en` indicates these translations are for the english language
 - `admin` indicates these translations for the administrator part of the website
 - `actions` indicates a group of translations which are related to admin actions.
 - `show` is the actual action we need a translation for
 - `View` is the actual translation. This is the only part that you need to translate.

So when you go through these files, what we want is for you to translate any text which appears after the first ':' symbol on each line.

#### Other Special Symbols (Do Not Translate)

There are a few other special symbols that you might see in the translation files which do not need translation
 - `%{value}` - *Do not translate* any text which is wrapped in these symbols `%{}`. When the translation is used, the `%{value}` will be replaced with some other appropriate text.
   - For example "Save %{page}" will become "Save Article", or "%{count} words" might become "5 words". We have tried to make these special symbols descriptive (so that you can understand when the result will be plural or singular). Other symbols you might see include: `%{count}`, `%{page}`, `%{pages}`, `%{person}`, `%{people}`, `%{record}`, `%{records}`
 - `# Comment` - *Do not translate* any text appearing after a '#' symbol. This is a comment which we have left to help you understand the context of the translation.
 - `:activerecord.models.articles.one` - sometimes you will see a translation which begins with the ':' symbol (eg. `save: :activerecord.save`). This does not need to be translated, and there will be a comment to remind you not to translate it. This special symbol tells the website to look in another place for the correct translation.

In general, follow the comments throughout the translation files and you should be able to manage.

### Other notes

 - It is typically a good idea to use the same style of capitalization as has been used in the English translation. Especially in the _en.admin.yml_ file you will find a lot of capitalized words because most of the translations are for titles and buttons.
 - When translating a phrase which includes a number, such as "1", it is usually best to keep the number ("1") instead of replacing it with a word ("One"). Especially in the _en.admin.yml_ file.