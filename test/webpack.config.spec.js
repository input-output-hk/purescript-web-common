const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const { customizeArray, mergeWithCustomize } = require("webpack-merge");
const { purescriptRule, webpackConfig } = require("../webpack.config");

describe("purescriptRule", () => {
  it("Adds the production config", () => {
    expect(purescriptRule("production", [])).toMatchInlineSnapshot(`
      Object {
        "test": /\\\\\\.purs\\$/,
        "use": Array [
          Object {
            "loader": "purs-loader",
            "options": Object {
              "bundle": true,
              "psc": "psa",
              "pscArgs": Object {
                "censorLib": true,
                "isLib": Array [
                  ".spago",
                  "generated",
                ],
                "stash": false,
                "strict": true,
              },
              "spago": false,
              "src": Array [
                ".spago/*/*/src/**/*.purs",
                "src/**/*.purs",
                "test/**/*.purs",
                "generated/**/*.purs",
              ],
              "watch": false,
            },
          },
        ],
      }
    `);
  });

  it("Adds the development config", () => {
    expect(purescriptRule("development", [])).toMatchInlineSnapshot(`
      Object {
        "test": /\\\\\\.purs\\$/,
        "use": Array [
          Object {
            "loader": "purs-loader",
            "options": Object {
              "bundle": false,
              "psc": "psa",
              "pscArgs": Object {
                "censorLib": true,
                "isLib": Array [
                  ".spago",
                  "generated",
                ],
                "stash": true,
                "strict": true,
              },
              "spago": true,
              "src": Array [],
              "watch": true,
            },
          },
        ],
      }
    `);
  });

  it("Adds additional sources in production", () => {
    expect(
      purescriptRule("production", ["../other-sources/**/*.purs"]).use[0]
    ).toEqual(
      mergeWithCustomize({
        customizeArray: customizeArray({
          src: "append",
        }),
      })(purescriptRule("production", []).use[0], {
        options: {
          src: ["../other-sources/**/*.purs"],
        },
      })
    );
  });

  it("Ignores additional sources in development", () => {
    expect(
      purescriptRule("development", ["../other-sources/**/*.purs"])
    ).toEqual(purescriptRule("development", []));
  });
});

describe("webpackConfig", () => {
  it("Produces the default production config", () => {
    expect(webpackConfig(() => ({}))("production")).toMatchInlineSnapshot(`
      Object {
        "devtool": false,
        "mode": "production",
        "module": Object {
          "rules": Array [
            Object {
              "loader": "ts-loader",
              "test": /\\\\\\.tsx\\?\\$/,
            },
            Object {
              "test": /\\\\\\.css\\$/,
              "use": Array [
                "${MiniCssExtractPlugin.loader}",
                "css-loader",
                "postcss-loader",
              ],
            },
            Object {
              "test": /\\\\\\.\\(png\\|svg\\|jpg\\|jpeg\\|gif\\|woff\\|woff2\\|eot\\|ttf\\|otf\\)\\$/i,
              "type": "asset/resource",
            },
          ],
        },
        "optimization": Object {
          "runtimeChunk": "single",
          "splitChunks": Object {
            "cacheGroups": Object {
              "vendor": Object {
                "chunks": "all",
                "name": "vendors",
                "test": /\\[\\\\\\\\/\\]node_modules\\[\\\\\\\\/\\]/,
              },
            },
          },
        },
        "output": Object {
          "filename": "[name].[contenthash].js",
          "pathinfo": true,
        },
        "plugins": Array [
          MiniCssExtractPlugin {
            "_sortedModulesCache": WeakMap {},
            "options": Object {
              "chunkFilename": "[id].css",
              "experimentalUseImportModule": undefined,
              "filename": "[name]-[chunkhash].css",
              "ignoreOrder": false,
              "runtime": true,
            },
            "runtimeOptions": Object {
              "attributes": undefined,
              "insert": undefined,
              "linkType": "text/css",
            },
          },
          ErrorReportingPlugin {},
          DefinePlugin {
            "definitions": Object {
              "NODE_ENV": "production",
            },
          },
          CleanWebpackPlugin {
            "apply": [Function],
            "cleanAfterEveryBuildPatterns": Array [],
            "cleanOnceBeforeBuildPatterns": Array [
              "**/*",
            ],
            "cleanStaleWebpackAssets": true,
            "currentAssets": Array [],
            "dangerouslyAllowCleanPatternsOutsideProject": false,
            "dry": false,
            "handleDone": [Function],
            "handleInitial": [Function],
            "initialClean": false,
            "outputPath": "",
            "protectWebpackAssets": true,
            "removeFiles": [Function],
            "verbose": false,
          },
        ],
        "resolve": Object {
          "extensions": Array [
            ".purs",
            ".js",
            ".ts",
            ".tsx",
          ],
          "modules": Array [
            "node_modules",
          ],
        },
        "resolveLoader": Object {
          "modules": Array [
            "node_modules",
          ],
        },
        "stats": Object {
          "children": false,
        },
      }
    `);
  });

  it("Produces the default development config", () => {
    expect(webpackConfig(() => ({}))("development")).toMatchInlineSnapshot(`
      Object {
        "devServer": Object {
          "compress": true,
          "port": 8009,
          "stats": "errors-warnings",
        },
        "devtool": "eval-cheap-source-map",
        "mode": "development",
        "module": Object {
          "rules": Array [
            Object {
              "loader": "ts-loader",
              "test": /\\\\\\.tsx\\?\\$/,
            },
            Object {
              "test": /\\\\\\.css\\$/,
              "use": Array [
                "${MiniCssExtractPlugin.loader}",
                "css-loader",
                "postcss-loader",
              ],
            },
            Object {
              "test": /\\\\\\.\\(png\\|svg\\|jpg\\|jpeg\\|gif\\|woff\\|woff2\\|eot\\|ttf\\|otf\\)\\$/i,
              "type": "asset/resource",
            },
          ],
        },
        "optimization": Object {
          "runtimeChunk": "single",
          "splitChunks": Object {
            "cacheGroups": Object {
              "vendor": Object {
                "chunks": "all",
                "name": "vendors",
                "test": /\\[\\\\\\\\/\\]node_modules\\[\\\\\\\\/\\]/,
              },
            },
          },
        },
        "output": Object {
          "filename": "[name].[contenthash].js",
          "pathinfo": true,
        },
        "plugins": Array [
          MiniCssExtractPlugin {
            "_sortedModulesCache": WeakMap {},
            "options": Object {
              "chunkFilename": "[id].css",
              "experimentalUseImportModule": undefined,
              "filename": "[name]-[chunkhash].css",
              "ignoreOrder": false,
              "runtime": true,
            },
            "runtimeOptions": Object {
              "attributes": undefined,
              "insert": undefined,
              "linkType": "text/css",
            },
          },
          DefinePlugin {
            "definitions": Object {
              "NODE_ENV": "development",
            },
          },
          CleanWebpackPlugin {
            "apply": [Function],
            "cleanAfterEveryBuildPatterns": Array [],
            "cleanOnceBeforeBuildPatterns": Array [
              "**/*",
            ],
            "cleanStaleWebpackAssets": true,
            "currentAssets": Array [],
            "dangerouslyAllowCleanPatternsOutsideProject": false,
            "dry": false,
            "handleDone": [Function],
            "handleInitial": [Function],
            "initialClean": false,
            "outputPath": "",
            "protectWebpackAssets": true,
            "removeFiles": [Function],
            "verbose": false,
          },
        ],
        "resolve": Object {
          "extensions": Array [
            ".purs",
            ".js",
            ".ts",
            ".tsx",
          ],
          "modules": Array [
            "node_modules",
          ],
        },
        "resolveLoader": Object {
          "modules": Array [
            "node_modules",
          ],
        },
        "stats": Object {
          "children": false,
        },
      }
    `);
  });

  it("Merges custom config options", () => {
    expect(
      webpackConfig((env) => ({
        entry: "./entry.js",
        output: { path: "./dist" },
        module: {
          rules: [purescriptRule(env, [])],
        },
      }))("production")
    ).toMatchInlineSnapshot(`
      Object {
        "devtool": false,
        "entry": "./entry.js",
        "mode": "production",
        "module": Object {
          "rules": Array [
            Object {
              "loader": "ts-loader",
              "test": /\\\\\\.tsx\\?\\$/,
            },
            Object {
              "test": /\\\\\\.css\\$/,
              "use": Array [
                "${MiniCssExtractPlugin.loader}",
                "css-loader",
                "postcss-loader",
              ],
            },
            Object {
              "test": /\\\\\\.\\(png\\|svg\\|jpg\\|jpeg\\|gif\\|woff\\|woff2\\|eot\\|ttf\\|otf\\)\\$/i,
              "type": "asset/resource",
            },
            Object {
              "test": /\\\\\\.purs\\$/,
              "use": Array [
                Object {
                  "loader": "purs-loader",
                  "options": Object {
                    "bundle": true,
                    "psc": "psa",
                    "pscArgs": Object {
                      "censorLib": true,
                      "isLib": Array [
                        ".spago",
                        "generated",
                      ],
                      "stash": false,
                      "strict": true,
                    },
                    "spago": false,
                    "src": Array [
                      ".spago/*/*/src/**/*.purs",
                      "src/**/*.purs",
                      "test/**/*.purs",
                      "generated/**/*.purs",
                    ],
                    "watch": false,
                  },
                },
              ],
            },
          ],
        },
        "optimization": Object {
          "runtimeChunk": "single",
          "splitChunks": Object {
            "cacheGroups": Object {
              "vendor": Object {
                "chunks": "all",
                "name": "vendors",
                "test": /\\[\\\\\\\\/\\]node_modules\\[\\\\\\\\/\\]/,
              },
            },
          },
        },
        "output": Object {
          "filename": "[name].[contenthash].js",
          "path": "./dist",
          "pathinfo": true,
        },
        "plugins": Array [
          MiniCssExtractPlugin {
            "_sortedModulesCache": WeakMap {},
            "options": Object {
              "chunkFilename": "[id].css",
              "experimentalUseImportModule": undefined,
              "filename": "[name]-[chunkhash].css",
              "ignoreOrder": false,
              "runtime": true,
            },
            "runtimeOptions": Object {
              "attributes": undefined,
              "insert": undefined,
              "linkType": "text/css",
            },
          },
          ErrorReportingPlugin {},
          DefinePlugin {
            "definitions": Object {
              "NODE_ENV": "production",
            },
          },
          CleanWebpackPlugin {
            "apply": [Function],
            "cleanAfterEveryBuildPatterns": Array [],
            "cleanOnceBeforeBuildPatterns": Array [
              "**/*",
            ],
            "cleanStaleWebpackAssets": true,
            "currentAssets": Array [],
            "dangerouslyAllowCleanPatternsOutsideProject": false,
            "dry": false,
            "handleDone": [Function],
            "handleInitial": [Function],
            "initialClean": false,
            "outputPath": "",
            "protectWebpackAssets": true,
            "removeFiles": [Function],
            "verbose": false,
          },
        ],
        "resolve": Object {
          "extensions": Array [
            ".purs",
            ".js",
            ".ts",
            ".tsx",
          ],
          "modules": Array [
            "node_modules",
          ],
        },
        "resolveLoader": Object {
          "modules": Array [
            "node_modules",
          ],
        },
        "stats": Object {
          "children": false,
        },
      }
    `);
  });

  it("Overrides matching plugins", () => {
    expect(
      webpackConfig((env) => ({
        plugins: [
          new MiniCssExtractPlugin({
            filename: "overridden.css",
          }),
        ],
      }))("production")
    ).toMatchInlineSnapshot(`
      Object {
        "devtool": false,
        "mode": "production",
        "module": Object {
          "rules": Array [
            Object {
              "loader": "ts-loader",
              "test": /\\\\\\.tsx\\?\\$/,
            },
            Object {
              "test": /\\\\\\.css\\$/,
              "use": Array [
                "${MiniCssExtractPlugin.loader}",
                "css-loader",
                "postcss-loader",
              ],
            },
            Object {
              "test": /\\\\\\.\\(png\\|svg\\|jpg\\|jpeg\\|gif\\|woff\\|woff2\\|eot\\|ttf\\|otf\\)\\$/i,
              "type": "asset/resource",
            },
          ],
        },
        "optimization": Object {
          "runtimeChunk": "single",
          "splitChunks": Object {
            "cacheGroups": Object {
              "vendor": Object {
                "chunks": "all",
                "name": "vendors",
                "test": /\\[\\\\\\\\/\\]node_modules\\[\\\\\\\\/\\]/,
              },
            },
          },
        },
        "output": Object {
          "filename": "[name].[contenthash].js",
          "pathinfo": true,
        },
        "plugins": Array [
          ErrorReportingPlugin {},
          MiniCssExtractPlugin {
            "_sortedModulesCache": WeakMap {},
            "options": Object {
              "chunkFilename": "[id].overridden.css",
              "experimentalUseImportModule": undefined,
              "filename": "overridden.css",
              "ignoreOrder": false,
              "runtime": true,
            },
            "runtimeOptions": Object {
              "attributes": undefined,
              "insert": undefined,
              "linkType": "text/css",
            },
          },
          DefinePlugin {
            "definitions": Object {
              "NODE_ENV": "production",
            },
          },
          CleanWebpackPlugin {
            "apply": [Function],
            "cleanAfterEveryBuildPatterns": Array [],
            "cleanOnceBeforeBuildPatterns": Array [
              "**/*",
            ],
            "cleanStaleWebpackAssets": true,
            "currentAssets": Array [],
            "dangerouslyAllowCleanPatternsOutsideProject": false,
            "dry": false,
            "handleDone": [Function],
            "handleInitial": [Function],
            "initialClean": false,
            "outputPath": "",
            "protectWebpackAssets": true,
            "removeFiles": [Function],
            "verbose": false,
          },
        ],
        "resolve": Object {
          "extensions": Array [
            ".purs",
            ".js",
            ".ts",
            ".tsx",
          ],
          "modules": Array [
            "node_modules",
          ],
        },
        "resolveLoader": Object {
          "modules": Array [
            "node_modules",
          ],
        },
        "stats": Object {
          "children": false,
        },
      }
    `);
  });
});
