FROM jekyll/jekyll:4.0

WORKDIR /srv/jekyll/
ENV JEKYLL_ENV=development

COPY ./Gemfile ./Gemfile

RUN bundle install

COPY . .
RUN jekyll build

ENTRYPOINT [ "jekyll", "serve", "--force_polling", "--livereload", "--skip-initial-build" ]
