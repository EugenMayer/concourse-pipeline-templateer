#!/bin/bash
#!/bin/bash
gem build ctpl.gemspec
version=`cat VERSION`
gem push ctpl-$version.gem
rm ctpl-$version.gem
git tag $version
git push
git push --tags