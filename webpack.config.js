const webpack = require("webpack");
const { merge } = require("webpack-merge");
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

const baseConfig = (pursOptions) => ({
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
        test: /\.purs$/,
        use: [
          {
            loader: "purs-loader",
            options: merge(
              {
                psc: "psa",
                pscArgs: {
                  strict: true,
                  censorLib: true,
                  stash: isDevelopment,
                  isLib: [".spago", "generated"],
                },
              },
              pursOptions
            ),
          },
        ],
      },
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
});

const developmentConfig = merge(
  baseConfig({
    psc: "psa",
    spago: true,
    watch: true,
  }),
  {
    mode: "development",
    devtool: "eval-cheap-source-map",
    devServer: {
      compress: true,
      port: 8009,
      stats: "errors-warnings",
    },
  }
);

const productionConfig = (pursSources) =>
  merge(
    baseConfig({
      bundle: true,
      psc: "psa",
      src: [".spago/*/*/src/**/*.purs", "src/**/*.purs", ...pursSources],
    }),
    {
      mode: "production",
      devtool: false,
      plugins: [new ErrorReportingPlugin()],
    }
  );

module.exports = (pursSources, options) => (env) => {
  const isProduction = env === "production";
  const NODE_ENV = isProduction ? "production" : "development";
  const environmentConfig = isProduction
    ? productionConfig(pursSources)
    : developmentConfig;
  const config = merge(baseConfig, environmentConfig, options(NODE_ENV));
  const extraConfig = {
    plugins: [new webpack.DefinePlugin({ NODE_ENV }), new CleanWebpackPlugin()],
  };
  return merge(config, extraConfig);
};
