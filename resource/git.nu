def "nu-complete git branches" [] {
  ^git branch | lines | each { |line| $line | str replace '\* ' "" | str trim }
}

def "nu-complete git switchable branches" [] {
   let remotes_regex = (["(", ((nu-complete git remotes | each {|r| ['remotes/', $r, '/'] | str join}) | str join "|"), ")"] | str join)
   ^git branch -a
   | lines
   | parse -r (['^[\* ]+', $remotes_regex, '?(?P<branch>\S+)'] | flatten | str join)
   | get branch
   | uniq
   | where {|branch| $branch != "HEAD"}
}

def "nu-complete git remotes" [] {
  ^git remote | lines | each { |line| $line | str trim }
}

def "nu-complete git log" [] {
  ^git log --pretty=%h | lines | each { |line| $line | str trim }
}

def "nu-complete git commits" [] {
  ^git rev-list --all --remotes --pretty=oneline | lines | parse "{value} {description}"
}

# Check out git branches and files
export extern "git checkout" [
  ...targets: string@"nu-complete git switchable branches"   # name of the branch or files to checkout
  --conflict: string                              # conflict style (merge or diff3)
  --detach(-d)                                    # detach HEAD at named commit
  --force(-f)                                     # force checkout (throw away local modifications)
  --guess                                         # second guess 'git checkout <no-such-branch>' (default)
  --ignore-other-worktrees                        # do not check if another worktree is holding the given ref
  --ignore-skip-worktree-bits                     # do not limit pathspecs to sparse entries only
  --merge(-m)                                     # perform a 3-way merge with the new branch
  --orphan: string                                # new unparented branch
  --ours(-2)                                      # checkout our version for unmerged files
  --overlay                                       # use overlay mode (default)
  --overwrite-ignore                              # update ignored files (default)
  --patch(-p)                                     # select hunks interactively
  --pathspec-from-file: string                    # read pathspec from file
  --progress                                      # force progress reporting
  --quiet(-q)                                     # suppress progress reporting
  --recurse-submodules: string                    # control recursive updating of submodules
  --theirs(-3)                                    # checkout their version for unmerged files
  --track(-t)                                     # set upstream info for new branch
  -b: string                                      # create and checkout a new branch
  -B: string                                      # create/reset and checkout a branch
  -l                                              # create reflog for new branch
]

# Download objects and refs from another repository
export extern "git fetch" [
  repository?: string@"nu-complete git remotes"              # the name of the remote
  ...refspec: string@"nu-complete git switchable branches"   # the branch / refspec
  --all                                         # Fetch all remotes
  --append(-a)                                  # Append ref names and object names to .git/FETCH_HEAD
  --atomic                                      # Use an atomic transaction to update local refs.
  --depth: int                                  # Limit fetching to n commits from the tip
  --deepen: int                                 # Limit fetching to n commits from the current shallow boundary
  --shallow-since: string                       # Deepen or shorten the history by date
  --shallow-exclude: string                     # Deepen or shorten the history by branch/tag
  --unshallow                                   # Fetch all available history
  --update-shallow                              # Update .git/shallow to accept new refs
  --negotiation-tip: string                     # Specify which commit/glob to report while fetching
  --negotiate-only                              # Do not fetch, only print common ancestors
  --dry-run                                     # Show what would be done
  --write-fetch-head                            # Write fetched refs in FETCH_HEAD (default)
  --no-write-fetch-head                         # Do not write FETCH_HEAD
  --force(-f)                                   # Always update the local branch
  --keep(-k)                                    # Keep dowloaded pack
  --multiple                                    # Allow several arguments to be specified
  --auto-maintenance                            # Run 'git maintenance run --auto' at the end (default)
  --no-auto-maintenance                         # Don't run 'git maintenance' at the end
  --auto-gc                                     # Run 'git maintenance run --auto' at the end (default)
  --no-auto-gc                                  # Don't run 'git maintenance' at the end
  --write-commit-graph                          # Write a commit-graph after fetching
  --no-write-commit-graph                       # Don't write a commit-graph after fetching
  --prefetch                                    # Place all refs into the refs/prefetch/ namespace
  --prune(-p)                                   # Remove obsolete remote-tracking references
  --prune-tags(-P)                              # Remove any local tags that do not exist on the remote
  --no-tags(-n)                                 # Disable automatic tag following
  --refmap: string                              # Use this refspec to map the refs to remote-tracking branches
  --tags(-t)                                    # Fetch all tags
  --recurse-submodules: string                  # Fetch new commits of populated submodules (yes/on-demand/no)
  --jobs(-j): int                               # Number of parallel children
  --no-recurse-submodules                       # Disable recursive fetching of submodules
  --set-upstream                                # Add upstream (tracking) reference
  --submodule-prefix: string                    # Prepend to paths printed in informative messages
  --upload-pack: string                         # Non-default path for remote command
  --quiet(-q)                                   # Silence internally used git commands
  --verbose(-v)                                 # Be verbose
  --progress                                    # Report progress on stderr
  --server-option(-o): string                   # Pass options for the server to handle
  --show-forced-updates                         # Check if a branch is force-updated
  --no-show-forced-updates                      # Don't check if a branch is force-updated
  -4                                            # Use IPv4 addresses, ignore IPv6 addresses
  -6                                            # Use IPv6 addresses, ignore IPv4 addresses
]

# Push changes
export extern "git push" [
  remote?: string@"nu-complete git remotes",      # the name of the remote
  ...refs: string@"nu-complete git branches"      # the branch / refspec
  --all                                           # push all refs
  --atomic                                        # request atomic transaction on remote side
  --delete(-d)                                    # delete refs
  --dry-run(-n)                                   # dry run
  --exec: string                                  # receive pack program
  --follow-tags                                   # push missing but relevant tags
  --force-with-lease                              # require old value of ref to be at this value
  --force(-f)                                     # force updates
  --ipv4(-4)                                      # use IPv4 addresses only
  --ipv6(-6)                                      # use IPv6 addresses only
  --mirror                                        # mirror all refs
  --no-verify                                     # bypass pre-push hook
  --porcelain                                     # machine-readable output
  --progress                                      # force progress reporting
  --prune                                         # prune locally removed refs
  --push-option(-o): string                       # option to transmit
  --quiet(-q)                                     # be more quiet
  --receive-pack: string                          # receive pack program
  --recurse-submodules: string                    # control recursive pushing of submodules
  --repo: string                                  # repository
  --set-upstream(-u)                              # set upstream for git pull/status
  --signed: string                                # GPG sign the push
  --tags                                          # push tags (can't be used with --all or --mirror)
  --thin                                          # use thin pack
  --verbose(-v)                                   # be more verbose
]

# Switch between branches and commits
export extern "git switch" [
  switch?: string@"nu-complete git switchable branches"      # name of branch to switch to
  --create(-c): string                            # create a new branch
  --detach(-d): string@"nu-complete git log"      # switch to a commit in a detatched state
  --force-create(-C): string                      # forces creation of new branch, if it exists then the existing branch will be reset to starting point
  --force(-f)                                     # alias for --discard-changes
  --guess                                         # if there is no local branch which matches then name but there is a remote one then this is checked out
  --ignore-other-worktrees                        # switch even if the ref is held by another worktree
  --merge(-m)                                     # attempts to merge changes when switching branches if there are local changes
  --no-guess                                      # do not attempt to match remote branch names
  --no-progress                                   # do not report progress
  --no-recurse-submodules                         # do not update the contents of sub-modules
  --no-track                                      # do not set "upstream" configuration
  --orphan: string                                # create a new orphaned branch
  --progress                                      # report progress status
  --quiet(-q)                                     # suppress feedback messages
  --recurse-submodules                            # update the contents of sub-modules
  --track(-t)                                     # set "upstream" configuration
]

# Apply the change introduced by an existing commit
export extern "git cherry-pick" [
  commit?: string@"nu-complete git commits"     # The commit ID to be cherry-picked
  --edit(-e)                                    # Edit the commit message prior to committing
  --no-commit(-n)                               # Apply changes without making any commit
  --signoff(-s)                                 # Add Signed-off-by line to the commit message
  --ff                                          # Fast-forward if possible
  --continue                                    # Continue the operation in progress
  --abort                                       # Cancel the operation
  --skip                                        # Skip the current commit and continue with the rest of the sequence
]

### FROM AUTOCOMPLETIONS
### Please fix these :)

# Display the manual of a git command
extern "git" [
	...args
]
# Rewrite branches
extern "git filter-branch" [
	--env-filter					# This filter may be used if you only need to modify the environment
	--tree-filter					# This is the filter for rewriting the tree and its contents
	--index-filter					# This is the filter for rewriting the index
	--parent-filter					# This is the filter for rewriting the commit
	--msg-filter					# This is the filter for rewriting the commit messages
	--commit-filter					# This is the filter for performing the commit
	--tag-name-filter					# This is the filter for rewriting tag names
	--subdirectory-filter					# Only look at the history which touches the given subdirectory
	--prune-empty					# Ignore empty commits generated by filters
	--original					# Use this option to set the namespace where the original commits will be stored
	--force(-f)					# Filter even with refs in refs/original or existing temp directory
	...args
]
# Manage set of tracked repositories
extern "git remote" [
	--verbose(-v)					# Be verbose
	--tags					# Import every tag from a remote with git fetch <name>
	--no-tags					# Don't import tags from a remote with git fetch <name>
	--add					# Add to the list of currently tracked branches instead of replacing it
	--push					# Manipulate push URLs instead of fetch URLs
	--add					# Add new URL instead of changing the existing URLs
	--delete					# Remove URLs that match specified URL
	--push					# Query push URLs rather than fetch URLs
	--all					# All URLs for the remote will be listed
	--dry-run					# Report what will be pruned but do not actually prune it
	--prune					# Prune all remotes that are updated
	...args
]
# Adds a new remote
extern "git add" [
	--tags					# Import every tag from a remote with git fetch <name>
	--no-tags					# Don't import tags from a remote with git fetch <name>
	--dry-run(-n)					# Don't actually add the file(s)
	--verbose(-v)					# Be verbose
	--force(-f)					# Allow adding otherwise ignored files
	--interactive(-i)					# Interactive mode
	--patch(-p)					# Interactively choose hunks to stage
	--edit(-e)					# Manually create a patch
	--update(-u)					# Only match tracked files
	--all(-A)					# Match files both in working tree and index
	--intent-to-add(-N)					# Record only the fact that the path will be added later
	--refresh					# Don't add the file(s), but only refresh their stat
	--chmod
	--ignore-errors					# Ignore errors
	--ignore-missing					# Check if any of the given files would be ignored
	--force(-f)					# Overwrite existing notes
	--allow-empty					# Allow empty note
	--force(-f)					# Override safeguards
	--detach					# Detach HEAD in the new working tree
	--checkout					# Checkout <commit-ish> after creating working tree
	--no-checkout					# Suppress checkout
	--guess-remote
	--no-guess-remote
	--track					# Mark <commit-ish> as "upstream" from the new branch
	--no-track					# Dont mark <commit-ish> as "upstream" from the new branch
	--lock					# Lock working tree after creation
	--quiet(-q)					# Suppress feedback messages
	--force					# Also add ignored submodule path
	...args
]
# Removes a remote
extern "git rm" [
	----term-good					# Print the term for the old state
	----term-bad					# Print the term for the new state
	--cached					# Unstage files from the index
	--ignore-unmatch					# Exit with a zero status even if no files matched
	--quiet(-q)					# Be quiet
	--force(-f)					# Override the up-to-date check
	--dry-run(-n)					# Dry run
	--sparse					# Allow updating index entries outside of the sparse-checkout cone
	--output-directory(-o)
	--no-stat(-p)					# Generate plain patches without diffstat
	--no-patch(-s)					# Suppress diff output
	--minimal					# Spend more time to create smaller diffs
	--patience					# Generate diff with the 'patience' algorithm
	--histogram					# Generate diff with the 'histogram' algorithm
	--stdout					# Print all commits to stdout in mbox format
	--numstat					# Show number of added/deleted lines in decimal notation
	--shortstat					# Output only last line of the stat
	--summary					# Output a condensed summary of extended header information
	--no-renames					# Disable rename detection
	--full-index					# Show full blob object names
	--binary					# Output a binary diff for use with git apply
	--find-copies-harder					# Also inspect unmodified files as source for a copy
	--text(-a)					# Treat all files as text
	--ignore-space-at-eol					# Ignore changes in whitespace at EOL
	--ignore-space-change(-b)					# Ignore changes in amount of whitespace
	--ignore-all-space(-w)					# Ignore whitespace when comparing lines
	--ignore-blank-lines					# Ignore changes whose lines are all blank
	--function-context(-W)					# Show whole surrounding functions of changes
	--ext-diff					# Allow an external diff helper to be executed
	--no-ext-diff					# Disallow external diff helpers
	--no-textconv					# Disallow external text conversion filters for binary files (Default)
	--textconv					# Allow external filters for binary files (Resulting diff is unappliable)
	--no-prefix					# Do not show source or destination prefix
	--numbered(-n)					# Name output in [Patch n/m] format, even with a single patch
	--no-numbered(-N)					# Name output in [Patch] format, even with multiple patches
	...args
]
# Removes a remote
extern "git remove" [
	--stdin					# Read object names from stdin
	--verbose(-v)					# Be more verbose
	--quiet(-q)					# Operate quietly
	--ignore-missing					# Do not throw error on deleting non-existing object note
	--force(-f)					# Override safeguards
	...args
]
# Shows a remote
extern "git show" [
	--abbrev					# Show only a partial prefix instead of the full 40-byte hexadecimal object name
	--binary					# Output a binary diff that can be applied with "git-apply
	--check					# Warn if changes introduce conflict markers or whitespace errors
	--color					# Show colored diff
	--color-moved					# Moved lines of code are colored differently
	--color-words					# Equivalent to --word-diff=color plus --word-diff-regex=<regex>
	--compact-summary					# Output a condensed summary of extended header information
	--dst-prefix					# Show the given destination prefix instead of "b/
	--ext-diff					# Allow an external diff helper to be executed
	--find-copies-harder					# Inspect unmodified files as candidates for the source of copy
	--find-object					# Look for differences that change the number of occurrences of the object
	--full-index					# Show the full pre- and post-image blob object names on the "index" line
	--histogram					# Generate a diff using the "histogram diff" algorithm
	--ignore-blank-lines					# Ignore changes whose lines are all blank
	--ignore-cr-at-eol					# Ignore carrige-return at the end of line when doing a comparison
	--ignore-space-at-eol					# Ignore changes in whitespace at EOL
	--indent-heuristic					# Enable the heuristic that shift diff hunk boundaries
	--inter-hunk-context					# Show the context between diff hunks, up to the specified number of lines
	--ita-invisible-in-index					# Make the entry appear as a new file in "git diff" and non-existent in "git diff -l cached
	--line-prefix					# Prepend an additional prefix to every line of output
	--minimal					# Spend extra time to make sure the smallest possible diff is produced
	--name-only					# Show only names of changed files
	--name-status					# Show only names and status of changed files
	--no-color					# Turn off colored diff
	--no-ext-diff					# Disallow external diff drivers
	--no-indent-heuristic					# Disable the indent heuristic
	--no-prefix					# Do not show any source or destination prefix
	--no-renames					# Turn off rename detection
	--no-textconv					# Disallow external text conversion filters to be run when comparing binary files
	--numstat					# Shows number of added/deleted lines in decimal notation
	--patch-with-raw					# Synonym for -p --raw
	--patch-with-stat					# Synonym for -p --stat
	--patience					# Generate a diff using the "patience diff" algorithm
	--pickaxe-all					# When -S or -G finds a change, show all the changes in that changeset
	--pickaxe-regex					# Treat the <string> given to -S as an extended POSIX regular expression to match
	--relative					# Exclude changes outside the directory and show relative pathnames
	--shortstat					# Output only the last line of the --stat format containing total number of modified files
	--src-prefix					# Show the given source prefix instead of "a/
	--stat					# Generate a diffstat
	--stat					# Generate a diffstat
	--summary					# Output a condensed summary of extended header information
	--textconv					# Allow external text conversion filters to be run when comparing binary files
	--word-diff					# Show a word diff
	--word-diff-regex					# Use <regex> to decide what a word is
	--text(-a)					# Treat all files as text
	--break-rewrites(-B)					# Break complete rewrite changes into pairs of delete and create
	--ignore-space-change(-b)					# Ignore changes in amount of whitespace
	--find-copies(-C)					# Detect copies as well as renames
	--irreversible-delete(-D)					# Omit the preimage for deletes
	--find-renames(-M)					# Detect and report renames
	--function-context(-W)					# Show whole surrounding functions of changes
	--ignore-all-space(-w)					# Ignore whitespace when comparing lines
	--anchored					# Generate a diff using the "anchored diff" algorithm
	--abbrev-commit					# Show only a partial hexadecimal commit object name
	--no-abbrev-commit					# Show the full 40-byte hexadecimal commit object name
	--oneline					# Shorthand for "--pretty=oneline --abbrev-commit
	--encoding					# Re-code the commit log message in the encoding
	--expand-tabs					# Perform a tab expansion in the log message
	--no-expand-tabs					# Do not perform a tab expansion in the log message
	--no-notes					# Do not show notes
	--no-patch(-s)					# Suppress diff output
	--show-signature					# Check the validity of a signed commit object
	--remotes(-r)					# Shows the remote tracking branches
	--all(-a)					# Show both remote-tracking branches and local branches
	--current					# Includes the current branch to the list of revs to be shown
	--topo-order					# Makes commits appear in topological order
	--date-order					# Makes commits appear in date order
	--sparse					# Shows merges only reachable from one tip
	--no-name					# Do not show naming strings for each commit
	--sha1-name					# Name commits with unique prefix
	--no-color					# Turn off colored output
	...args
]
# Deletes all stale tracking branches
extern "git prune" [
	--dry-run					# Report what will be pruned but do not actually prune it
	--verbose(-v)					# Be more verbose
	--quiet(-q)					# Operate quietly
	--dry-run(-n)					# Just report what it would remove
	--verbose(-v)					# Report all removed objects
	--progress					# Show progress
	--dry-run(-n)					# Do not remove anything
	--verbose(-v)					# Report all removals
	...args
]
# Fetches updates
extern "git update" [
	--prune					# Prune all remotes that are updated
	--init					# Initialize all submodules
	--checkout					# Checkout the superproject's commit on a detached HEAD in the submodule
	--merge					# Merge the superproject's commit into the current branch of the submodule
	--rebase					# Rebase current branch onto the superproject's commit
	--no-fetch(-N)					# Don't fetch new objects from the remote
	--remote					# Instead of using superproject's SHA-1, use the state of the submodule's remote-tracking branch
	--force					# Discard local changes when switching to a different commit & always run checkout
	--recursive					# Traverse submodules recursively
	...args
]
# Renames a remote
extern "git rename" [

	...args
]
# Sets the default branch for a remote
extern "git set-head" [

	...args
]
# Changes URLs for a remote
extern "git set-url" [
	--push					# Manipulate push URLs instead of fetch URLs
	--add					# Add new URL instead of changing the existing URLs
	--delete					# Remove URLs that match specified URL
	...args
]
# Retrieves URLs for a remote
extern "git get-url" [
	--push					# Query push URLs rather than fetch URLs
	--all					# All URLs for the remote will be listed
	...args
]
# Changes the list of branches tracked by a remote
extern "git set-branches" [
	--add					# Add to the list of currently tracked branches instead of replacing it
	...args
]
# Shows the commits on branches
extern "git show-branch" [
	--remotes(-r)					# Shows the remote tracking branches
	--all(-a)					# Show both remote-tracking branches and local branches
	--current					# Includes the current branch to the list of revs to be shown
	--topo-order					# Makes commits appear in topological order
	--date-order					# Makes commits appear in date order
	--sparse					# Shows merges only reachable from one tip
	--no-name					# Do not show naming strings for each commit
	--sha1-name					# Name commits with unique prefix
	--no-color					# Turn off colored output
	...args
]
# Apply a series of patches from a mailbox
extern "git am" [
	--signoff(-s)					# Add a Signed-off-By trailer to commit message
	--keep-non-patch					# Only strip bracket pairs containing PATCH
	--no-keep-cr					# Override am.keepcr to false
	--scissors(-c)					# Remove everything in body before scissors
	--no-scissors					# Ignore scissor lines
	--no-messageid					# Do not add message id to commit message
	--quiet(-q)					# Supress logs
	--no-utf8					# Disable all charset re-encoding of metadata
	--3way(-3)					# Fall back to three way merge on patch failure
	--no-3way					# Do not fall back to three way merge on patch failure
	--rerere-autoupdate					# Allow rerere to update index if possible
	--ignore-space-change					# Pass --ignore-space-change to git apply
	--reject					# Pass --reject to git apply
	--interactive(-i)					# Run interactively
	--commiter-date-is-author-date					# Treat commiter date as author date
	--ignore-date					# Treat author date as commiter date
	--skip					# Skip current patch
	--no-gpg-sign					# Do not sign commits
	--continue(-r)					# Mark patch failures as resolved
	--abort					# Abort patch operation and restore branch
	--quit					# Abort without restoring branch
	--show-current-patch					# Show message at which patch failures occured
	--ignore-whitespace					# Ignore whitespace change in context lines
	--message-id(-m)					# Copy message id to the end of commit message
	--keep-cr					# Do not remove \\r from lines starting with \\n\\r
	--root					# Do not treat root commits as boundaries
	--show-stats					# Include additional statistics
	--reverse					# Walk history forward instead of backward
	--porcelain(-p)					# Show in a format designed for machine consumption
	--line-porcelain					# Show the porcelain format
	--incremental					# Show the result incrementally
	--show-name(-f)					# Show the filename in the original commit
	--show-number(-n)					# Show the line number in the original commit
	--show-email(-e)					# Show the author email instead of author name
	...args
]
# Show message at which patch failures occured
extern "git diff raw" [

	...args
]
# Apply a patch on a git index file and a working tree
extern "git apply" [
	--stat					# Generate a diffstat
	--numstat					# Show number of additions and deletions
	--summary					# Output a condensed summary
	--check					# Just check if the patches can be applied
	--index					# Apply patch to index and working tree
	--cached					# Apply patch to index
	--intent-to-add					# Add entry for file in index with no content
	--3way(-3)					# Attempt a 3 way merge on conflicts
	--reverse(-R)					# Apply the patch in reverse
	--reject					# Leave rejected hunks in *.rej files
	--unidiff-zero					# Do not break on diffs generated using --unified=0
	--apply					# Always apply patches
	--no-add					# Ignore additions made by patches
	--binary					# Also patch binaries
	--ignore-whitespace					# Ignore whitespace change in context lines
	--inaccurate-eof					# Work around some diff versions not detecting newlines at end of file
	--verbose(-v)					# Report progress to stderr
	--recount					# Do not trust the line counts in the hunk headers
	--unsafe-paths					# Allow patches that work outside working area
	...args
]
# Create an archive of files from a named tree
extern "git archive" [
	--list(-l)					# Show all available formats
	--verbose(-v)					# Be verbose
	--worktree-attributes					# Look for attributes in .gitattributes files in the working tree as well
	...args
]
# Find the change that introduced a bug by binary search
extern "git bisect" [
	--no-checkout					# Do not checkout tree, only update BISECT_HEAD
	--first-parent					# On merge commits, follow only the first parent commit
	----term-good					# Print the term for the old state
	----term-bad					# Print the term for the new state
	...args
]
# List, create, or delete branches
extern "git branch" [
	--env-filter					# This filter may be used if you only need to modify the environment
	--tree-filter					# This is the filter for rewriting the tree and its contents
	--index-filter					# This is the filter for rewriting the index
	--parent-filter					# This is the filter for rewriting the commit
	--msg-filter					# This is the filter for rewriting the commit messages
	--commit-filter					# This is the filter for performing the commit
	--tag-name-filter					# This is the filter for rewriting tag names
	--subdirectory-filter					# Only look at the history which touches the given subdirectory
	--prune-empty					# Ignore empty commits generated by filters
	--original					# Use this option to set the namespace where the original commits will be stored
	--force(-f)					# Filter even with refs in refs/original or existing temp directory
	--add					# Add to the list of currently tracked branches instead of replacing it
	--remotes(-r)					# Shows the remote tracking branches
	--all(-a)					# Show both remote-tracking branches and local branches
	--current					# Includes the current branch to the list of revs to be shown
	--topo-order					# Makes commits appear in topological order
	--date-order					# Makes commits appear in date order
	--sparse					# Shows merges only reachable from one tip
	--no-name					# Do not show naming strings for each commit
	--sha1-name					# Name commits with unique prefix
	--no-color					# Turn off colored output
	--delete(-d)					# Delete branch
	--force(-f)					# Reset branch even if it already exists
	--move(-m)					# Rename branch
	--copy(-c)					# Copy branch
	--all(-a)					# Lists both local and remote branches
	--track(-t)					# Track remote branch
	--no-track					# Do not track remote branch
	--set-upstream-to					# Set remote branch to track
	--merged					# List branches that have been merged
	--no-merged					# List branches that have not been merged
	--unset-upstream					# Remove branch upstream information
	--branch(-b)					# Specify the branch to use
	--default(-d)					# Use default branch of the submodule
	...args
]
# Find commits yet to be applied to upstream [upstream [head]]
extern "git cherry" [
	--edit(-e)					# Edit the commit message prior to committing
	--no-commit(-n)					# Apply changes without making any commit
	--signoff(-s)					# Add Signed-off-by line to the commit message
	--ff					# Fast-forward if possible
	--continue					# Continue the operation in progress
	--abort					# Cancel the operation
	--skip					# Skip the current commit and continue with the rest of the sequence
	...args
]
# Clone a repository into a new directory
extern "git clone" [
	--no-hardlinks					# Copy files instead of using hardlinks
	--quiet(-q)					# Operate quietly and do not report progress
	--verbose(-v)					# Provide more information on what is going on
	--no-checkout(-n)					# No checkout of HEAD is performed after the clone is complete
	--bare					# Make a bare Git repository
	--mirror					# Set up a mirror of the source repository
	--origin(-o)					# Use a specific name of the remote instead of the default
	--branch(-b)					# Use a specific branch instead of the one used by the cloned repository
	--depth					# Truncate the history to a specified number of revisions
	--recursive					# Initialize all submodules within the cloned repository
	...args
]
# Record changes to the repository
extern "git commit" [
	--amend					# Amend the log message of the last commit
	--all(-a)					# Automatically stage modified and deleted files
	--patch(-p)					# Use interactive patch selection interface
	--fixup					# Fixup commit to be used with rebase --autosquash
	--squash					# Squash commit to be used with rebase --autosquash
	--reset-author					# When amending, reset author of commit to the committer
	--no-edit					# Use the selected commit message without launching an editor
	--no-gpg-sign					# Do not sign commit
	--no-verify(-n)					# Do not run pre-commit and commit-msg hooks
	--allow-empty					# Create a commit with no changes
	--allow-empty-message					# Create a commit with no commit message
	--signoff(-s)					# Append Signed-off-by trailer to commit message
	--no-signoff					# Do not append Signed-off-by trailer to commit message
	...args
]
# Count unpacked number of objects and their disk consumption
extern "git count-objects" [
	--verbose(-v)					# Be verbose
	--human-readable(-H)					# Print in human readable format
	...args
]
# A really simple server for git repositories
extern "git daemon" [
	--strict-paths					# Match paths exactly
	--base-path-relaxed					# When looking up with base path fails, try without it
	--export-all					# Allow pulling from all directories
	--inetd					# Run as inetd service
	--syslog					# --log-destination=syslog
	--verbose					# Log all details
	--reuseaddr					# Reuse address when binding to listening server
	--detach					# Detach from shell
	--informative-errors					# Report more verbose errors to clients
	--no-informative-errors					# Report less verbose errors to clients
	...args
]
# Give an object a human readable name based on an available ref
extern "git describe" [
	--dirty					# Describe the state of the working tree, append dirty if there are local changes
	--broken					# Describe the state of the working tree, append -broken instead of erroring
	--all					# Use all tags, not just annotated
	--tags					# Use all commits/tags, not just annotated tags
	--contains					# Find the tag that comes after the commit
	--abbrev					# Use <n> digits, or as many digits as needed to form a unique object name
	--candidates					# Consider up to <n> candidates
	--exact-match					# Only output exact matches
	--debug					# Display debug info
	--long					# Always output the long format
	--match					# Only consider tags matching the given glob pattern
	--exclude					# Do not consider tags matching the given glob pattern
	--always					# Show uniquely abbreviated commit object as fallback
	--first-parent					# Follow only the first parent of a merge commit
	...args
]
# Show changes between commits, commit and working tree, etc
extern "git diff" [
	--abbrev					# Show only a partial prefix instead of the full 40-byte hexadecimal object name
	--binary					# Output a binary diff that can be applied with "git-apply
	--check					# Warn if changes introduce conflict markers or whitespace errors
	--color					# Show colored diff
	--color-moved					# Moved lines of code are colored differently
	--color-words					# Equivalent to --word-diff=color plus --word-diff-regex=<regex>
	--compact-summary					# Output a condensed summary of extended header information
	--dst-prefix					# Show the given destination prefix instead of "b/
	--ext-diff					# Allow an external diff helper to be executed
	--find-copies-harder					# Inspect unmodified files as candidates for the source of copy
	--find-object					# Look for differences that change the number of occurrences of the object
	--full-index					# Show the full pre- and post-image blob object names on the "index" line
	--histogram					# Generate a diff using the "histogram diff" algorithm
	--ignore-blank-lines					# Ignore changes whose lines are all blank
	--ignore-cr-at-eol					# Ignore carrige-return at the end of line when doing a comparison
	--ignore-space-at-eol					# Ignore changes in whitespace at EOL
	--indent-heuristic					# Enable the heuristic that shift diff hunk boundaries
	--inter-hunk-context					# Show the context between diff hunks, up to the specified number of lines
	--ita-invisible-in-index					# Make the entry appear as a new file in "git diff" and non-existent in "git diff -l cached
	--line-prefix					# Prepend an additional prefix to every line of output
	--minimal					# Spend extra time to make sure the smallest possible diff is produced
	--name-only					# Show only names of changed files
	--name-status					# Show only names and status of changed files
	--no-color					# Turn off colored diff
	--no-ext-diff					# Disallow external diff drivers
	--no-indent-heuristic					# Disable the indent heuristic
	--no-prefix					# Do not show any source or destination prefix
	--no-renames					# Turn off rename detection
	--no-textconv					# Disallow external text conversion filters to be run when comparing binary files
	--numstat					# Shows number of added/deleted lines in decimal notation
	--patch-with-raw					# Synonym for -p --raw
	--patch-with-stat					# Synonym for -p --stat
	--patience					# Generate a diff using the "patience diff" algorithm
	--pickaxe-all					# When -S or -G finds a change, show all the changes in that changeset
	--pickaxe-regex					# Treat the <string> given to -S as an extended POSIX regular expression to match
	--relative					# Exclude changes outside the directory and show relative pathnames
	--shortstat					# Output only the last line of the --stat format containing total number of modified files
	--src-prefix					# Show the given source prefix instead of "a/
	--stat					# Generate a diffstat
	--stat					# Generate a diffstat
	--summary					# Output a condensed summary of extended header information
	--textconv					# Allow external text conversion filters to be run when comparing binary files
	--word-diff					# Show a word diff
	--word-diff-regex					# Use <regex> to decide what a word is
	--text(-a)					# Treat all files as text
	--break-rewrites(-B)					# Break complete rewrite changes into pairs of delete and create
	--ignore-space-change(-b)					# Ignore changes in amount of whitespace
	--find-copies(-C)					# Detect copies as well as renames
	--irreversible-delete(-D)					# Omit the preimage for deletes
	--find-renames(-M)					# Detect and report renames
	--function-context(-W)					# Show whole surrounding functions of changes
	--ignore-all-space(-w)					# Ignore whitespace when comparing lines
	--anchored					# Generate a diff using the "anchored diff" algorithm
	--cached					# Show diff of changes in the index
	--staged					# Show diff of changes in the index
	--no-index					# Compare two paths on the filesystem
	--exit-code					# Exit with 1 if there were differences or 0 if no differences
	--quiet					# Disable all output of the program, implies --exit-code
	--base(-1)					# Compare the working tree with the "base" version
	--ours(-2)					# Compare the working tree with the "our branch
	--theirs(-3)					# Compare the working tree with the "their branch
	--cached					# Visually show diff of changes in the index
	--gui(-g)					# Use `diff.guitool` instead of `diff.tool`
	--dir-diff(-d)					# Perform a full-directory diff
	--prompt					# Prompt before each invocation of the diff tool
	--no-prompt(-y)					# Do not prompt before launching a diff tool
	--symlinks					# Use symlinks in dir-diff mode
	--tool-help					# Print a list of diff tools that may be used with `--tool`
	--trust-exit-code					# Exit when an invoked diff tool returns a non-zero exit code
	--extcmd(-x)					# Specify a custom command for viewing diffs
	--no-gui					# Overrides --gui setting
	--creation-factor					# Percentage by which creation is weighted
	--no-dual-color					# Use simple diff colors
	...args
]
# Open diffs in a visual tool
extern "git difftool" [
	--cached					# Visually show diff of changes in the index
	--gui(-g)					# Use `diff.guitool` instead of `diff.tool`
	--dir-diff(-d)					# Perform a full-directory diff
	--prompt					# Prompt before each invocation of the diff tool
	--no-prompt(-y)					# Do not prompt before launching a diff tool
	--symlinks					# Use symlinks in dir-diff mode
	--tool-help					# Print a list of diff tools that may be used with `--tool`
	--trust-exit-code					# Exit when an invoked diff tool returns a non-zero exit code
	--extcmd(-x)					# Specify a custom command for viewing diffs
	--no-gui					# Overrides --gui setting
	...args
]
# Cleanup unnecessary files and optimize the local repository
extern "git gc" [
	--aggressive					# Aggressively optimize the repository
	--auto					# Checks any housekeeping is required and then run
	--prune					# Prune loose objects older than date
	--no-prune					# Do not prune any loose objects
	--quiet					# Be quiet
	--force					# Force `git gc` to run
	--keep-largest-pack					# Ignore `gc.bigPackThreshold`
	...args
]
# Print lines matching a pattern
extern "git grep" [
	--cached					# Search blobs registered in the index file
	--no-index					# Search files in the current directory not managed by Git
	--untracked					# Search also in untracked files
	--no-exclude-standard					# Also search in ignored files by not honoring the .gitignore mechanism
	--exclude-standard					# Do not search ignored files specified via the .gitignore mechanism
	--recurse-submodules					# Recursively search in each submodule that is active and checked out in the repository
	--text(-a)					# Process binary files as if they were text
	--textconv					# Honor textconv filter settings
	--no-textconv					# Do not honor textconv filter settings
	--ignore-case(-i)					# Ignore case differences between the patterns and the files
	--recursive(-r)					# Descend into levels of directories endlessly
	--no-recursive					# Do not descend into directories
	--word-regexp(-w)					# Match the pattern only at word boundary
	--invert-match(-v)					# Select non-matching lines
	--full-name					# Forces paths to be output relative to the project top directory
	--extended-regexp(-E)					# Use POSIX extended regexp for patterns
	--basic-regexp(-G)					# Use POSIX basic regexp for patterns
	--perl-regexp(-P)					# Use Perl-compatible regular expressions for patterns
	--fixed-strings(-F)					# Dont interpret pattern as a regex
	--line-number(-n)					# Prefix the line number to matching lines
	--column					# Prefix the 1-indexed byte-offset of the first match from the start of the matching line
	--files-with-matches(-l)					# Show only the names of files that contain matches
	--files-without-match(-L)					# Show only the names of files that do not contain matches
	--null(-z)					# Use \\0 as the delimiter for pathnames in the output, and print them verbatim
	--only-matching(-o)					# Print only the matched parts of a matching line
	--count(-c)					# Instead of showing every matched line, show the number of lines that match
	--no-color					# Turn off match highlighting, even when the configuration file gives the default to color output
	--break					# Print an empty line between matches from different files
	--heading					# Show the filename above the matches in that file instead of at the start of each shown line
	--show-function(-p)					# Show the line that contains the function name of the match, unless the match is a function name itself
	--function-context(-W)					# Show the surrounding text from the line containing a function name up to the one before the next function name
	--and					# Combine patterns using and
	--or					# Combine patterns using or
	--not					# Combine patterns using not
	--all-match					# Only match files that can match all the pattern expressions when giving multiple
	--quiet(-q)					# Just exit with status 0 when there is a match and with non-zero status when there isnt
	...args
]
# Create an empty git repository or reinitialize an existing one
extern "git init" [
	--quiet(-q)					# Only print error and warning messages
	--bare					# Create a bare repository
	--force					# Remove even with local changes
	--all					# Remove all submodules
	...args
]
# Show commit shortlog
extern "git shortlog" [

	...args
]
# Show commit logs
extern "git log" [
	--dst-prefix					# Show the given destination prefix instead of "b/
	--inter-hunk-context					# Show the context between diff hunks, up to the specified number of lines
	--ita-invisible-in-index					# Make the entry appear as a new file in "git diff" and non-existent in "git diff -l cached
	--line-prefix					# Prepend an additional prefix to every line of output
	--no-prefix					# Do not show any source or destination prefix
	--pickaxe-all					# When -S or -G finds a change, show all the changes in that changeset
	--pickaxe-regex					# Treat the <string> given to -S as an extended POSIX regular expression to match
	--relative					# Exclude changes outside the directory and show relative pathnames
	--src-prefix					# Show the given source prefix instead of "a/
	--text(-a)					# Treat all files as text
	--break-rewrites(-B)					# Break complete rewrite changes into pairs of delete and create
	--find-copies(-C)					# Detect copies as well as renames
	--irreversible-delete(-D)					# Omit the preimage for deletes
	--find-renames(-M)					# Detect and report renames
	--follow					# Continue listing file history beyond renames
	--no-decorate					# Dont print ref names
	--decorate					# Print out ref names
	--source					# Print ref name by which each commit was reached
	--use-mailmap
	--full-diff
	--log-size
	--all-match					# Limit commits to ones that match all given --grep
	--invert-grep					# Limit commits to ones with message that dont match --grep
	--regexp-ignore-case(-i)					# Case insensitive match
	--basic-regexp					# Patterns are basic regular expressions (default)
	--extended-regexp(-E)					# Patterns are extended regular expressions
	--fixed-strings(-F)					# Patterns are fixed strings
	--perl-regexp					# Patterns are Perl-compatible regular expressions
	--remove-empty					# Stop when given path disappears from tree
	--merges					# Print only merge commits
	--no-merges					# Dont print commits with more than one parent
	--no-min-parents					# Show only commit without a minimum number of parents
	--no-max-parents					# Show only commit without a maximum number of parents
	--first-parent					# Follow only the first parent commit upon seeing a merge commit
	--not					# Reverse meaning of ^ prefix
	--all					# Show log for all branches, tags, and remotes
	--branches					# Show log for all matching branches
	--tags					# Show log for all matching tags
	--remotes					# Show log for all matching remotes
	--reflog					# Show log for all reflogs entries
	--ingnore-missing					# Ignore invalid object names
	--bisect
	--stdin					# Read commits from stdin
	--cherry-mark					# Mark equivalent commits with = and inequivalent with +
	--cherry-pick					# Omit equivalent commits
	--left-only
	--rigth-only
	--cherry
	--walk-reflogs(-g)
	--merge
	--boundary
	--simplify-by-decoration
	--full-history
	--dense
	--sparse
	--simplify-merges
	--ancestry-path
	--date-order
	--author-date-order
	--topo-order
	--reverse
	--no-walk
	--do-walk
	--format
	--abbrev-commit
	--no-abbrev-commit
	--oneline
	--expand-tabs
	--no-expand-tabs
	--notes
	--no-notes
	--show-notes
	--standard-notes
	--no-standard-notes
	--show-signature
	--relative-date
	--parents
	--children
	--left-right
	--graph
	--show-linear-break
	--cc
	--patch(-p)
	--no-patch(-s)
	--raw
	--patch-with-raw
	--indent-heuristic
	--no-indent-heuristic
	--compaction-heuristic
	--no-compaction-heuristic
	--minimal
	--patience
	--histogram
	--numstat
	--shortstat
	--summary
	--patch-with-stat
	--name-only
	--name-status
	--color
	--no-color
	--word-diff
	--color-words
	--no-renames
	--check
	--full-index
	--binary
	--abbrev
	--find-copies-harder					# Also inspect unmodified files as source for a copy
	--ignore-space-at-eol					# Ignore changes in whitespace at EOL
	--ignore-space-change(-b)					# Ignore changes in amount of whitespace
	--ignore-all-space(-w)					# Ignore whitespace when comparing lines
	--ignore-blank-lines					# Ignore changes whose lines are all blank
	--function-context(-W)					# Show whole surrounding functions of changes
	--ext-diff					# Allow an external diff helper to be executed
	--no-ext-diff					# Disallow external diff helpers
	--no-textconv					# Disallow external text conversion filters for binary files (Default)
	--textconv					# Allow external filters for binary files (Resulting diff is unappliable)
	--no-prefix					# Do not show source or destination prefix
	...args
]
# 
extern "git sorted unsorted" [

	...args
]
# 
extern "git always never auto" [

	...args
]
# Show information about files in the index and the working tree
extern "git ls-files" [
	--cached(-c)					# Show cached files in the output
	--deleted(-d)					# Show deleted files in the output
	--modified(-m)					# Show modified files in the output
	--others(-o)					# Show other (i.e. untracked) files in the output
	--ignored(-i)					# Show only ignored files in the output
	--stage(-s)					# Show staged contents' mode bits, object name and stage number in the output
	--directory					# If a whole directory is classified as "other", show just its name
	--no-empty-directory					# Do not list empty directories
	--unmerged(-u)					# Show unmerged files in the output
	--killed(-k)					# Show files on the filesystem that need to be removed for checkout-index to succeed
	--exclude(-x)					# Skip untracked files matching pattern
	--exclude-from(-X)					# Read exclude patterns from <file>; 1 per line
	--exclude-per-directory					# Read extra exclude patterns that apply only to the dir and its subdirs in <file>
	--exclude-standard					# Add the standard Git exclusions
	--error-unmatch					# If any <file> does not appear in the index, treat this as an error
	--with-tree
	--full-name					# Force paths to be output relative to the project top directory
	--recurse-submodules					# Recursively calls ls-files on each submodule in the repository
	--abbrev					# Show only a partial prefix
	--debug					# After each line that describes a file, add more data about its cache entry
	--eol					# Show <eolinfo> and <eolattr> of files
	...args
]
# Extracts patch and authorship from a single e-mail message
extern "git mailinfo" [
	--message-id(-m)					# Copy message id to the end of commit message
	--scissors					# Remove everything above scissor line
	--no-scissors					# Ignore scissor lines
	...args
]
# Simple UNIX mbox splitter program
extern "git mailsplit" [
	--keep-cr					# Do not remove \\r from lines starting with \\n\\r
	--mboxrd					# Input is of mboxrd form
	...args
]
# Run tasks to optimize Git repository data
extern "git maintenance" [
	--quiet					# Supress logs
	--auto					# Run maintenance only when necessary
	--schedule					# Run maintenance on certain intervals
	...args
]
# Initialize Git config vars for maintenance
extern "git register" [

	...args
]
# Run one or more maintenance tasks
extern "git run" [
	--dry-run					# Report what will be pruned but do not actually prune it
	--verbose(-v)					# Be more verbose
	--quiet(-q)					# Operate quietly
	--dry-run(-n)					# Just report what it would remove
	--verbose(-v)					# Report all removed objects
	--progress					# Show progress
	--dry-run(-n)					# Do not remove anything
	--verbose(-v)					# Report all removals
	...args
]
# Start maintenance
extern "git start" [
	--no-checkout					# Do not checkout tree, only update BISECT_HEAD
	--first-parent					# On merge commits, follow only the first parent commit
	...args
]
# Halt background maintenance
extern "git stop" [

	...args
]
# Remove repository from background maintenance
extern "git unregister" [

	...args
]
# Join two or more development histories together
extern "git merge" [
	--commit					# Autocommit the merge
	--no-commit					# Don't autocommit the merge
	--edit(-e)					# Edit auto-generated merge message
	--no-edit					# Don't edit auto-generated merge message
	--ff					# Don't generate a merge commit if merge is fast-forward
	--no-ff					# Generate a merge commit even if merge is fast-forward
	--ff-only					# Refuse to merge unless fast-forward possible
	--gpg-sign(-S)					# GPG-sign the merge commit
	--log					# Populate the log message with one-line descriptions
	--no-log					# Don't populate the log message with one-line descriptions
	--signoff					# Add Signed-off-by line at the end of the merge commit message
	--no-signoff					# Do not add a Signed-off-by line at the end of the merge commit message
	--stat					# Show diffstat of the merge
	--no-stat(-n)					# Don't show diffstat of the merge
	--squash					# Squash changes from other branch as a single commit
	--no-squash					# Don't squash changes
	--verify-signatures					# Abort merge if other branch tip commit is not signed with a valid key
	--no-verify-signatures					# Do not abort merge if other branch tip commit is not signed with a valid key
	--quiet(-q)					# Be quiet
	--verbose(-v)					# Be verbose
	--progress					# Force progress status
	--no-progress					# Force no progress status
	--allow-unrelated-histories					# Allow merging even when branches do not share a common history
	--rerere-autoupdate					# If possible, use previous conflict resolutions
	--no-rerere-autoupdate					# Do not use previous conflict resolutions
	--abort					# Abort the current conflict resolution process
	--continue					# Conclude current conflict resolution process
	--all(-a)					# Output all merge bases for the commits, instead of just one
	--octopus					# Compute the best common ancestors of all supplied commits
	--independent					# Print a minimal subset of the supplied commits with the same ancestors
	--is-ancestor					# Check if the first commit is an ancestor of the second commit
	--fork-point					# Find the point at which a branch forked from another branch ref
	--tool-help					# Print a list of merge tools that may be used with `--tool`
	--no-prompt(-y)					# Do not prompt before launching a diff tool
	--prompt					# Prompt before each invocation of the merge resolution program
	--verbose(-v)					# Be more verbose
	--quiet(-q)					# Operate quietly
	--commit					# Finalize git notes merge
	--abort					# Abort git notes merge
	...args
]
# Find as good common ancestors as possible for a merge
extern "git merge-base" [
	--all(-a)					# Output all merge bases for the commits, instead of just one
	--octopus					# Compute the best common ancestors of all supplied commits
	--independent					# Print a minimal subset of the supplied commits with the same ancestors
	--is-ancestor					# Check if the first commit is an ancestor of the second commit
	--fork-point					# Find the point at which a branch forked from another branch ref
	...args
]
# Run merge conflict resolution tools to resolve merge conflicts
extern "git mergetool" [
	--tool-help					# Print a list of merge tools that may be used with `--tool`
	--no-prompt(-y)					# Do not prompt before launching a diff tool
	--prompt					# Prompt before each invocation of the merge resolution program
	...args
]
# Move or rename a file, a directory, or a symlink
extern "git mv" [
	--force(-f)					# Force rename/moving even if target exists
	--dry-run(-n)					# Only show what would happen
	--verbose(-v)					# Report names of files as they are changed
	...args
]
# Add or inspect object notes
extern "git notes" [
	--force(-f)					# Overwrite existing notes
	--allow-empty					# Allow empty note
	--stdin					# Read object names from stdin
	--verbose(-v)					# Be more verbose
	--quiet(-q)					# Operate quietly
	--commit					# Finalize git notes merge
	--abort					# Abort git notes merge
	--ignore-missing					# Do not throw error on deleting non-existing object note
	...args
]
# List notes for given object
extern "git list" [
	--porcelain					# Output in an easy-to-parse format for scripts
	...args
]
# Copy notes from object1 to object2
extern "git copy" [
	--force(-f)					# Overwrite existing notes
	--stdin					# Read object names from stdin
	...args
]
# Append to the notes of existing object
extern "git append" [
	--allow-empty					# Allow empty note
	...args
]
# Edit notes for a given object
extern "git edit" [
	--allow-empty					# Allow empty note
	...args
]
# Print current notes ref
extern "git get-ref" [

	...args
]
# Fetch from and merge with another repository or a local branch
extern "git pull" [
	--unshallow					# Convert a shallow repository to a complete one
	--set-upstream					# Add upstream (tracking) reference
	--quiet(-q)					# Be quiet
	--verbose(-v)					# Be verbose
	--all					# Fetch all remotes
	--append(-a)					# Append ref names and object names
	--force(-f)					# Force update of local branches
	--keep(-k)					# Keep downloaded pack
	--no-tags					# Disable automatic tag following
	--prune(-p)					# Remove remote-tracking references that no longer exist on the remote
	--progress					# Force progress status
	--commit					# Autocommit the merge
	--no-commit					# Don't autocommit the merge
	--edit(-e)					# Edit auto-generated merge message
	--no-edit					# Don't edit auto-generated merge message
	--ff					# Don't generate a merge commit if merge is fast-forward
	--no-ff					# Generate a merge commit even if merge is fast-forward
	--ff-only					# Refuse to merge unless fast-forward possible
	--gpg-sign(-S)					# GPG-sign the merge commit
	--log					# Populate the log message with one-line descriptions
	--no-log					# Don't populate the log message with one-line descriptions
	--signoff					# Add Signed-off-by line at the end of the merge commit message
	--no-signoff					# Do not add a Signed-off-by line at the end of the merge commit message
	--stat					# Show diffstat of the merge
	--no-stat(-n)					# Don't show diffstat of the merge
	--squash					# Squash changes from upstream branch as a single commit
	--no-squash					# Don't squash changes
	--verify-signatures					# Abort merge if upstream branch tip commit is not signed with a valid key
	--no-verify-signatures					# Do not abort merge if upstream branch tip commit is not signed with a valid key
	--allow-unrelated-histories					# Allow merging even when branches do not share a common history
	--rebase(-r)					# Rebase the current branch on top of the upstream branch
	--no-rebase					# Do not rebase the current branch on top of the upstream branch
	--autostash					# Before starting rebase, stash local changes, and apply stash when done
	--no-autostash					# Do not stash local changes before starting rebase
	...args
]
# Compare two commit ranges (e.g. two versions of a branch)
extern "git range-diff" [
	--abbrev					# Show only a partial prefix instead of the full 40-byte hexadecimal object name
	--binary					# Output a binary diff that can be applied with "git-apply
	--check					# Warn if changes introduce conflict markers or whitespace errors
	--color					# Show colored diff
	--color-moved					# Moved lines of code are colored differently
	--color-words					# Equivalent to --word-diff=color plus --word-diff-regex=<regex>
	--compact-summary					# Output a condensed summary of extended header information
	--dst-prefix					# Show the given destination prefix instead of "b/
	--ext-diff					# Allow an external diff helper to be executed
	--find-copies-harder					# Inspect unmodified files as candidates for the source of copy
	--find-object					# Look for differences that change the number of occurrences of the object
	--full-index					# Show the full pre- and post-image blob object names on the "index" line
	--histogram					# Generate a diff using the "histogram diff" algorithm
	--ignore-blank-lines					# Ignore changes whose lines are all blank
	--ignore-cr-at-eol					# Ignore carrige-return at the end of line when doing a comparison
	--ignore-space-at-eol					# Ignore changes in whitespace at EOL
	--indent-heuristic					# Enable the heuristic that shift diff hunk boundaries
	--inter-hunk-context					# Show the context between diff hunks, up to the specified number of lines
	--ita-invisible-in-index					# Make the entry appear as a new file in "git diff" and non-existent in "git diff -l cached
	--line-prefix					# Prepend an additional prefix to every line of output
	--minimal					# Spend extra time to make sure the smallest possible diff is produced
	--name-only					# Show only names of changed files
	--name-status					# Show only names and status of changed files
	--no-color					# Turn off colored diff
	--no-ext-diff					# Disallow external diff drivers
	--no-indent-heuristic					# Disable the indent heuristic
	--no-prefix					# Do not show any source or destination prefix
	--no-renames					# Turn off rename detection
	--no-textconv					# Disallow external text conversion filters to be run when comparing binary files
	--numstat					# Shows number of added/deleted lines in decimal notation
	--patch-with-raw					# Synonym for -p --raw
	--patch-with-stat					# Synonym for -p --stat
	--patience					# Generate a diff using the "patience diff" algorithm
	--pickaxe-all					# When -S or -G finds a change, show all the changes in that changeset
	--pickaxe-regex					# Treat the <string> given to -S as an extended POSIX regular expression to match
	--relative					# Exclude changes outside the directory and show relative pathnames
	--shortstat					# Output only the last line of the --stat format containing total number of modified files
	--src-prefix					# Show the given source prefix instead of "a/
	--stat					# Generate a diffstat
	--stat					# Generate a diffstat
	--summary					# Output a condensed summary of extended header information
	--textconv					# Allow external text conversion filters to be run when comparing binary files
	--word-diff					# Show a word diff
	--word-diff-regex					# Use <regex> to decide what a word is
	--text(-a)					# Treat all files as text
	--break-rewrites(-B)					# Break complete rewrite changes into pairs of delete and create
	--ignore-space-change(-b)					# Ignore changes in amount of whitespace
	--find-copies(-C)					# Detect copies as well as renames
	--irreversible-delete(-D)					# Omit the preimage for deletes
	--find-renames(-M)					# Detect and report renames
	--function-context(-W)					# Show whole surrounding functions of changes
	--ignore-all-space(-w)					# Ignore whitespace when comparing lines
	--anchored					# Generate a diff using the "anchored diff" algorithm
	--creation-factor					# Percentage by which creation is weighted
	--no-dual-color					# Use simple diff colors
	...args
]
# Forward-port local commits to the updated upstream head
extern "git rebase" [
	--continue					# Restart the rebasing process
	--abort					# Abort the rebase operation
	--edit-todo					# Edit the todo list
	--keep-empty					# Keep the commits that don't change anything
	--skip					# Restart the rebasing process by skipping the current patch
	--merge(-m)					# Use merging strategies to rebase
	--quiet(-q)					# Be quiet
	--verbose(-v)					# Be verbose
	--stat					# Show diffstat of the rebase
	--no-stat(-n)					# Don't show diffstat of the rebase
	--verify					# Allow the pre-rebase hook to run
	--no-verify					# Don't allow the pre-rebase hook to run
	--force-rebase(-f)					# Force the rebase
	--committer-date-is-author-date					# Use the author date as the committer date
	--ignore-date					# Use the committer date as the author date
	--interactive(-i)					# Interactive mode
	--preserve-merges(-p)					# Try to recreate merges
	--rebase-merges(-r)					# Preserve branch structure
	--root					# Rebase all reachable commits
	--autosquash					# Automatic squashing
	--no-autosquash					# No automatic squashing
	--autostash					# Before starting rebase, stash local changes, and apply stash when done
	--no-autostash					# Do not stash local changes before starting rebase
	--no-ff					# No fast-forward
	...args
]
# Preserve branch structure
extern "git rebase-cousins no-rebase-cousins" [

	...args
]
# Manage reflog information
extern "git reflog" [

	...args
]
# Reset current HEAD to the specified state
extern "git reset" [
	--hard					# Reset the index and the working tree
	--soft					# Reset head without touching the index or the working tree
	--mixed					# The default: reset the index but not the working tree
	...args
]
# Restore working tree files
extern "git restore" [
	--patch(-p)					# Interactive mode
	--worktree(-W)					# Restore working tree (default)
	--staged(-S)					# Restore the index
	--ours					# When restoring files, use stage #2 (ours)
	--theirs					# When restoring files, use stage #3 (theirs)
	--merge(-m)					# Recreate the conflicted merge in the unmerged paths when restoring files
	--ignore-unmerged					# When restoring files, do not abort the operation if there are unmerged entries
	--ignore-skip-worktree-bits					# Ignore the sparse-checkout file and unconditionally restore any files in <pathspec>
	--overlay					# Never remove files when restoring
	--no-overlay					# Remove files when restoring (default)
	--quiet(-q)					# Suppress messages
	--progress					# Report progress status to stderr (default)
	--no-progress					# Do not report progress status to stderr
	--conflict=merge					# Same as --merge, but specify merge as the conflicting hunk style (default)
	--conflict=diff3					# Same as --merge, but specify diff3 as the conflicting hunk style
	...args
]
# Pick out and massage parameters
extern "git rev-parse" [
	--abbrev-ref					# Output non-ambiguous short object names
	...args
]
# Revert an existing commit
extern "git revert" [
	--continue					# Continue the operation in progress
	--abort					# Cancel the operation
	--skip					# Skip the current commit and continue with the rest of the sequence
	--quit					# Forget about the current operation in progress
	--no-edit					# Do not start the commit message editor
	--no-commit(-n)					# Apply changes to index but dont create a commit
	--signoff(-s)					# Add a Signed-off-by trailer at the end of the commit message
	--rerere-autoupdate					# Allow the rerere mechanism to update the index with the result of auto-conflict resolution
	--no-rerere-autoupdate					# Prevent the rerere mechanism from updating the index with auto-conflict resolution
	...args
]
# Show the working tree status
extern "git status" [
	--short(-s)					# Give the output in the short-format
	--branch(-b)					# Show the branch and tracking info even in short-format
	--porcelain					# Give the output in a stable, easy-to-parse format
	--verbose(-v)					# Also show the textual changes that are staged to be committed
	--no-ahead-behind					# Do not display detailed ahead/behind upstream-branch counts
	--renames					# Turn on rename detection regardless of user configuration
	--no-renames					# Turn off rename detection regardless of user configuration
	--cached					# Use the commit stored in the index
	--recursive					# Traverse submodules recursively
	...args
]
# Remove unnecessary whitespace
extern "git stripspace" [
	--strip-comments(-s)					# Strip all lines starting with comment character
	--comment-lines(-c)					# Prepend comment character to each line
	...args
]
# Create, list, delete or verify a tag object signed with GPG
extern "git tag" [
	--annotate(-a)					# Make an unsigned, annotated tag object
	--sign(-s)					# Make a GPG-signed tag
	--delete(-d)					# Remove a tag
	--verify(-v)					# Verify signature of a tag
	--force(-f)					# Force overwriting existing tag
	--list(-l)					# List tags
	--contains					# List tags that contain a commit
	...args
]
# Manage multiple working trees
extern "git worktree" [
	--force(-f)					# Override safeguards
	--detach					# Detach HEAD in the new working tree
	--checkout					# Checkout <commit-ish> after creating working tree
	--no-checkout					# Suppress checkout
	--guess-remote
	--no-guess-remote
	--track					# Mark <commit-ish> as "upstream" from the new branch
	--no-track					# Dont mark <commit-ish> as "upstream" from the new branch
	--lock					# Lock working tree after creation
	--quiet(-q)					# Suppress feedback messages
	--porcelain					# Output in an easy-to-parse format for scripts
	--dry-run(-n)					# Do not remove anything
	--verbose(-v)					# Report all removals
	...args
]
# Lock a working tree
extern "git lock" [

	...args
]
# Move a working tree to a new location
extern "git move" [
	--stdin					# Read object names from stdin
	--verbose(-v)					# Be more verbose
	--quiet(-q)					# Operate quietly
	--ignore-missing					# Do not throw error on deleting non-existing object note
	--force(-f)					# Override safeguards
	...args
]
# Unlock a working tree
extern "git unlock" [

	...args
]
# Stash away changes
extern "git stash" [
	--patch(-p)					# Interactively select hunks
	--message(-m)					# Add a description
	...args
]
# Apply and remove a single stashed state
extern "git pop" [

	...args
]
# Remove all stashed states
extern "git clear" [

	...args
]
# Remove a single stashed state from the stash list
extern "git drop" [

	...args
]
# Create a stash
extern "git create" [

	...args
]
# Save a new stash
extern "git save" [

	...args
]
# Set and read git configuration variables
extern "git config" [
	--global					# Get/set global configuration
	--system					# Get/set system configuration
	--local					# Get/set local repo configuration
	--get					# Get config with name
	--get-all					# Get all values matching key
	--replace-all					# Replace all matching variables
	--unset					# Remove a variable
	--unset-all					# Remove matching variables
	--list(-l)					# List all variables
	--edit(-e)					# Open configuration in an editor
	--type(-t)					# Value is of given type
	--bool					# Value is true or false
	--int					# Value is a decimal number
	--bool-or-int					# Value is --bool or --int
	--path					# Value is a path
	--expiry-date					# Value is an expiry date
	--null(-z)					# Terminate values with NUL byte
	--name-only					# Show variable names only
	--includes					# Respect include directives
	--show-origin					# Show origin of configuration
	--default					# Use default value when missing entry
	...args
]
# Generate patch series to send upstream
extern "git format-patch" [
	--output-directory(-o)
	--no-stat(-p)					# Generate plain patches without diffstat
	--no-patch(-s)					# Suppress diff output
	--minimal					# Spend more time to create smaller diffs
	--patience					# Generate diff with the 'patience' algorithm
	--histogram					# Generate diff with the 'histogram' algorithm
	--stdout					# Print all commits to stdout in mbox format
	--numstat					# Show number of added/deleted lines in decimal notation
	--shortstat					# Output only last line of the stat
	--summary					# Output a condensed summary of extended header information
	--no-renames					# Disable rename detection
	--full-index					# Show full blob object names
	--binary					# Output a binary diff for use with git apply
	--find-copies-harder					# Also inspect unmodified files as source for a copy
	--text(-a)					# Treat all files as text
	--ignore-space-at-eol					# Ignore changes in whitespace at EOL
	--ignore-space-change(-b)					# Ignore changes in amount of whitespace
	--ignore-all-space(-w)					# Ignore whitespace when comparing lines
	--ignore-blank-lines					# Ignore changes whose lines are all blank
	--function-context(-W)					# Show whole surrounding functions of changes
	--ext-diff					# Allow an external diff helper to be executed
	--no-ext-diff					# Disallow external diff helpers
	--no-textconv					# Disallow external text conversion filters for binary files (Default)
	--textconv					# Allow external filters for binary files (Resulting diff is unappliable)
	--no-prefix					# Do not show source or destination prefix
	--numbered(-n)					# Name output in [Patch n/m] format, even with a single patch
	--no-numbered(-N)					# Name output in [Patch] format, even with multiple patches
	...args
]
# Initialize, update or inspect submodules
extern "git submodule" [
	--quiet(-q)					# Only print error messages
	--init					# Initialize all submodules
	--checkout					# Checkout the superproject's commit on a detached HEAD in the submodule
	--merge					# Merge the superproject's commit into the current branch of the submodule
	--rebase					# Rebase current branch onto the superproject's commit
	--no-fetch(-N)					# Don't fetch new objects from the remote
	--remote					# Instead of using superproject's SHA-1, use the state of the submodule's remote-tracking branch
	--force					# Discard local changes when switching to a different commit & always run checkout
	--force					# Also add ignored submodule path
	--force					# Remove even with local changes
	--all					# Remove all submodules
	--branch(-b)					# Specify the branch to use
	--default(-d)					# Use default branch of the submodule
	--cached					# Use the commit stored in the index
	--files					# Compare the commit in the index with submodule HEAD
	--recursive					# Traverse submodules recursively
	...args
]
# Unregister the given submodules
extern "git deinit" [
	--force					# Remove even with local changes
	--all					# Remove all submodules
	...args
]
# Show commit summary
extern "git summary" [
	--cached					# Use the commit stored in the index
	--files					# Compare the commit in the index with submodule HEAD
	...args
]
# Run command on each submodule
extern "git foreach" [
	--recursive					# Traverse submodules recursively
	...args
]
# Sync submodules URL with .gitmodules
extern "git sync" [

	...args
]
# Move submodules git directory to current .git/module directory
extern "git absorbgitdirs" [

	...args
]
# Show logs with difference each commit introduces
extern "git whatchanged" [

	...args
]
# Remove untracked files from the working tree
extern "git clean" [
	--force(-f)					# Force run
	--interactive(-i)					# Show what would be done and clean files interactively
	--dry-run(-n)					# Dont actually remove anything, just show what would be done
	--quiet(-q)					# Be quiet, only report errors
	...args
]
# Show what revision and author last modified each line of a file
extern "git blame" [
	--root					# Do not treat root commits as boundaries
	--show-stats					# Include additional statistics
	--reverse					# Walk history forward instead of backward
	--porcelain(-p)					# Show in a format designed for machine consumption
	--line-porcelain					# Show the porcelain format
	--incremental					# Show the result incrementally
	--show-name(-f)					# Show the filename in the original commit
	--show-number(-n)					# Show the line number in the original commit
	--show-email(-e)					# Show the author email instead of author name
	...args
]
# Display help information about Git
extern "git help" [

	...args
]
