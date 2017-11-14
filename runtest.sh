rm -rf ./testimages
mkdir ./testimages

docker build -t test . && docker run -it --volume `pwd`:/output test