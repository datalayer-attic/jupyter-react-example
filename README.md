[![Datalayer](https://assets.datalayer.design/datalayer-25.svg)](https://datalayer.io)

# 🪐 ⚛️ Jupyter React Example

Example to showcase the [Jupyter React](https://github.com/datalayer/jupyter-react) library usage.

## Environment

Follow the below steps to create your development environment. You will need [Miniconda](https://docs.conda.io/en/latest/miniconda.html) up-and-running on your machine (MacOS or Linux, Windows is not supported as development platform for the time-being).

```bash
# Clone the jupyter-react-example repository.
git clone https://github.com/datalayer/jupyter-react-example.git && \
  cd jupyter-react-example
# Setup your development environment.
conda deactivate && \
  make env-rm # If you want to reset your environment.
make env && \
  conda activate jupyter-react
# Install.
make install
# You can start the example and hack the source code.
# The changes will build automatically and will be available in your browser.
echo open http://localhost:3000
yarn start
```

## Create your own create-react-app (version 5)

You can create your own app and add the jupyter-react library.

```bash
npx create-react-app jupyter-react-example --template typescript && \
  cd jupyter-react-example && \
  yarn add @datalayer/jupyter-react
```

Once this is done, double-check the following requirements (just checkout this repository for a complete setup).

### Startup Scripts

You will need a Jupyter server up-and-running. We ship the configuration and scripts in this repository. You can add in your `package.json` the needed definitions.

```json
  "scripts": {
    "start": "run-p -c start:*",
    "start:jupyter": "make start-jupyter-server",
    "start:react": "react-scripts start",
  },
  "devDependencies": {
    "npm-run-all": "4.1.5",
  },
```

### Dot Env

It looks like the `create-react-app` version 5 does not like sourcemaps pointing to non existing source code. To avoid error messages, please create a `.env` file at the top of your folder/repositoriy and add there `GENERATE_SOURCEMAP=false`.

```dotenv
// .env
GENERATE_SOURCEMAP=false
```

### Fix the polyfils

Add the following packages to avoid `BREAKING CHANGE: webpack < 5 used to include polyfills for node.js core modules by default.`

```json
  "devDependencies": {
    "assert": "2.0.0",
    "stream": "0.0.2"
  }
```

### Fix JupyterLab

Run `make install`. This will apply the following temporary patch on the JupyterLab type definition.

```bash
echo "The following is a temporary fix tested on MacOS - For other OS, you may need to fix manually"
sed -i.bu "s|k: keyof TableOfContents.IConfig|k: string|g" node_modules/\@jupyterlab/notebook/lib/toc.d.ts
```

### Metadata in index.html

You need to add in the `public/index.html` the needed information to indicate where you Jupyter server is running.

```html
    <script id="datalayer-config-data" type="application/json">
      {
        "jupyterServerHttpUrl": "http://localhost:8686/api/jupyter",
        "jupyterServerWsUrl": "ws://localhost:8686/api/jupyter",
        "jupyterToken": "60c1661cc408f978c309d04157af55c9588ff9557c9380e4fb50785750703da6"
      }
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.4/require.min.js"></script>
```

### React.js version resolution

A `create-react-app` requests coherent react.js versions. With JupyterLab, we are pulling various version in the node_modules subfolders. To avoid version conflicts, the `resolutions` in `package.json` specifies the needed version.

### Emotion/react

For now, we need to add `@emotion/react`. This requirement will be removed in the future.

## ⚖️ License

Copyright (c) 2022 Datalayer, Inc.

Released under the terms of the MIT license (see [LICENSE](./LICENSE)).
