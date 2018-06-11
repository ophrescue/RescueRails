var webpackConfig = require('./config/webpack/test.js')

module.exports = function(config) {
  config.set({
    frameworks: ['mocha'],

    files: [
      'spec/javascript/**/*.spec.js'
    ],

    preprocessors: {
      '**/*.spec.js': ['webpack', 'sourcemap']
    },

    webpack: webpackConfig,

    reporters: ['spec', 'coverage'],

    coverageReporter: {
      dir: './coverage',
      reporters: [
        { type: 'lcov', subdir: '.' },
        { type: 'text-summary' }
      ]
    },

    browsers: ['jsdom'],
  })
}
