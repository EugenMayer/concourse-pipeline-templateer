#!/bin/bash
echo "building gem"
gem build ctpl.gemspec
version=`cat VERSION`
gem install ctpl-$version.gem
rm ctpl-$version.gem
