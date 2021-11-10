const webpack = require("webpack");
const { mergeWithCustomize } = require("webpack-merge");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path");

const isDevelopment = process.env.NODE_ENV === "development";

class ErrorReportingPlugin {
  apply(compiler) {
    compiler.hooks.done.tap("ErrorReportingPlugin", (stats) =>
      process.stderr.write(stats.toString("errors-only"))
    );
  }
}

exports.purescriptRule = (env, pursSources) => {
  const isDevelopment = env === "development";
  return {
    test: /\.purs$/,
    use: [
      {
        loader: "purs-loader",
        options: {
          bundle: !isDevelopment,
          psc: "psa",
          pscArgs: {
            strict: true,
            censorLib: true,
            stash: isDevelopment,
            isLib: [".spago", "generated"],
          },
          spago: isDevelopment,
          src: isDevelopment
            ? []
            : [
                ".spago/*/*/src/**/*.purs",
                "src/**/*.purs",
                "test/**/*.purs",
                "generated/**/*.purs",
                ...pursSources,
              ],
          watch: isDevelopment,
        },
      },
    ],
  };
};

const baseConfig = {
  output: {
    filename: "[name].[contenthash].js",
    pathinfo: true,
  },
  optimization: {
    runtimeChunk: "single",
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: "vendors",
          chunks: "all",
        },
      },
    },
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: "ts-loader",
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, "css-loader", "postcss-loader"],
      },
      {
        test: /\.(png|svg|jpg|jpeg|gif|woff|woff2|eot|ttf|otf)$/i,
        type: "asset/resource",
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: "[name]-[chunkhash].css",
      chunkFilename: "[id].css",
    }),
  ],
  resolve: {
    modules: ["node_modules"],
    extensions: [".purs", ".js", ".ts", ".tsx"],
  },
  resolveLoader: {
    modules: ["node_modules"],
  },
  stats: {
    // Don't print noisy output for extracted CSS children.
    children: false,
  },
};

const developmentConfig = {
  mode: "development",
  devtool: "eval-cheap-source-map",
  devServer: {
    compress: true,
    port: 8009,
    stats: "errors-warnings",
  },
};

const productionConfig = {
  mode: "production",
  devtool: false,
  plugins: [new ErrorReportingPlugin()],
};

function pluginNotOverridden(plugins) {
  return (plugin) =>
    !plugins.some(
      (p) =>
        p.constructor &&
        plugin.constructor &&
        p.constructor === plugin.constructor
    );
}

function ruleNotOverridden(rules) {
  return (rule) =>
    !rules.some(
      (r) => r.test && rule.test && r.test.toString() == rule.test.toString()
    );
}

const merge = mergeWithCustomize({
  customizeArray: (a, b, key) => {
    if (key === "plugins") {
      return a.filter(pluginNotOverridden(b)).concat(b);
    } else if (key === "module.rules") {
      return a.filter(ruleNotOverridden(b)).concat(b);
    }
    return undefined;
  },
});

module.exports.webpackConfig = (options) => (env) => {
  const isProduction = env === "production";
  const NODE_ENV = isProduction ? "production" : "development";
  const environmentConfig = isProduction ? productionConfig : developmentConfig;
  const config = merge(baseConfig, environmentConfig, options(NODE_ENV));
  const extraConfig = {
    plugins: [new webpack.DefinePlugin({ NODE_ENV }), new CleanWebpackPlugin()],
  };
  return merge(config, extraConfig);
};
