[![Datalayer](https://assets.datalayer.design/datalayer-25.svg)](https://datalayer.io)

# 🪐 ⚛️ Jupyter React Example

Example to showcase the [Jupyter React](https://github.com/datalayer/jupyter-react) library usage.

## Environment

Follow the below steps to create your development environment. You will need [Miniconda](https://docs.conda.io/en/latest/miniconda.html) up-and-running on your machine (MacOS or Linux, Windows is not supported as development platform for the time-being).

```bash
# Clone the jupyter-react repository.
git clone https://github.com/datalayer/jupyter-react-example.git && \
  cd jupyter-react-example
```

```bash
# Setup your development environment.
conda deactivate && \
  make env-rm # If you want to reset your environment.
make env && \
  conda activate jupyter-react
```

```bash
# Install and build.
make install build
```

```bash
# You can start an example and hack the source code.
# The changes will build automatically and will be available in your browser.
echo open http://localhost:3208
yarn start
```

## After creating your own create-react (v5) app 

### Startup Scripts

You will need a Jupyter server up-and-running.

### Dot env

You will need `GENERATE_SOURCEMAP=false` in a `.env` file at the top of your folder/repositoriy.

It looks like react-script version 5 does not like sourcmaps pointing to non existing source code.

### Metadata in index.html

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

### Coherent React.js version

Create react is fragile on react, especially as we are pulling various version from jupyterlab.

Upon the `resolutions` in package.json, the Makefile ensure we remove all pulled react* folder under node_modules of thir party dependencies.

### Emotion/react

For now, we need `@emotion/react`, this will be removed in the future.

## ⚖️ License

Copyright (c) 2022 Datalayer, Inc.

Released under the terms of the MIT license (see [LICENSE](./LICENSE)).
