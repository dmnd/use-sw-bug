# `npm-shrinkwrap` dependency mismatch bug

## Overview
In certain scenarios, `npm shrinkwrap` does not fix mismatches between dependencies installed in `node_modules` and dependencies listed in `npm-shrinkwrap.json`. One such scenario is described below, where a dependency from a specific repository is used.
For this proof of concept, the repository `codykrainock/sw-bug` is used as the dependency. This repository only has two "versions" - each represented by a separate commit.

## Steps to reproduce

`./bug-reproduce.sh` can be run to reproduce the issue. The steps to reproduce are also outlined here.

### 0. Clone this repository

```
git clone https://github.com/codykrainock/use-sw-bug.git
cd use-sw-bug
```

### 1. Clean the local environment

This will not be necessary if the repo is freshly cloned.

```
rm -rf node_modules/
```

### 2. Install dependencies listed in `package.json` and `npm-shrinkwrap.json`

The example here uses `codykrainock/sw-bug`, a repository with two versions represented by two commits. `npm-shrinkwrap.json` points to the first version.

```
npm install
```

### 3. Update a dependency that points to a specific repository

This uses the `sw-bug` repository described in the last step. Here, newest version of the repository (represented by the second commit) is installed to `node_modules`.

```
npm install sw-bug --save
```

### 4. Undo any changes to `npm-shrinkwrap.json`

After this step, the dependency represented by `npm-shrinkwrap.json` is the first version of `sw-bug`, whereas the dependency that lives in our local environment is the second version of `sw-bug`.

```
git checkout -- npm-shrinkwrap.json
```

### 5. Install dependencies listed in `package.json` and `npm-shrinkwrap.json`

```
npm install
```

This is the same as step 2, and in theory, our local environment should match what is represented by `npm-shrinkwrap.json`. However, after this step, version 2 of `sw-bug` is in `node_modules/` whereas version 1 is in `npm-shrinkwrap.json`. This can be confirmed by checking the hash listed in `node_modules/sw-bug/package.json`'s `_resolve` against the hash listed in `npm-shrinkwrap.json`. 

## Versions

```
$ npm -v
3.8.3
$ node -v
v5.10.0
```

