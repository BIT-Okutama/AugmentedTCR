module.exports = {
    entry: './src/AugTCR.js',
  
    output: {
        path: __dirname + '/dist',
        filename: 'bundle.js'
    },

    module:{
        rules: [

        {
            test: /\.js$/,
            exclude: /node_modules/,
            use: [ 'babel-loader' ]
        }

        ]
    }

}