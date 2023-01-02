# Usage

Call it from inside your repository and the script will figure out the
details based on the URL of your origin repository.

`perl generate_changelog.pl`

Use open issues rather than closed.

`perl generate_changelog.pl --state open`

Be explicit about ownership and repo.

`perl generate-changelog.pl libwww-perl/HTTP-Message`

Optionally use a GitHub token.

`perl generate_changelog.pl username/repository optional_github_token`

`perl generate_changelog.pl org_name/repository optional_github_token`
