# Waylay Internal Documentation

This image adds the Waylay project's documentation to facilitate faster documentation testing.

To preview the portal

`make preview`

To build the site

`make`

This will create a new directory `site` with the final static website.

## Adding a project

1. Make sure the project has a `docs` folder.
1. Add the project to the `clone` target in the `Makefile`
1. Add a line to the `Dockerfile` to add the docs folder to the container
