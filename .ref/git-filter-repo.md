# Install

    setup git-filter-repo

# Delete directory

    git filter-repo --invert-paths --path my-directory/

# Delete by glob

    git filter-repo --invert-paths --path-glob 'my-directory/*.jpg'

# Notes

- Either work on a new clone, or take a backup first.
- The 'origin' remote will be deleted, for safety.
