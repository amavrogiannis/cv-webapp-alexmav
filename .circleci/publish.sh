#!/bin/bash
rm -R public/
hugo
~/.local/bin/aws s3 sync public/ s3://cv.alexmav.co.uk --delete