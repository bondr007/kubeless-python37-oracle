# Subject to change. Gather the datetime in YYYYMMDDhhmmss to use as the version tag.
version=$BUILD_NUMBER

##### Build the tomcat 9
docker build -t nsut-gitlab01.nsuok.edu:4567/nsu-enterprise/kubeless-python37-oracle:$version .

# Add the latest tag to the new build.
docker tag nsut-gitlab01.nsuok.edu:4567/nsu-enterprise/kubeless-python37-oracle:$version nsut-gitlab01.nsuok.edu:4567/nsu-enterprise/kubeless-python37-oracle:latest

# Push the images to the repo.
echo $autoPass | docker login --username automation --password-stdin nsut-gitlab01.nsuok.edu:4567
docker push nsut-gitlab01.nsuok.edu:4567/nsu-enterprise/kubeless-python37-oracle:$version
docker push nsut-gitlab01.nsuok.edu:4567/nsu-enterprise/kubeless-python37-oracle:latest

