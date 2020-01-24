#!/bin/sh -e

stack build
cp $(stack path --local-install-root)/bin/hello-world .aws-sam/build/HelloWorldFunction/bootstrap
cp template.yaml .aws-sam/build/