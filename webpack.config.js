module.exports = {
  entry: require('glob').sync('./src/**/*.*'),
  output: {
    path: __dirname + '/docs',
    filename: 'bundle.js',
  },
  resolve: {
    extensions: ['.ts', '.js', '.wat'],
    modules: ['node_modules', 'web_modules']
  },
  resolveLoader: {
    modules: ['node_modules', 'web_modules']
  },
  devServer: {
    contentBase: 'docs'
  },
  module: {
    rules: [
      {
        test: /\.ts$/,
        exclude: /(node_modules|web_modules)/,
        loader: 'awesome-typescript-loader'
      },
      {
        test: /\.wat$/,
        exclude: /(node_modules|web_modules)/,
        loader: 'wast-loader'
      }
    ]
  }
};