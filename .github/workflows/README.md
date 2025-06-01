# GitHub Actions `.yml` Guide

This repository uses **GitHub Actions** for continuous integration (CI), with workflow definitions written in `.yml` files stored in the `.github/workflows/` directory.

---

## 📘 What is a `.yml` File?

YAML (`.yml` or `.yaml`) stands for “YAML Ain’t Markup Language.” It's a human-readable format commonly used to define configuration files. In GitHub Actions, `.yml` files are used to describe **workflows** — automated tasks triggered by events like code pushes, pull requests, or schedule timers.

## 🧠 Basic Structure of a GitHub Actions Workflow

Here’s a minimal example and breakdown:

```yml
name: Run Tests  # Optional display name

on:              # Events that trigger the workflow
  push:
    branches: [main]
  pull_request:

jobs:
  build:         # Job name
    runs-on: ubuntu-latest

    steps:       # Sequence of steps
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up GHDL
        uses: ghdl/setup-ghdl-ci@v1

      - name: Run tests
        run: |
          cd GHDL/
          ./run_all_tests.sh
```

## 🧹 Key Sections Explained

| Section   | Description                                                                   |
| --------- | ----------------------------------------------------------------------------- |
| `name`    | Optional display name of the workflow                                         |
| `on`      | Defines what triggers the workflow (e.g., `push`, `pull_request`, `schedule`) |
| `jobs`    | Groups of steps run on a virtual machine                                      |
| `runs-on` | The OS used for the job (e.g., `ubuntu-latest`, `windows-latest`)             |
| `steps`   | Ordered list of actions and commands to run                                   |
| `uses`    | Reusable GitHub Actions (e.g., `actions/checkout`, `setup-ghdl-ci`)           |
| `run`     | Shell commands executed during a step                                         |


## 💡 Tips

* Use `actions/checkout@v3` in nearly every workflow to fetch your repo code.
* Use `run: |` when writing multi-line shell commands.
* Keep workflows small and modular for easier maintenance.
* Combine with test coverage or report generators if needed.


## 📚 Useful Links

* [GitHub Actions Docs](https://docs.github.com/en/actions)
* [GHDL GitHub Actions Setup](https://github.com/ghdl/setup-ghdl)
* [List of GitHub Actions Events](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)
