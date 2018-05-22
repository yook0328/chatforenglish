const path = require('path');





module.exports = {
  entry: {
    main: './src/app.js',
    chat: './src/chat.js'
  },
  target: 'electron-main',
  output: {
    path: path.join(__dirname, 'public'),
    filename: '[name].bundle.js'
  },


  module: {
    rules: [{
      loader: 'babel-loader',
      test: /\.js$/,
      exclude: /node_modules/
    }, {
      test: /\.s?css$/,
      use: [
        'style-loader',
        'css-loader',
        'sass-loader'
      ]
    }]
  },
  node: {
    __dirname: false,
    __filename: false,
  },
  devtool: 'cheap-module-eval-source-map',
  devServer: {
    contentBase: path.join(__dirname, 'public'),
    historyApiFallback: true
  }
};

