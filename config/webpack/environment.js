const { environment } = require('@rails/webpacker')
const globCssImporter = require('node-sass-glob-importer')
 
environment.loaders.get('sass')
  .use
  .find(item => item.loader === 'sass-loader')
  .options
  .sassOptions = {
    importer: globCssImporter(),
    sourceMap: true,
    sourceMapContents: false,
  }

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
})

module.exports = environment
