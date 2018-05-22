const path = require('path');

module.exports = {
    target: 'electron-main',
    entry: './electron/src/index.js',
    output: {
      path: path.join(__dirname, '/electron'),
      filename: 'main.js'
    },
    module: {
      rules: [{
        loader: 'babel-loader',
        test: /\.js$/,
        exclude: /node_modules/
      }]
    },
    node: {
        __dirname: false,
        __filename: false,
      }
  
  };