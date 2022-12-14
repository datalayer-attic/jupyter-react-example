# Copyright (c) Datalayer, Inc. https://datalayer.io
# Distributed under the terms of the MIT License.

SHELL=/bin/bash

CONDA=source $$(conda info --base)/etc/profile.d/conda.sh
CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate
CONDA_DEACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda deactivate
CONDA_REMOVE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda remove -y --all -n

ENV_NAME=jupyter-react

.PHONY: help

help: ## display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

default: help ## default target is help

all: clean install build

build: ## build all modules
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		yarn build )

kill: ## kill
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		./dev/sh/kill-jupyter-server.sh && \
		./dev/sh/kill-webpack.sh )

start: ## start
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		yarn start )

clean: ## deletes node_modules, lib, build... folders and other generated info, lock, log... files
	find . -name node_modules | xargs rm -fr {} || true
	find . -name dist | xargs rm -fr {} || true
	find . -name lib | xargs rm -fr {} || true
	find . -name build | xargs rm -fr {} || true
	find . -name yarn.lock | xargs rm {} || true
	find . -name yarn-error.log | xargs rm {} || true
	find . -name tsconfig.tsbuildinfo | xargs rm {} || true

env-rm: ## create a conda environment
	($(CONDA); \
		conda deactivate && \
			conda remove -y --all -n ${ENV_NAME} )

env: ## create a conda environment 
# pip install --upgrade git+https://github.com/datalayer/jupyterpool@main#egg=jupyterpool
	($(CONDA); \
		conda env create -f environment.yml )
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		pip install --upgrade git+https://github.com/datalayer-externals/jupyter-server@sessions2#egg=jupyter_server && \
		pip install jupyter_ydoc==0.1.17 )

install: ## Install yarn dependencies
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		yarn )
	echo "The following is a temporary fix tested on MacOS - For other OS, you may need to fix manually"
	sed -i.bu "s|k: keyof TableOfContents.IConfig|k: string|g" node_modules/\@jupyterlab/notebook/lib/toc.d.ts
	sed -i.bu "s|uri: DocumentUri|uri: string|g" node_modules/vscode-languageserver-protocol/lib/common/protocol.diagnostic.d.ts
	sed -i.bu "s|uri: DocumentUri|uri: string|g" node_modules/vscode-languageserver-types/lib/umd/main.d.ts
	sed -i.bu "s|id: ChangeAnnotationIdentifier|uri: string|g" node_modules/vscode-languageserver-types/lib/umd/main.d.ts

start-jupyter-server:
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		./dev/sh/kill-jupyter-server.sh || true )
	($(CONDA_ACTIVATE) ${ENV_NAME}; \
		cd ./dev/sh && ./start-jupyter-server.sh )
