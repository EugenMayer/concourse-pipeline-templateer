#!/bin/bash

set -e
gem build ctpl.gemspec
version=`cat VERSION`
gem nexus ctpl-$version.gem
rm -f ctpl-$version.gem
git tag $version || true
git push --tags
