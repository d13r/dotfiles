# How to temporarily fork a PHP package

1. Fork the project on GitHub, or create a new repo on GitLab.

2. Switch to it and create a new branch:

    c vendor/NAMESPACE/PACKAGE
    hackit
    g cob BRANCH
    g ra d13r git@github.com:d13r/REPO.git
    g pu d13r

Or:

    c vendor/NAMESPACE/PACKAGE
    hackit
    g cob BRANCH
    g ra maths git@git.maths.ox.ac.uk:it/REPO.git
    g pu maths

3. Update the project's composer.json:

    // ADD THIS:
    "repositories": [
        {
            "type": "vcs",
            "url": "https://github.com/d13r/REPO.git"
        }
    ],

    "require": {
        // UPDATE THIS:
        "NAMESPACE/PACKAGE": "dev-BRANCH"
    }

If I'm using someone else's fork and want to pin to a specific commit:

    "require": {
        // UPDATE THIS:
        "NAMESPACE/PACKAGE": "dev-BRANCH#COMMIT"
    }

If I'm using a private GitLab repo instead, e.g. at work:

    "repositories": [
        {
            "type": "vcs",
            "url": "https://composer:TOKEN@git.maths.ox.ac.uk/it/REPO.git"
        },
    ],

4. Install it:

    com up
