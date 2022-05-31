{ pkgs
, mach-nix
# a list of strings identifying tahoe-lafs extras, the dependencies of which
# the resulting package will also depend on.  Include all of the runtime
# extras by default because the incremental cost of including them is a lot
# smaller than the cost of re-building the whole thing to add them.
, extras ? [ "tor" "i2p" ]
}:
# The project name, version, and most other metadata are automatically
# extracted from the source.  Some requirements are not properly extracted
# and those cases are handled below.  The version can only be extracted if
# `setup.py update_version` has been run (this is not at all ideal but it
# seems difficult to fix) - so for now just be sure to run that first.
mach-nix.buildPythonPackage rec {
  # Define the location of the Tahoe-LAFS source to be packaged.  Clean up all
  # as many of the non-source files (eg the `.git` directory, `~` backup
  # files, nix's own `result` symlink, etc) as possible to avoid needing to
  # re-build when files that make no difference to the package have changed.
  src = ./.;

  # Select whichever package extras were requested.
  inherit extras;

  # Specify where mach-nix should find packages for our Python dependencies.
  # There are some reasonable defaults so we only need to specify certain
  # packages where the default configuration runs into some issue.
  providers = {
  };

  # Define certain overrides to the way Python dependencies are built.
  _ = {
    # Remove a click-default-group patch for a test suite problem which no
    # longer applies because the project apparently no longer has a test suite
    # in its source distribution.
    # click-default-group.patches = [];
  };

  passthru.meta.mach-nix = {
    inherit providers _;
  };
}
