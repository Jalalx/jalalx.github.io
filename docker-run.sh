docker build . -t blog:v1
docker run --rm --volume="${PWD}:/srv/jekyll" --volume="${PWD}/vendor/bundle:/usr/local/bundle" --env JEKYLL_ENV=development -p 4000:4000 --name jekyll-blog  blog:v1