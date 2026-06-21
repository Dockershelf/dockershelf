# Contributing

Thank you for your interest in Dockershelf. Contributions are welcome, and credit is given to everyone who helps improve the project.

## Types of Contributions

You can help by:

- Reporting bugs
- Fixing bugs
- Implementing features
- Improving documentation
- Submitting feedback on existing behavior

## Report Bugs

Report bugs through [GitHub Issues](https://github.com/LuisAlejandro/dockershelf/issues).

Please include:

- Your operating system and version
- Docker version and how you run the project (host Python vs. Docker)
- Steps to reproduce the problem
- Expected vs. actual behavior
- Relevant logs or screenshots

## Suggest Features

Before opening a feature request, check whether a similar issue already exists. Describe the problem you are solving, the behavior you want, alternatives you considered, and the scope you have in mind.

## Local Development

1. Fork and clone the repository.
2. Create a branch from `develop`.
3. Build and start the development container:

   ```bash
   make image
   make start
   ```

4. Open a shell in the container when you need to run project commands inside Docker:

   ```bash
   make console
   ```

5. Install Ruby test dependencies when working on image specs:

   ```bash
   make dependencies
   ```

6. Regenerate shelf Dockerfiles, README tables, and workflow matrices after changing shelf configuration:

   ```bash
   make update-shelves
   ```

   You can also run `python3 update.py` on the host if you have the Python dependencies from `requirements.txt` installed.

7. Discover upstream shelf versions before maintenance work:

   ```bash
   make discover-shelves
   ```

For host-only Python work, use:

```bash
make virtualenv
./virtualenv/bin/python3 update.py
```

Copy `.env.example` to `.env` when running `scripts/build-all-images.sh` or `scripts/delete-stale.sh` (Docker Hub credentials).

## Quality Checks

With the development container running (`make start`), run:

```bash
make lint
make format
make test
```

- `make lint` runs `flake8` on `scripts/`, `update.py`, and `tests/` via tox.
- `make format` applies `autoflake` and `autopep8` to the same paths (write mode).
- `make test` runs unit tests with coverage via `tox -e coverage`.

Before opening a pull request, also:

- Run `python3 update.py` (or `make update-shelves`) and confirm it completes without errors.
- Run the relevant image test scripts when you change Docker recipes.
- Keep generated files consistent when your change affects shelves, tags, or CI matrices.

CI runs `python3 update.py` on pull requests (see `.github/workflows/pr.yml`).

## Pull Request Guidelines

- Keep changes focused and easy to review.
- Link related issues when applicable.
- Update documentation when user-facing behavior changes.
- Include or update tests when you change image behavior.
- Do not commit secrets, `.env` files, or local credentials.

## Maintainer Notes

Releases are handled by maintainers using the git-flow release scripts (`make release-patch`, `make release-minor`, `make release-major`, and `make undo-release`). Contributors should not publish Docker images, push release tags, or cut GitHub releases unless asked to do so by a maintainer.

See [MAINTAINER.md](MAINTAINER.md) for maintainer release workflow details.
