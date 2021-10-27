# Nvim configuration


The goal is to have a functional, intuitive, and portable editor, customized to my
workflow.

Dependency manager is in progress, but should work by calling `setup`:

```bash
./data/install_deps.py setup
```

Then `install` to install the executables described in `data/installables.json`:

```bash
./data/install_deps.py install
```

Eventually also update the executables with:

```bash
./data/install_deps.py update
```

More details in `data/install_spec.md`.
